import 'package:avecpaulette/features/credentials/domain/entities/user.dart';
import 'package:avecpaulette/features/credentials/domain/usecases/login_usecase.dart';
import 'package:avecpaulette/injection_container.dart';
import 'package:avecpaulette/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'manual_test.mocks.dart';

@GenerateMocks([LoginUseCase])
void main() {
  late MockLoginUseCase mockLoginUseCase;

  setUp(() async {
    init();
    mockLoginUseCase = MockLoginUseCase();
    sl.unregister<LoginUseCase>();
    sl.registerLazySingleton<LoginUseCase>(() => mockLoginUseCase);
    await sl.allReady();
  });

  tearDown(() {
    sl.reset();
  });

  //After the test pass, check on crashlytics that you can see a crash : "FirebaseCrashlyticsTestCrash"
  testWidgets(
    "should crash when clicking on login button",
    (WidgetTester tester) async {
      when(mockLoginUseCase.call(any, any)).thenAnswer((realInvocation) {
        FirebaseCrashlytics.instance.crash();
        return Stream.value(const User(mail: ""));
      });
      await Firebase.initializeApp();

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text("Login"));
      await tester.pumpAndSettle();
    },
  );
}
