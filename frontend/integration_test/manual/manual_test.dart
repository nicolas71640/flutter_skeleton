import 'package:avecpaulette/features/credentials/domain/entities/user.dart';
import 'package:avecpaulette/features/credentials/domain/usecases/login_usecase.dart';
import 'package:avecpaulette/injection_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../utils/test_utils.dart';
import 'manual_test.mocks.dart';

@GenerateMocks([LoginUseCase])
void main() {
  setUp(() async {
    init();
    await sl.allReady();
  });

  tearDown(() {
    sl.reset();
  });

  //After the test pass, check on crashlytics that you can see a crash : "FirebaseCrashlyticsTestCrash"
  testWidgets(
    "should crash when clicking on login button",
    (WidgetTester tester) async {
      MockLoginUseCase mockLoginUseCase = MockLoginUseCase();
      sl.unregister<LoginUseCase>();
      sl.registerLazySingleton<LoginUseCase>(() => mockLoginUseCase);
      when(mockLoginUseCase.call(any, any)).thenAnswer((realInvocation) {
        FirebaseCrashlytics.instance.crash();
        return Stream.value(const User(mail: ""));
      });
      await Firebase.initializeApp();

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      await TestUtils.startApp(tester);

      await tester.tap(find.text("Login"));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    "should send an email to reset password",
    (WidgetTester tester) async {
      await TestUtils.startApp(tester);

      await tester.tap(find.text("Sign up now"));

      //Sign up with a valid email address
      //Go back to the login page, and click on the forgotten password button
      //Enter the same email address
      //Check your emails, go back to the app and try to login with this password
      //It should succeed

      await Future.delayed(const Duration(minutes: 10));
    },
  );
}
