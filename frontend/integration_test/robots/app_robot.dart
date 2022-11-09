import 'package:avecpaulette/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/test_utils.dart';
import 'robot.dart';

class AppRobot extends Robot
{
  AppRobot(super.tester);

  Future startApp({String keyToFind = "login_email"}) async {
    await tester.pumpWidget(const MyApp());
    await TestUtils.pumpUntilFound(tester, find.byKey(Key(keyToFind)));
    await tester.pump();
  }
}