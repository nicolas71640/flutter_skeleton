import 'package:avecpaulette/features/departmentsViewer/domain/entities/number_trivia.dart';
import 'package:avecpaulette/features/departmentsViewer/presentation/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/test_widget_utils.dart';

void main() {
  testWidgets('TriviaDisplay display trivia and number',
      (WidgetTester tester) async {
    const tNumberTrivia = NumberTrivia(text: "Number trivia", number: 134);
    await tester.pumpWidget(createWidgetUnderTest(
        const TriviaDisplay(numberTrivia: tNumberTrivia)));
    expect(find.text(tNumberTrivia.text), findsOneWidget);
    expect(find.text(tNumberTrivia.number.toString()), findsOneWidget);
  });
}
