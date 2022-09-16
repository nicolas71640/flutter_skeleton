import 'dart:async';
import 'package:avecpaulette/features/home/data/models/api/cottage_request.dart';
import 'package:dio/dio.dart';

import '../models/api/cottage_response.dart';

class CottageApiService {
  final Dio dio;

  CottageApiService(this.dio);

  Stream<List<CottageResponse>> getCottages(CottageRequest cottageRequest) {
    return Stream.fromFuture(dio.get('/cottage/')).map((response) {
      return (response.data as List)
          .map<CottageResponse>((item) => CottageResponse.fromJson(item))
          .toList();
    });
  }
}
