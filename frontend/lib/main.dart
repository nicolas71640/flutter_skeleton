import 'package:avecpaulette/features/credentials/presentation/pages/login_page.dart';
import 'package:avecpaulette/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' show Level, Logger;
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  if (const bool.fromEnvironment('FIREBASE_ENABLED', defaultValue: true)) {
    runZonedGuarded<Future<void>>(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      // Pass all uncaught errors from the framework to Crashlytics.
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      _setupLogging();
      init();
      await sl.allReady();

      runApp(const MyApp());
    },
        (error, stack) => FirebaseCrashlytics.instance
            .recordError(error, stack, fatal: true));
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    _setupLogging();
    init();
    await sl.allReady();

    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (const bool.fromEnvironment('FIREBASE_ENABLED', defaultValue: true)) {
      return MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
        title: 'Number Trivia',
        theme: ThemeData(primaryColor: Colors.green.shade800),
        home: const LoginPage(),
      );
    } else {
      return MaterialApp(
        title: 'Number Trivia',
        theme: ThemeData(primaryColor: Colors.green.shade800),
        home: const LoginPage(),
      );
    }
  }
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    // ignore: avoid_print
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
