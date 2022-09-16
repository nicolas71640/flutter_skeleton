import 'dart:async';

import 'package:avecpaulette/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class TestUtils {
  static Future startApp(WidgetTester tester,
      {String keyToFind = "login_email"}) async {
    await tester.pumpWidget(const MyApp());
    await pumpUntilFound(tester, find.byKey(Key(keyToFind)));
    await tester.pump();
  }

  static Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    bool timerDone = false;
    final timer = Timer(
        timeout, () => throw TimeoutException("Pump until has timed out"));
    while (timerDone != true) {
      await tester.pump();

      final found = tester.any(finder);
      if (found) {
        timerDone = true;
      }
    }
    timer.cancel();
  }
}