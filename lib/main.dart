import 'package:departments/features/departmentsViewer/presentation/pages/number_trivia_page.dart';
import 'package:departments/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
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
      home: const NumberTriviaPage(),
    );
  }
}
