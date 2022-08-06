import 'package:avecpaulette/features/credentials/presentation/bloc/authentication_bloc.dart';
import 'package:avecpaulette/features/credentials/presentation/pages/login_page.dart';
import 'package:avecpaulette/features/credentials/presentation/pages/splashscreen_page.dart';
import 'package:avecpaulette/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' show Level, Logger;
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/home/presentation/pages/home_page.dart';

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
    var navigatorObserver = <NavigatorObserver>[];
    if (const bool.fromEnvironment('FIREBASE_ENABLED', defaultValue: true)) {
      navigatorObserver = [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ];
    }
    return BlocProvider(
      create: (_) => sl<AuthenticationBloc>()..add(AppLoaded()),
      child: MaterialApp(
          navigatorObservers: navigatorObserver,
          title: 'Number Trivia',
          theme: ThemeData(primaryColor: Colors.green.shade800),
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return const HomePage();
              } else if (state is NotAuthenticated) {
                return const LoginPage();
              } else {
                return const SplashScreenPage();
              }
            },
          )),
    );
  }
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    // ignore: avoid_print
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
