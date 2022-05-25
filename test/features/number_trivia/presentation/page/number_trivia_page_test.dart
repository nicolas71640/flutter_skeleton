import 'package:departments/features/departmentsViewer/domain/entities/number_trivia.dart';
import 'package:departments/features/departmentsViewer/presentation/bloc/number_trivia_bloc.dart';
import 'package:departments/features/departmentsViewer/presentation/pages/number_trivia_page.dart';
import 'package:departments/features/departmentsViewer/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/loading_widget_test.mocks.dart';

@GenerateMocks([NumberTriviaBloc])
void main() {
  late MockNumberTriviaBloc numberTriviaBloc;
  setUp(() {
    numberTriviaBloc = MockNumberTriviaBloc();
    GetIt.instance.registerSingleton<NumberTriviaBloc>(numberTriviaBloc);
    when(numberTriviaBloc.add(any)).thenAnswer((realInvocation) {});
    when(numberTriviaBloc.stream)
        .thenAnswer((realInvocation) => const Stream.empty());
  });

  testWidgets('should display a MessageDisplay widget when state is Empty',
      (WidgetTester tester) async {
    await _setState(tester, numberTriviaBloc, Empty());

    expect(find.byType(MessageDisplay), findsOneWidget);
    expect(find.text("Start Searching!"), findsOneWidget);
  });

  testWidgets('should display a LoadingWidget when state is Loading',
      (WidgetTester tester) async {
    await _setState(tester, numberTriviaBloc, Loading());
    expect(find.byType(LoadingWidget), findsOneWidget);
  });

  testWidgets('should display a TriviaDisplay when state is Loaded',
      (WidgetTester tester) async {
    const tNumberTrivia = NumberTrivia(
      text: "Text Trivia",
      number: 123,
    );
    await _setState(
        tester, numberTriviaBloc, const Loaded(numberTrivia: tNumberTrivia));

    expect(find.byType(TriviaDisplay), findsOneWidget);
    expect(find.text(tNumberTrivia.text), findsOneWidget);
    expect(find.text(tNumberTrivia.number.toString()), findsOneWidget);
  });

  testWidgets('should display a MessageDisplay with Error when state is Error',
      (WidgetTester tester) async {
    const error = Error(message: "An error occured");
    await _setState(tester, numberTriviaBloc, error);

    expect(find.byType(MessageDisplay), findsOneWidget);
    expect(find.text(error.message), findsOneWidget);
  });
}

Future _setState(
    WidgetTester tester, NumberTriviaBloc bloc, NumberTriviaState state) async {
  when(bloc.state).thenReturn(state);

  await tester.pumpWidget(
    const MaterialApp(home: NumberTriviaPage()),
  );
}
