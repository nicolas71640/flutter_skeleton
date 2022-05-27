import 'package:departments/features/departmentsViewer/data/datasources/number_trivia_remote_data_source.dart';
import 'package:departments/features/departmentsViewer/data/models/number_trivia_model.dart';
import 'package:departments/injection_container.dart';
import 'package:departments/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test/features/number_trivia/data/repositories/number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([NumberTriviaRemoteDataSource])
void main() {
  late MockNumberTriviaRemoteDataSource numberTriviaRemoteDataSource;

  setUp(() async {
    sl.reset();
    numberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    init();
    sl.pushNewScope();
    sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
        () => numberTriviaRemoteDataSource);

    await sl.allReady();
  });

  testWidgets(
    "should get random trivia when clicking on Get Random Trivia button",
    (WidgetTester tester) async {
      const tNumberTriviaModel =
          NumberTriviaModel(text: "Number trivia", number: 1234);

      when(numberTriviaRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async {
        return tNumberTriviaModel;
      });

      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Get random trivia'));
      await tester.pumpAndSettle();

      verify(numberTriviaRemoteDataSource.getRandomNumberTrivia());
      expect(find.text(tNumberTriviaModel.text), findsOneWidget);
      expect(find.text(tNumberTriviaModel.number.toString()), findsOneWidget);
    },
  );

  testWidgets(
    "should get concrete trivia when clicking on Search button",
    (WidgetTester tester) async {
      const tNumberTriviaModel =
          NumberTriviaModel(text: "Number trivia", number: 1234);

      when(numberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async {
        return tNumberTriviaModel;
      });

      await tester.pumpWidget(const MyApp());
      await tester.enterText(
          find.byType(TextField), tNumberTriviaModel.number.toString());
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      verify(numberTriviaRemoteDataSource
          .getConcreteNumberTrivia(tNumberTriviaModel.number));
      expect(find.text(tNumberTriviaModel.text), findsOneWidget);
      expect(find.text(tNumberTriviaModel.number.toString()), findsOneWidget);
    },
  );
}
