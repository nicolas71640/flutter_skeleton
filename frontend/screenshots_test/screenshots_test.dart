import 'dart:io';

import 'package:departments/features/departmentsViewer/data/models/number_trivia_model.dart';
import 'package:departments/injection_container.dart';
import 'package:departments/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';


void main() {
  setUp(() async {
    await sl.reset();
    init();
    await sl.allReady();
  });

  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding();

  testWidgets('screenshot', (WidgetTester tester) async {
    // Render the UI of the app
    await tester.pumpWidget(MyApp());

    String platformName = '';

    if (!kIsWeb) {
      // Not required for the web. This is required prior to taking the screenshot.
      await binding.convertFlutterSurfaceToImage();

      if (Platform.isAndroid) {
        platformName = "android";
      } else {
        platformName = "ios";
      }
    } else {
      platformName = "web";
    }

    // To make sure at least one frame has rendered
    await tester.pumpAndSettle();
    // Take the screenshot
    await binding.takeScreenshot('screenshot-$platformName');
  });
}
