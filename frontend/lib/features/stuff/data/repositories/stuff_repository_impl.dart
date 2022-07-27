import 'package:avecpaulette/core/error/failures.dart';
import 'package:avecpaulette/core/local_data_source/credentials_local_data_source.dart';
import 'package:avecpaulette/features/stuff/data/datasources/stuff_api_service.dart';
import 'package:avecpaulette/features/stuff/domain/entities/stuff.dart';
import 'package:avecpaulette/features/stuff/domain/repositories/stuff_repository.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../models/stuff_model.dart';

class WrongIds extends ServerFailure {}

class EmailAlreadyUsed extends ServerFailure {}

class StuffRepositoryImpl implements StuffRepository {
  final StuffApiService stuffApiService;
  final CredentialsLocalDataSource credentialsLocalDataSource;

  StuffRepositoryImpl(this.stuffApiService, this.credentialsLocalDataSource);

  @override
  Stream<List<Stuff>> getStuff() {
    return stuffApiService
        .getStuff()
        .flatMapIterable((value) => Stream.value(value))
        .map((responseStuff) => StuffModel.fromGetStuffResponse(responseStuff))
        .onErrorResume((error, stackTrace) {
          if (error is DioError) {
            return Stream.error(ServerFailure());
          }
          return Stream.error(error);
        })
        .toList()
        .asStream();
  }
}
