import 'package:avecpaulette/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:avecpaulette/injection_container.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../robots/app_robot.dart';
import '../robots/home_robot.dart';
import '../utils/api_utils.dart';
import 'home_test.mocks.dart';
import 'package:location/location.dart';
import 'package:integration_test/integration_test.dart';

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
      final homeRobot = HomeRobot(tester);

      await AppRobot(tester).startApp(keyToFind: "home_map");

      //Wait for and check that markers are visible and at the right position
      final expectedMarkers =
          await homeRobot.getMarkersFromFile("assets/cottages.json");
      final actualMarkers = await homeRobot.markers();
      await homeRobot.compareMarkers(actualMarkers!, expectedMarkers,
          markerIcon: "assets/small_cottage_marker.png");

      //Simulate a tap on one of the marker and check that the marker icon size increased
      homeRobot.tapOnMarker("MySecondCottage");
      await homeRobot.checkMarkerIsSelected("MySecondCottage");

      //Check that the tile swiper is displayed
      await homeRobot.checkTileSwiperIsDisplayed();

      //Swiper TileSwiper and check that the Googlemap marker is selected
      await homeRobot.dragTileSwiperTo("MyThirdCottage");
      await homeRobot.checkMarkerIsSelected("MyThirdCottage");
    },
  );
}
