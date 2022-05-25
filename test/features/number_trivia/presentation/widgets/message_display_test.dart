import 'package:departments/features/departmentsViewer/presentation/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/test_widget_utils.dart';

void main() {
  testWidgets('Text with message is displayed', (WidgetTester tester) async {
    const message = "My Message to Display";
    await tester.pumpWidget(createWidgetUnderTest(const MessageDisplay(
      message: message,
    )));
    expect(find.text(message), findsOneWidget);
  });
}
