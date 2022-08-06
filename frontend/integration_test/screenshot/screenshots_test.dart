import 'dart:io';

import 'package:avecpaulette/injection_container.dart';
import 'package:avecpaulette/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils/api_utils.dart';
import '../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await sl.reset();
    init();
    await sl.allReady();
    await ApiUtils().deleteUser(email: "test@test.com").first;
  });

  /** Only one screenshots by test is possible see : https://github.com/flutter/flutter/issues/92381*/
  testWidgets('Login Screenshot', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await TestUtils.pumpUntilFound(
        tester, find.byKey(const Key("login_email")));

    await takeScreenshot(tester, binding, "login");
  });

  testWidgets('Signup Screenshot', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await TestUtils.pumpUntilFound(
        tester, find.byKey(const Key("login_email")));

    await tester.tap(find.text("Sign up now"));

    await TestUtils.pumpUntilFound(tester, find.text("SignUp"));

    await takeScreenshot(tester, binding, "signup");
  });

  // Seems to not working because of google map widget. Test timed out.
  // testWidgets('Home Screenshots', (WidgetTester tester) async {
  //   late User user;

  //   user = await ApiUtils().createUser(password: "myPassword").first;

  //   // Render the UI of the app
  //   await tester.pumpWidget(const MyApp());

  //   await TestUtils.pumpUntilFound(tester, find.byKey(const Key("login_email")));

  //   await tester.enterText(find.byKey(const Key("login_email")), user.mail);
  //   await tester.enterText(
  //       find.byKey(const Key("login_password")), "myPassword");
  //   await tester.tap(find.text("Login"));

  //   await TestUtils.pumpUntilFound(tester, find.byKey(const Key('home_map')));

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
