import 'package:avecpaulette/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:avecpaulette/features/credentials/data/models/api/oauth_response.dart';
import 'package:avecpaulette/features/credentials/domain/entities/user.dart';
import 'package:avecpaulette/features/credentials/presentation/bloc/forgotten_password_bloc.dart';
import 'package:avecpaulette/features/credentials/presentation/bloc/signup_bloc.dart';
import 'package:avecpaulette/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avecpaulette/features/credentials/data/models/api/forget_password_response.dart';

import '../utils/api_utils.dart';
import '../utils/test_utils.dart';
import 'credentials_test.mocks.dart';
import 'package:location/location.dart';

@GenerateMocks([
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  CredentialsApiService,
  Location,
  LocationData
])
void main() {
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
  late MockLocation mockLocation;

  setUp(() async {
    init();
    sl.unregister<GoogleSignIn>();
    mockGoogleSignIn = MockGoogleSignIn();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    sl.registerLazySingleton<GoogleSignIn>(() => mockGoogleSignIn);

    sl.unregister<Location>();
    mockLocation = MockLocation();
    final locationData = MockLocationData();
    when(locationData.latitude).thenReturn(0.0);
    when(locationData.longitude).thenReturn(0.0);
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

  testWidgets(
    "should success to login when clicking on login button",
    (WidgetTester tester) async {
      User user = await ApiUtils().createUser(password: "myPassword").first;

      await TestUtils.startApp(tester);

      await tester.enterText(find.byKey(const Key("login_email")), user.mail);
      await tester.enterText(
          find.byKey(const Key("login_password")), "myPassword");
      await tester.tap(find.text("Login"));
      await tester.pumpAndSettle();

      expect(find.byType(GoogleMap), findsOneWidget);
    },
  );

  testWidgets(
    "should fail to login when clicking on login button when user doesn't exist",
    (WidgetTester tester) async {
      await TestUtils.startApp(tester);
      await tester.enterText(
          find.byKey(const Key("login_email")), "test@test.com");
      await tester.enterText(
          find.byKey(const Key("login_password")), "password");
      await tester.tap(find.text("Login"));
      await tester.pumpAndSettle();

      expect(find.text("Wrong Ids"), findsOneWidget);
    },
  );

  testWidgets(
    "should fail to login when password is wrong",
    (WidgetTester tester) async {
      User user = await ApiUtils().createUser(password: "myPassword").first;

      await TestUtils.startApp(tester);
      await tester.enterText(find.byKey(const Key("login_email")), user.mail);
      await tester.enterText(
          find.byKey(const Key("login_password")), "wrongPassword");
      await tester.tap(find.text("Login"));
      await tester.pumpAndSettle();

      expect(find.text("Wrong Ids"), findsOneWidget);
    },
  );

  testWidgets(
    "should go to next page when clicking signup",
    (WidgetTester tester) async {
      await TestUtils.startApp(tester);
      await tester.tap(find.text("Sign up now"));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key("signup_email")), "test@test.com");
      await tester.enterText(
          find.byKey(const Key("signup_password")), "password");
      await tester.tap(find.text("SignUp"));
      await tester.pumpAndSettle();

      expect(find.byType(GoogleMap), findsOneWidget);
    },
  );

  testWidgets(
    "should fail to sign up when email already exists",
    (WidgetTester tester) async {
      User user = await ApiUtils().createUser().first;

      await TestUtils.startApp(tester);
      await tester.tap(find.text("Sign up now"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key("signup_email")), user.mail);
      await tester.enterText(
          find.byKey(const Key("signup_password")), "whatever");
      await tester.tap(find.text("SignUp"));
      await tester.pumpAndSettle();

      expect(find.text(COULD_NOT_SIGNUP_MESSAGE), findsOneWidget);
    },
  );

  testWidgets(
    "should go to the next page when google signin success",
    (WidgetTester tester) async {
      MockCredentialsApiService mockCredentialsApiService =
          MockCredentialsApiService();
      sl.unregister<CredentialsApiService>();
      sl.registerSingleton<CredentialsApiService>(mockCredentialsApiService);
      when(mockCredentialsApiService.oauth(any))
          .thenAnswer((_) => Stream.value(OAuthResponse(
                "email",
                "accessToken",
                "refreshToken",
              )));
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) => Future.value(mockGoogleSignInAccount));
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) => Future.value(mockGoogleSignInAuthentication));
      when(mockGoogleSignInAuthentication.idToken).thenAnswer((_) => "idToken");

      await TestUtils.startApp(tester);
      await tester.tap(find.text("Sign in with Google"));
      await tester.pumpAndSettle();

      expect(find.byType(GoogleMap), findsOneWidget);
    },
  );

  testWidgets(
    "should succeed to send an email to get another password",
    (WidgetTester tester) async {
      MockCredentialsApiService mockCredentialsApiService =
          MockCredentialsApiService();
      sl.unregister<CredentialsApiService>();
      sl.registerSingleton<CredentialsApiService>(mockCredentialsApiService);

      when(mockCredentialsApiService.forgetPassword(any))
          .thenAnswer((_) => Stream.value(ForgetPasswordResponse("ok")));

      await TestUtils.startApp(tester);
      await tester.tap(find.text("Have you forgotten your password ?"));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key("mailForgottenPassword")), "ail@mail.com");
      await tester.tap(find.text("Send me an email"));
      await tester.pumpAndSettle();

      expect(find.text("A new password has been send to your email address"),
          findsOneWidget);
    },
  );

  testWidgets(
    "should fail to send an email to get another passord if the user doesn't exist",
    (WidgetTester tester) async {
      await TestUtils.startApp(tester);
      await tester.tap(find.text("Have you forgotten your password ?"));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key("mailForgottenPassword")), "whatever@test.com");
      await tester.tap(find.text("Send me an email"));
      await tester.pumpAndSettle();

      expect(find.text(EMAIL_NOT_FOUND_MESSAGE), findsOneWidget);
    },
  );

  testWidgets(
    "should start in home page if user already logged",
    (WidgetTester tester) async {
      await ApiUtils().signupUser().first;

      await TestUtils.startApp(tester, keyToFind: "home_map");

      expect(find.byType(GoogleMap), findsOneWidget);
    },
  );
}
