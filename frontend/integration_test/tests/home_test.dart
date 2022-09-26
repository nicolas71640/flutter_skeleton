import 'dart:convert';

import 'package:avecpaulette/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:avecpaulette/features/home/presentation/widgets/tile/info_tile_swiper.dart';
import 'package:avecpaulette/injection_container.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../utils/api_utils.dart';
import '../utils/test_utils.dart';
import 'credentials_test.mocks.dart';
import 'package:location/location.dart';
import 'package:integration_test/integration_test.dart';
import 'package:avecpaulette/core/util/asset_utils.dart';

import 'package:flutter/services.dart' show rootBundle;

@GenerateMocks([
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  CredentialsApiService,
  Location,
  LocationData
])
Future<T?> waitForValueMatchingPredicate<T>(WidgetTester tester,
    Future<T> Function() getValue, bool Function(T) predicate,
    {int maxTries = 100}) async {
  for (int i = 0; i < maxTries; i++) {
    final T value = await getValue();
    if (predicate(value)) {
      return value;
    }
    await tester.pump();
  }
  return null;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  GoogleMapsFlutterPlatform.instance.enableDebugInspection();

  late MockLocation mockLocation;

  setUp(() async {
    init();

    sl.unregister<Location>();
    mockLocation = MockLocation();
    final locationData = MockLocationData();
    when(locationData.latitude).thenReturn(48.853543);
    when(locationData.longitude).thenReturn(2.337553);
    when(mockLocation.getLocation())
        .thenAnswer((_) => Future.value(locationData));
    sl.registerLazySingleton<Location>(() => mockLocation);

    await sl.allReady();
    await ApiUtils().cleanLocalDb().first;
    await ApiUtils().deleteUser(email: "test@test.com").first;
    await ApiUtils().signupUser().first;
  });

  tearDown(() {
    sl.reset();
  });

  testWidgets(
    "should display google map with markers",
    (WidgetTester tester) async {
      final expectedCottages = await rootBundle
          .loadString("assets/cottages.json")
          .then((jsonStr) => jsonDecode(jsonStr));
      final expectedMarkers = expectedCottages
          .map((cottageJson) => Marker(
              markerId: MarkerId(cottageJson["title"]),
              position:
                  LatLng(cottageJson["latitude"], cottageJson["longitude"])))
          .toList();
      expectedMarkers.sort(
          (a, b) => a.markerId.toString().compareTo(b.markerId.toString()));

      await TestUtils.startApp(tester, keyToFind: "home_map");

      //Check if the map is visible
      expect(find.byType(GoogleMap), findsOneWidget);

      //Wait for and check that markers are visible and at the right position
      final actualMarkers = (await TestUtils.pumpUntilMatch<Set<Marker>>(
              tester,
              () => Future.value(
                  (tester.widget(find.byType(GoogleMap)) as GoogleMap).markers),
              (markers) => markers.isNotEmpty))
          ?.toList();

      actualMarkers?.sort(
          (a, b) => a.markerId.toString().compareTo(b.markerId.toString()));

      BitmapDescriptor smallMarker =
          await AssetUtils.getBitmapDescriptorFromAssetBytes(
              "assets/small_cottage_marker.png", 50);

      for (int i = 0; i < expectedMarkers.length; i++) {
        expect(actualMarkers![i].markerId, equals(expectedMarkers[i].markerId));
        expect(actualMarkers[i].position.latitude,
            equals(expectedMarkers[i].position.latitude));
        expect(actualMarkers[i].position.longitude,
            equals(expectedMarkers[i].position.longitude));
        expect(
            actualMarkers[i].icon.toString(), equals(smallMarker.toString()));
      }

      //Simulate a tap on one of the marker
      (tester.widget(find.byType(GoogleMap)) as GoogleMap)
          .markers
          .firstWhere((marker) => marker.markerId.value == "MySecondCottage")
          .onTap
          ?.call();

      //Check that the marker icon size increased
      BitmapDescriptor bigMarker =
          await AssetUtils.getBitmapDescriptorFromAssetBytes(
              "assets/big_cottage_marker.png", 50);

      await TestUtils.pumpUntilMatch<Set<Marker>>(
          tester,
          () => Future.value(
              (tester.widget(find.byType(GoogleMap)) as GoogleMap).markers),
          (markers) =>
              markers
                  .firstWhere(
                      (marker) => marker.markerId.value == "MySecondCottage")
                  .icon
                  .toString() ==
              bigMarker.toString());

      //Check that the tile swiper is displayed
      await TestUtils.pumpUntilFound(tester, find.byType(TileSwiper));

      await tester.dragUntilVisible(
        find.text("MyThirdCottage"),
        find.byType(PageView),
        const Offset(-250, 0),
      );

      //Check that the marker corresponding to the third cottage has been marked as selected
      expect(
          (tester.widget(find.byType(GoogleMap)) as GoogleMap)
              .markers
              .firstWhere((marker) => marker.markerId.value == "MyThirdCottage")
              .icon
              .toString(),
          bigMarker.toString());

      expect(
          (tester.widget(find.byType(GoogleMap)) as GoogleMap)
              .markers
              .where((marker) => marker.markerId.value != "MyThirdCottage")
              .map((marker) => marker.icon.toString()),
          {smallMarker.toString(), smallMarker.toString()});
    },
  );
}
