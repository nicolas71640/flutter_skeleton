import 'dart:io';

import 'package:avecpaulette/core/error/failures.dart';
import 'package:avecpaulette/features/home/data/datasources/cottage_api_service.dart';
import 'package:avecpaulette/features/home/data/models/api/cottage_response.dart';
import 'package:avecpaulette/features/home/data/models/cottage_model.dart';
import 'package:avecpaulette/features/home/data/repositories/cottage_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cottage_repository_impl_test.mocks.dart';

@GenerateMocks([
  CottageApiService,
])
void main() {
  late MockCottageApiService mockCottageApiService;
  late CottageRepositoryImpl cottageRepositoryImpl;

  setUp(() {
    mockCottageApiService = MockCottageApiService();
    cottageRepositoryImpl = CottageRepositoryImpl(mockCottageApiService);
  });

  group("getCottages", () {
    test("should return a list of Cottages when no error is thrown", () async {
      final List<CottageResponse> cottageResponses = {
        CottageResponse("", "", "", 1, 0, 0),
        CottageResponse("", "", "", 1, 0, 0)
      }.toList();
      when(mockCottageApiService.getCottages(any))
          .thenAnswer((_) => Stream.value(cottageResponses));

      final response = await cottageRepositoryImpl.getCottages().first;

      expect(
          response,
          cottageResponses.map((cottageResponse) =>
              CottageModel.fromCottageResponse(cottageResponse)));
    });

    test("should throw a ServerFailure if service throw a dioError", () async {
      final dioError = DioError(
          requestOptions: RequestOptions(path: ""),
          response: Response(
              statusCode: HttpStatus.unauthorized,
              requestOptions: RequestOptions(path: "")));

      when(mockCottageApiService.getCottages(any))
          .thenAnswer((_) => Stream.error(dioError));

      expect(cottageRepositoryImpl.getCottages(),
          emitsError(const TypeMatcher<ServerFailure>()));
    });

    test(
        "should throw the same error when another error than a dio error is thrown ",
        () async {
      final error = Error();

      when(mockCottageApiService.getCottages(any))
          .thenAnswer((_) => Stream.error(error));

      expect(cottageRepositoryImpl.getCottages(), emitsError(error));
    });
  });
}
