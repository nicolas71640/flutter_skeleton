import 'package:dartz/dartz.dart';
import 'package:departments/features/departmentsViewer/domain/entities/number_trivia.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUseCase implements UseCase<NumberTrivia, int>{
  final NumberTriviaRepository repository;

  GetConcreteNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(int number) async {
    return await repository.getConcreteNumberTrivia(number);
  }

}