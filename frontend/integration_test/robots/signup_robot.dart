import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'robot.dart';

class SignupRobot extends Robot {
  SignupRobot(super.tester);

  Future email(String email) async {
    await tester.enterText(find.byKey(const Key("signup_email")), email);
  }

  Future password(String password) async {
    await tester.enterText(find.byKey(const Key("signup_password")), password);
  }

  Future signup() async {
    await tester.tap(find.text("SignUp"));
    await tester.pumpAndSettle();
  }
}
