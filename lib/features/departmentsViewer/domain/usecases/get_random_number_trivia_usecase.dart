import 'package:dartz/dartz.dart';
import 'package:departments/features/departmentsViewer/domain/entities/number_trivia.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTriviaUseCase implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}

 