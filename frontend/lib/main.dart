import 'package:departments/features/credentials/presentation/pages/login_page.dart';
import 'package:departments/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' show Level, Logger;

void main() async {
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  init();
  await sl.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(primaryColor: Colors.green.shade800),
      home: const LoginPage(),
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
