import 'package:avecpaulette/features/departmentsViewer/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/test_widget_utils.dart';

void main() {
  testWidgets('CircularProgessIndicator is displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const LoadingWidget()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
