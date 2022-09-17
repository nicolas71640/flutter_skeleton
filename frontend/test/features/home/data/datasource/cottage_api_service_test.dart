import 'package:avecpaulette/features/home/data/datasources/cottage_api_service.dart';
import 'package:avecpaulette/features/home/data/models/api/cottage_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'cottage_api_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late CottageApiService cottageApiService;

  setUp(() {
    mockDio = MockDio();
    cottageApiService = CottageApiService(mockDio);
  });

  group("getCottage", () {
    test("should return a CottageResponse list when no error is thrown ",
        () async {
      final jsonResponse = fixtureJson("cottage/cottage_ok.json");

      when(mockDio.get(any)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(path: ""),
          statusCode: 200,
          data: jsonResponse));

      final cottageResponses =
          await cottageApiService.getCottages(CottageRequest()).first;

      final cottagesJson = (jsonResponse as List);
      for (int i = 0; i < cottagesJson.length; i++) {
        expect(cottageResponses[i].title, cottagesJson[i]["title"]);
        expect(cottageResponses[i].description, cottagesJson[i]["description"]);
        expect(cottageResponses[i].imageUrl, cottagesJson[i]["imageUrl"]);
        expect(cottageResponses[i].price, cottagesJson[i]["price"]);
        expect(cottageResponses[i].latitude, cottagesJson[i]["latitude"]);
        expect(cottageResponses[i].longitude, cottagesJson[i]["longitude"]);
      }
    });

    test("shoud throw a DioError when an error is thrown", () async {
      final dioError = DioError(requestOptions: RequestOptions(path: ""));

      when(mockDio.get(any)).thenAnswer((_) async => throw dioError);

      expect(cottageApiService.getCottages(CottageRequest()),
          emitsError(dioError));
    });
  });
}
