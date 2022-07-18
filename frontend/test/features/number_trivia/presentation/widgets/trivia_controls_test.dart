import 'package:avecpaulette/features/departmentsViewer/presentation/bloc/number_trivia_bloc.dart';
import 'package:avecpaulette/features/departmentsViewer/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/loading_widget_test.mocks.dart';
import '../../../../utils/test_widget_utils.dart';

@GenerateMocks([NumberTriviaBloc])
void main() {
  late MockNumberTriviaBloc numberTriviaBloc;
  setUp(() {
    numberTriviaBloc = MockNumberTriviaBloc();
  });

  testWidgets('TriviaControls should displayed the textField',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const TriviaControls()));
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text("Input a number"), findsOneWidget);
  });

  testWidgets('TriviaControls should displayed search and Get random buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const TriviaControls()));
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Get random trivia'), findsOneWidget);
  });

  testWidgets(
      'should add GetTriviaForRandomEvent when clicking on Get Random trivia',
      (WidgetTester tester) async {
    when(numberTriviaBloc.add(any)).thenAnswer((realInvocation) {});

    when(numberTriviaBloc.stream)
        .thenAnswer((realInvocation) => const Stream.empty());
    await tester.pumpWidget(createWidgetUnderTestWithBloc<NumberTriviaBloc>(
        const TriviaControls(), numberTriviaBloc));

    await tester.pumpAndSettle();

    await tester.tap(find.text('Get random trivia'));
    verify(numberTriviaBloc.add(GetTriviaForRandomNumberEvent()));
  });

  testWidgets(
      'should add GetTriviaForConcreteEvent when clicking on Get Random trivia',
      (WidgetTester tester) async {
    const tNumber = 4;

    when(numberTriviaBloc.add(any)).thenAnswer((realInvocation) {});
    when(numberTriviaBloc.state).thenReturn(
      Loading(), // the desired state
    );
    when(numberTriviaBloc.stream)
        .thenAnswer((realInvocation) => const Stream.empty());
    await tester.pumpWidget(createWidgetUnderTestWithBloc<NumberTriviaBloc>(
        const TriviaControls(), numberTriviaBloc));

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), tNumber.toString());
    await tester.tap(find.text('Search'));

    verify(numberTriviaBloc
        .add(GetTriviaForConcreteNumberEvent(tNumber.toString())));
  });

  testWidgets('should clear Text field when clicking on Search',
      (WidgetTester tester) async {
    const tNumber = 4;

    when(numberTriviaBloc.add(any)).thenAnswer((realInvocation) {});
    when(numberTriviaBloc.state).thenReturn(
      Loading(), // the desired state
    );
    when(numberTriviaBloc.stream)
        .thenAnswer((realInvocation) => const Stream.empty());
    await tester.pumpWidget(createWidgetUnderTestWithBloc<NumberTriviaBloc>(
        const TriviaControls(), numberTriviaBloc));

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), tNumber.toString());
    await tester.tap(find.text('Search'));

    expect(find.text(tNumber.toString()), findsNothing);
  });
}
