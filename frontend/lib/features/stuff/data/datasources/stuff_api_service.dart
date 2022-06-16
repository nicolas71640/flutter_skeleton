// Source code generation in Dart works by creating a new file which contains a "companion class".
// In order for the source gen to know which file to generate and which files are "linked", you need to use the part keyword.
import 'dart:async';

import 'package:dio/dio.dart';

import '../models/api/get_stuff_response.dart';

class StuffApiService {
  final Dio dio;

  StuffApiService(this.dio);

  Stream<List<GetStuffResponse>> getStuff() {
    return Stream.fromFuture(dio.get('/stuff/')).map((response) => response.data
        .map<GetStuffResponse>((item) => GetStuffResponse.fromJson(item))
        .toList());
  }
}
