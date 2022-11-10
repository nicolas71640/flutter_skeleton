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
import 'package:integration_test/integration_test.dart';
import '../robots/app_robot.dart';
import '../robots/login_robot.dart';
import '../robots/signup_robot.dart';
import '../utils/api_utils.dart';
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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

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
      final credentialsRobot = LoginRobot(tester);
      User user = await ApiUtils().createUser(password: "myPassword").first;

      await AppRobot(tester).startApp();

      await credentialsRobot.email(user.mail);
      await credentialsRobot.password("myPassword");
      await credentialsRobot.login();

      expect(find.byType(GoogleMap), findsOneWidget);
    },
  );

  testWidgets(
    "should fail to login when clicking on login button when user doesn't exist",
    (WidgetTester tester) async {
      final credentialsRobot = LoginRobot(tester);

      await AppRobot(tester).startApp();

      await credentialsRobot.email("test@test.com");
      await credentialsRobot.password("");
      await credentialsRobot.login();

      expect(find.text("Wrong Ids"), findsOneWidget);
    },
  );

  testWidgets(
    "should fail to login when password is wrong",
    (WidgetTester tester) async {
      final credentialsRobot = LoginRobot(tester);
      User user = await ApiUtils().createUser(password: "myPassword").first;

      await AppRobot(tester).startApp();

      await credentialsRobot.email(user.mail);
      await credentialsRobot.password("wrongPassword");
      await credentialsRobot.login();

      expect(find.text("Wrong Ids"), findsOneWidget);
    },
  );

  testWidgets(
    "should go to next page when clicking signup",
    (WidgetTester tester) async {
      final loginRobot = LoginRobot(tester);
      final signupRobot = SignupRobot(tester);

      await AppRobot(tester).startApp();

      await loginRobot.goToSignup();
      await signupRobot.email("test@test.com");
      await signupRobot.password("password");
      await signupRobot.signup();

      expect(find.byType(GoogleMap), findsOneWidget);
    },
  );

  testWidgets(
    "should fail to sign up when email already exists",
    (WidgetTester tester) async {
      final loginRobot = LoginRobot(tester);
      final signupRobot = SignupRobot(tester);
      User user = await ApiUtils().createUser().first;

      await AppRobot(tester).startApp();

      await loginRobot.goToSignup();
      await signupRobot.email(user.mail);
      await signupRobot.password("whatever");
      await signupRobot.signup();

      expect(find.text(COULD_NOT_SIGNUP_MESSAGE), findsOneWidget);
    },
  );

  testWidgets(
    "should go to the next page when google signin success",
    (WidgetTester tester) async {
      final loginRobot = LoginRobot(tester);
      final mockCredentialsApiService = MockCredentialsApiService();
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

      await AppRobot(tester).startApp();
      await loginRobot.signInWithGoogle();

      expect(find.byType(GoogleMap), findsOneWidget);
    },
  );

  testWidgets(
    "should succeed to send an email to get another password",
    (WidgetTester tester) async {
      final loginRobot = LoginRobot(tester);
      final mockCredentialsApiService = MockCredentialsApiService();
      sl.unregister<CredentialsApiService>();
      sl.registerSingleton<CredentialsApiService>(mockCredentialsApiService);

      when(mockCredentialsApiService.forgetPassword(any))
          .thenAnswer((_) => Stream.value(ForgetPasswordResponse("ok")));

      await AppRobot(tester).startApp();
      await loginRobot.goToForgottenPassword();

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
      final loginRobot = LoginRobot(tester);
      await AppRobot(tester).startApp();

      await loginRobot.goToForgottenPassword();
      await loginRobot.fogottenPasswordEmail("whatever@test.com");
      await loginRobot.fogottenPasswordSend();

      expect(find.text(EMAIL_NOT_FOUND_MESSAGE), findsOneWidget);
    },
  );

  testWidgets(
    "should start in home page if user already logged",
    (WidgetTester tester) async {
      await ApiUtils().signupUser().first;

      await AppRobot(tester).startApp(keyToFind: "home_map");

      expect(find.byType(GoogleMap), findsOneWidget);
    },
  );
}
