import 'dart:async';

import 'package:avecpaulette/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension TesterHelper on WidgetTester {
  Future startApp({String keyToFind = "login_email"}) async {
    await pumpWidget(const MyApp());
    await pumpUntilFound(find.byKey(Key(keyToFind)));
    await pump();
  }

  Future<void> pumpUntilFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    bool timerDone = false;
    final timer = Timer(
        timeout, () => throw TimeoutException("Pump until has timed out"));
    while (timerDone != true) {
      await pump();

      final found = any(finder);
      if (found) {
        timerDone = true;
      }
    }
    timer.cancel();
  }

  Future<T?> pumpUntilMatch<T>(
      Future<T> Function() getValue, bool Function(T) predicate,
      {Duration timeout = const Duration(seconds: 100)}) async {
    final timer = Timer(timeout,
        () => throw TimeoutException("Pump until match has timed out"));
    while (true) {
      final T value = await getValue();
      if (predicate(value)) {
        timer.cancel();
        return value;
      }
      await pump();
    }
  }

  Future<void> pumpUntilNotFound(Finder finder) async {
    await pumpUntilMatch(() => Future.value(finder.evaluate()),
        (elements) => (elements as Iterable<Element>).isEmpty);
  }

  Future<void> wait(Duration timeout) async {
    bool timerDone = false;
    Timer(timeout, () => timerDone = true);
    while (timerDone != true) {
      await pump();
    }
  }
}
