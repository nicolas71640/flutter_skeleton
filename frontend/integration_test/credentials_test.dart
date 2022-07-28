import 'package:avecpaulette/injection_container.dart';
import 'package:avecpaulette/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'credentials_test.mocks.dart';
import 'utils/api_utils.dart';

@GenerateMocks([
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
])
void main() {
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;

  setUp(() async {
    init();
    sl.unregister<GoogleSignIn>();
    mockGoogleSignIn = MockGoogleSignIn();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    sl.registerLazySingleton<GoogleSignIn>(() => mockGoogleSignIn);
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

  testWidgets(
    "should go to the next page when google signin success",
    (WidgetTester tester) async {
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) => Future.value(mockGoogleSignInAccount));
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) => Future.value(mockGoogleSignInAuthentication));
      when(mockGoogleSignInAuthentication.idToken).thenAnswer((_) => "idToken");

      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byKey(const Key("login_email")), "bbb");
      await tester.enterText(
          find.byKey(const Key("login_password")), "password");
      await tester.tap(find.text("Sign in with Google"));
      await tester.pumpAndSettle();

      expect(find.text("Wrong Ids"), findsOneWidget);
    },
  );
}
