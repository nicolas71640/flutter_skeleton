import 'package:departments/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:departments/core/network/credentials_local_data_source.dart';
import 'package:departments/features/stuff/data/datasources/stuff_api_service.dart';
import 'package:departments/features/stuff/domain/entities/stuff.dart';
import 'package:departments/features/stuff/domain/repositories/stuff_repository.dart';

import '../models/stuff_model.dart';

class WrongIds extends ServerFailure {}

class EmailAlreadyUsed extends ServerFailure {}

class StuffRepositoryImpl implements StuffRepository {
  final StuffApiService stuffApiService;
  final CredentialsLocalDataSource credentialsLocalDataSource;

  StuffRepositoryImpl(this.stuffApiService, this.credentialsLocalDataSource);

  @override
  Future<Either<Failure, List<Stuff>>> getStuff() async {
    final stuffList = await stuffApiService.getStuff();
    print(stuffList.body);
    return Right(stuffList.body
        ?.map((responseStuff) => StuffModel.fromGetStuffResponse(responseStuff))
        .toList() as List<Stuff>);
  }
}
