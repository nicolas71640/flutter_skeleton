import 'package:dartz/dartz.dart';
import 'package:departments/features/departmentsViewer/domain/entities/number_trivia.dart';
import 'package:departments/features/departmentsViewer/domain/repositories/number_trivia_repository.dart';
import 'package:departments/features/departmentsViewer/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_usecase_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late GetConcreteNumberTriviaUseCase usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTriviaUseCase(mockNumberTriviaRepository);
  });

  const int tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'trivia test');

  test('should get trivia for the number from the repository', () async {
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase.call(tNumber);

    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
