import 'package:avecpaulette/core/error/exceptions.dart';
import 'package:avecpaulette/features/home/data/datasources/suggestion_service.dart';
import 'package:avecpaulette/features/home/data/models/api/suggestion_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'cottage_api_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late SuggestionService suggestionService;

  setUp(() {
    mockDio = MockDio();
    suggestionService = SuggestionService(mockDio, "ss");
  });

  group("getSuggestions", () {
    test("should return a list of suggestions when no erros is thrown",
        () async {
      final jsonResponse = fixtureJson("suggestions/get_suggestions_ok.json");

      when(mockDio.get(any)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(path: ""),
          statusCode: 200,
          data: jsonResponse));

      final getSuggestionsResponse = await suggestionService
          .getSuggestions(SuggestionRequest("fr", "Par", "fr"))
          .first;

      final expectedSuggestions = (jsonResponse["predictions"] as List);
      for (int i = 0; i < expectedSuggestions.length; i++) {
        expect(getSuggestionsResponse[i].description,
            expectedSuggestions[i]["description"]);
        expect(getSuggestionsResponse[i].placeId,
            expectedSuggestions[i]["place_id"]);
      }
    });
    
    test("should return an empty list is no results",
        () async {
      final jsonResponse = fixtureJson("suggestions/get_suggestions_zero_results.json");

      when(mockDio.get(any)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(path: ""),
          statusCode: 200,
          data: jsonResponse));

      final getSuggestionsResponse = await suggestionService
          .getSuggestions(SuggestionRequest("fr", "Parrrrr", "fr"))
          .first;

        expect(getSuggestionsResponse.isEmpty, true);
    });
  
  test("should return an empty list if unknown response from server",
        () async {
      final jsonResponse = fixtureJson("suggestions/get_suggestions_unknown.json");

      when(mockDio.get(any)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(path: ""),
          statusCode: 200,
          data: jsonResponse));

      final getSuggestionsResponse = await suggestionService
          .getSuggestions(SuggestionRequest("fr", "Parrrrr", "fr"))
          .first;

        expect(getSuggestionsResponse.isEmpty, true);
    });


    test("shoud throw a DioError when an error is thrown", () async {
      final dioError = DioError(requestOptions: RequestOptions(path: ""));

      when(mockDio.get(any)).thenAnswer((_) async => throw dioError);

      expect(
          suggestionService
              .getSuggestions(SuggestionRequest("fr", "Par", "fr")),
          emitsError(dioError));
    });
  });
}
