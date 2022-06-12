import 'package:dartz/dartz.dart';
import 'package:departments/features/stuff/domain/entities/stuff.dart';

import '../../../../core/error/failures.dart';
import '../repositories/stuff_repository.dart';

class GetStuffUseCase{
  final StuffRepository repository;

  GetStuffUseCase(this.repository);

  Future<Either<Failure, List<Stuff>>> call() async {
    return await repository.getStuff();
  }
}
