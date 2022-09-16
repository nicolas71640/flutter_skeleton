import 'package:avecpaulette/core/error/failures.dart';
import 'package:avecpaulette/features/home/data/datasources/cottage_api_service.dart';
import 'package:avecpaulette/features/home/data/models/cottage_model.dart';
import 'package:avecpaulette/features/home/domain/entities/cottage.dart';
import 'package:avecpaulette/features/home/domain/repositories/cottage_repository.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../models/api/cottage_request.dart';

class WrongIds extends ServerFailure {}

class CottageRepositoryImpl implements CottageRepository {
  final CottageApiService cottageApiService;

  CottageRepositoryImpl(this.cottageApiService);

  @override
  Stream<List<Cottage>> getCottages() {
    return cottageApiService
        .getCottages(CottageRequest())
        .flatMapIterable((value) => Stream.value(value))
        .map((cottageResponse) =>
            CottageModel.fromCottageResponse(cottageResponse))
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
