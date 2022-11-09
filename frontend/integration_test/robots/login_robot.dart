import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

import 'robot.dart';

class LoginRobot extends Robot {
  LoginRobot(super.tester);

  Future email(String email) async {
    await tester.enterText(find.byKey(const Key("login_email")), email);
  }

  Future password(String password) async {
    await tester.enterText(find.byKey(const Key("login_password")), password);
  }

  Future login() async {
    await tester.tap(find.text("Login"));
    await tester.pumpAndSettle();
  }

  Future goToSignup() async {
    await tester.tap(find.text("Sign up now"));
    await tester.pumpAndSettle();
  }

  Future signInWithGoogle() async {
    await tester.tap(find.text("Sign in with Google"));
    await tester.pumpAndSettle();
  }

  Future goToForgottenPassword() async {
    await tester.tap(find.text("Have you forgotten your password ?"));
    await tester.pumpAndSettle();
  }

  Future fogottenPasswordEmail(String email) async {
    await tester.enterText(
        find.byKey(const Key("mailForgottenPassword")), email);
  }

  Future fogottenPasswordSend() async {
      await tester.tap(find.text("Send me an email"));
      await tester.pumpAndSettle();
  }
}
