import 'dart:io';

import 'package:avecpaulette/core/error/failures.dart';
import 'package:avecpaulette/features/home/data/datasources/suggestion_service.dart';
import 'package:avecpaulette/features/home/data/models/api/find_place_item_response.dart';
import 'package:avecpaulette/features/home/data/models/api/get_place_details_response.dart';
import 'package:avecpaulette/features/home/data/models/api/suggestion_item_response.dart';
import 'package:avecpaulette/features/home/data/models/suggestion_model.dart';
import 'package:avecpaulette/features/home/data/repositories/suggestion_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'suggestion_repository_impl_test.mocks.dart';

@GenerateMocks([
  SuggestionService,
])
void main() {
  late MockSuggestionService mockSuggestionService;
  late SuggestionRepositoryImpl suggestionRepositoryImpl;

  setUp(() {
    mockSuggestionService = MockSuggestionService();
    suggestionRepositoryImpl = SuggestionRepositoryImpl(mockSuggestionService);
  });

  group("getSuggestions", () {
    test("should return a list of suggestions when no error is thrown",
        () async {
      final List<SuggestionItemResponse> response = {
        SuggestionItemResponse("Description 1", "first_place_id"),
        SuggestionItemResponse("Description 2", "second_place_id")
      }.toList();

      final expectedSuggestions = response.map((suggestionItemResponse) =>
          SuggestionModel(suggestionItemResponse.place_id,
              suggestionItemResponse.description, null));

      when(mockSuggestionService.getSuggestions(any))
          .thenAnswer((_) => Stream.value(response));

      const input = "Par";
      const lang = "fr";
      const country = "FR";
      final actualSuggestions = await suggestionRepositoryImpl
          .getSuggestions(country, input, lang)
          .first;

      final verification =
          verify(mockSuggestionService.getSuggestions(captureAny));
      expect(verification.captured[0].country, country);
      expect(verification.captured[0].input, input);
      expect(verification.captured[0].lang, lang);

      expect(actualSuggestions, expectedSuggestions);
    });

    test("should throw a ServerFailure if service throw a dioError", () async {
      final dioError = DioError(
          requestOptions: RequestOptions(path: ""),
          response: Response(
              statusCode: HttpStatus.unauthorized,
              requestOptions: RequestOptions(path: "")));

      when(mockSuggestionService.getSuggestions(any))
          .thenAnswer((_) => Stream.error(dioError));

      expect(suggestionRepositoryImpl.getSuggestions("fr", "Par", "fr"),
          emitsError(const TypeMatcher<ServerFailure>()));
    });
    test(
        "should throw the same error when another error than a dio error is thrown ",
        () async {
      final error = Error();

      when(mockSuggestionService.getSuggestions(any))
          .thenAnswer((_) => Stream.error(error));

      expect(suggestionRepositoryImpl.getSuggestions("", "", ""),
          emitsError(error));
    });
  });
  group("findPlace", () {
    test("should return a list of suggestions when no error is thrown",
        () async {
      final List<FindPlaceItemResponse> response = {
        FindPlaceItemResponse(
            "Description 1", "first_place_id", Geometry(Location(1, 3))),
        FindPlaceItemResponse(
            "Description 2", "second_place_id", Geometry(Location(5, 6)))
      }.toList();

      final expectedSuggestions = response.map((findPlaceItemResponse) =>
          SuggestionModel(
              findPlaceItemResponse.place_id,
              findPlaceItemResponse.formatted_address,
              LatLng(findPlaceItemResponse.geometry.location.lat,
                  findPlaceItemResponse.geometry.location.lng)));

      const input = "Par";
      const lang = "FR";
      when(mockSuggestionService.findPlace(any))
          .thenAnswer((_) => Stream.value(response));

      final actualSuggestions =
          await suggestionRepositoryImpl.findPlace(input, lang).first;

      final verification = verify(mockSuggestionService.findPlace(captureAny));
      expect(verification.captured[0].input, input);
      expect(verification.captured[0].lang, lang);

      expect(actualSuggestions, expectedSuggestions);
    });

    test("should throw a ServerFailure if service throw a dioError", () async {
      final dioError = DioError(
          requestOptions: RequestOptions(path: ""),
          response: Response(
              statusCode: HttpStatus.unauthorized,
              requestOptions: RequestOptions(path: "")));

      when(mockSuggestionService.findPlace(any))
          .thenAnswer((_) => Stream.error(dioError));

      expect(suggestionRepositoryImpl.findPlace("Par", "fr"),
          emitsError(const TypeMatcher<ServerFailure>()));
    });

    test(
        "should throw the same error when another error than a dio error is thrown ",
        () async {
      final error = Error();

      when(mockSuggestionService.findPlace(any))
          .thenAnswer((_) => Stream.error(error));

      expect(suggestionRepositoryImpl.findPlace("", ""),
          emitsError(error));
    });

  });
  group("getPlaceDetails", () {
    test("should return a SuggestionEntity when no error is thrown", () async {
      final result = GetPlaceDetailsResult(
          "Description 1", "first_place_id", Geometry(Location(1, 3)));

      final expectedSuggestion = SuggestionModel(
          result.place_id,
          result.formatted_address,
          LatLng(result.geometry.location.lat, result.geometry.location.lng));

      const placeId = "the place id";
      const lang = "FR";
      when(mockSuggestionService.getPlaceDetails(any))
          .thenAnswer((_) => Stream.value(result));

      final actualSuggestion =
          await suggestionRepositoryImpl.getPlaceDetails(placeId, lang).first;

      final verification =
          verify(mockSuggestionService.getPlaceDetails(captureAny));
      expect(verification.captured[0].placeId, placeId);
      expect(verification.captured[0].lang, lang);

      expect(actualSuggestion, expectedSuggestion);
    });

    test("should throw a ServerFailure if service throw a dioError", () async {
      final dioError = DioError(
          requestOptions: RequestOptions(path: ""),
          response: Response(
              statusCode: HttpStatus.unauthorized,
              requestOptions: RequestOptions(path: "")));

      when(mockSuggestionService.getPlaceDetails(any))
          .thenAnswer((_) => Stream.error(dioError));

      expect(suggestionRepositoryImpl.getPlaceDetails("Par", "fr"),
          emitsError(const TypeMatcher<ServerFailure>()));
    });
    
    test(
        "should throw the same error when another error than a dio error is thrown ",
        () async {
      final error = Error();

      when(mockSuggestionService.getPlaceDetails(any))
          .thenAnswer((_) => Stream.error(error));

      expect(suggestionRepositoryImpl.getPlaceDetails("", ""), emitsError(error));
    });

  });
}
