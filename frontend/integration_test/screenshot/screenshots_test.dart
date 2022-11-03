import 'dart:io';

import 'package:avecpaulette/injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:integration_test/integration_test.dart';
import 'package:location/location.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test/features/home/data/datasource/location_service_test.mocks.dart';
import '../utils/api_utils.dart';
import '../utils/test_utils.dart';

@GenerateMocks([Location, LocationData])
main() {
  IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
  });

  tearDown(() {
    sl.reset();
  });

  /** Only one screenshots by test is possible see : https://github.com/flutter/flutter/issues/92381*/
  testWidgets('Login Screenshot', (WidgetTester tester) async {
    await TestUtils.startApp(tester);

    await takeScreenshot(tester, binding, "login");
  });

  testWidgets('Signup Screenshot', (WidgetTester tester) async {
    await TestUtils.startApp(tester);

    await tester.tap(find.text("Sign up now"));

    await TestUtils.pumpUntilFound(tester, find.text("SignUp"));

    await takeScreenshot(tester, binding, "signup");
  });

  // Seems to not working because of google map widget. Test timed out.
  // testWidgets('Home Screenshots', (WidgetTester tester) async {
  //   await ApiUtils().signupUser().first;

  //   // Render the UI of the app
  //   await TestUtils.startApp(tester, keyToFind: "home_map");

  //   expect(find.byType(GoogleMap), findsOneWidget);

  //   await takeScreenshot(tester, binding, "home");
  // });
}

takeScreenshot(dynamic tester, dynamic binding, String name) async {
  if (kIsWeb) {
    await binding.takeScreenshot(name);
    return;
  } else if (Platform.isAndroid) {
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
  }
  await binding.takeScreenshot(name);
}
