import 'package:avecpaulette/features/home/data/datasources/suggestion_service.dart';
import 'package:avecpaulette/features/home/data/models/api/find_place_request.dart';
import 'package:avecpaulette/features/home/data/models/api/get_place_details_request.dart';
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
        expect(getSuggestionsResponse[i].place_id,
            expectedSuggestions[i]["place_id"]);
      }
    });

    test("should return an empty list is no results", () async {
      final jsonResponse =
          fixtureJson("suggestions/get_suggestions_zero_results.json");

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
      final jsonResponse =
          fixtureJson("suggestions/get_suggestions_unknown.json");

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

  group("findPlace", () {
    test("should return a list of place when no error is thrown", () async {
      final jsonResponse = fixtureJson("suggestions/find_place_ok.json");

      when(mockDio.get(any)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(path: ""),
          statusCode: 200,
          data: jsonResponse));

      final findPlaceResponse = await suggestionService
          .findPlace(FindPlaceRequest("Par", "fr"))
          .first;

      final expectedSuggestions = (jsonResponse["results"] as List);
      for (int i = 0; i < expectedSuggestions.length; i++) {
        expect(findPlaceResponse[i].formatted_address,
            expectedSuggestions[i]["formatted_address"]);
        expect(
            findPlaceResponse[i].place_id, expectedSuggestions[i]["place_id"]);
      }
    });

    test("should return an empty list if unknown status received", () async {
      final jsonResponse = fixtureJson("suggestions/find_place_unknown.json");

      when(mockDio.get(any)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(path: ""),
          statusCode: 200,
          data: jsonResponse));

      final findPlaceResponse = await suggestionService
          .findPlace(FindPlaceRequest("Par", "fr"))
          .first;

      expect(findPlaceResponse.isEmpty, true);
    });

    test("should return an empty list if zero results", () async {
      final jsonResponse =
          fixtureJson("suggestions/find_place_zero_results.json");

      when(mockDio.get(any)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(path: ""),
          statusCode: 200,
          data: jsonResponse));

      final findPlaceResponse = await suggestionService
          .findPlace(FindPlaceRequest("zzzzzzzzzzzzz", "fr"))
          .first;

      expect(findPlaceResponse.isEmpty, true);
    });

    test("shoud throw a DioError when an error is thrown", () async {
      final dioError = DioError(requestOptions: RequestOptions(path: ""));

      when(mockDio.get(any)).thenAnswer((_) async => throw dioError);

      expect(suggestionService.findPlace(FindPlaceRequest("fr", "Par")),
          emitsError(dioError));
    });
  });

  group("getPlaceDetails", () {
    test("should return place details when no error is thrown", () async {
      final jsonResponse = fixtureJson("suggestions/get_place_details_ok.json");

      when(mockDio.get(any)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(path: ""),
          statusCode: 200,
          data: jsonResponse));

      final result = await suggestionService
          .getPlaceDetails(
              const GetPlaceDetailsRequest("ChIJD7fiBh9u5kcRYJSMaMOCCwQ", "fr"))
          .first;

      expect(result.place_id, jsonResponse["result"]["place_id"]);
      expect(result.formatted_address,
          jsonResponse["result"]["formatted_address"]);
      expect(result.geometry.location.lat,
          jsonResponse["result"]["geometry"]["location"]["lat"]);
      expect(result.geometry.location.lng,
          jsonResponse["result"]["geometry"]["location"]["lng"]);
    });
    test("should throw an exception if cannot find the place", () async {
      suggestionService = SuggestionService(Dio(), "ss");
      final jsonResponse =
          fixtureJson("suggestions/get_place_details_no_result.json");

      when(mockDio.get(any)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(path: ""),
          statusCode: 200,
          data: jsonResponse));

      expect(
          suggestionService.getPlaceDetails(
              const GetPlaceDetailsRequest("WRONG PLACE ID", "fr")),
          emitsError(const TypeMatcher<CannotGetPlaceDetails>()));
    });
  });
}
