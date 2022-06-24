import 'package:departments/injection_container.dart';
import 'package:departments/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/api_utils.dart';

void main() {
  setUp(() async {
    init();
    await sl.allReady();
    await ApiUtils().deleteUser("bbb").first;
  });

  tearDown(() {
    sl.reset();
  });

  testWidgets(
    "should fail to login when clicking on login button with wrong ids",
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byKey(const Key("login_email")), "bbb");
      await tester.enterText(
          find.byKey(const Key("login_password")), "password");
      await tester.tap(find.text("Login"));
      await tester.pumpAndSettle();

      expect(find.text("Wrong Ids"), findsOneWidget);
    },
  );

  testWidgets(
    "should go to next page when clicking signup",
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text("SignUp"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("signup_email")), "bbb");
      await tester.enterText(
          find.byKey(const Key("signup_password")), "password");
      await tester.tap(find.text("SignUp"));
      await tester.pumpAndSettle();

      expect(find.text("Stuff Title"), findsOneWidget);
    },
  );
}
