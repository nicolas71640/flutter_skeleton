import 'dart:io';
import 'package:avecpaulette/features/home/data/models/api/find_place_item_response.dart';
import 'package:avecpaulette/features/home/data/models/api/get_place_details_request.dart';
import 'package:avecpaulette/features/home/data/models/api/suggestion_item_response.dart';
import 'package:dio/dio.dart';
import '../models/api/find_place_request.dart';
import '../models/api/find_place_response.dart';
import '../models/api/get_place_details_response.dart';
import '../models/api/suggestion_request.dart';
import '../models/api/suggestion_response.dart';

class CannotGetPlaceDetails implements Exception {}

class SuggestionService {
  final Dio dio;
  final String sessionToken;

  SuggestionService(this.dio, this.sessionToken);

  static const String androidKey = 'AIzaSyC_vDjUyeO6YbjqxRJKRK2w4syomcbJwfs';
  static const String iosKey = 'YOUR_API_KEY_HERE';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Stream<List<SuggestionItemResponse>> getSuggestions(
      SuggestionRequest request) {
    final requestUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${request.input}&language=${request.lang}&components=country:${request.country}&key=$androidKey&sessiontoken=$sessionToken';
    return Stream.fromFuture(dio.get(requestUrl)).map((response) {
      final suggestionResponse = SuggestionResponse.fromJson(response.data);

      if (suggestionResponse.status == 'OK') {
        return suggestionResponse.predictions;
      }

      if (suggestionResponse.status == 'ZERO_RESULTS') {
        return [];
      }

      return [];
    });
  }

  Stream<List<FindPlaceItemResponse>> findPlace(FindPlaceRequest request) {
    final requestUrl =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=${request.input}&language=${request.lang}&key=$androidKey';
    return Stream.fromFuture(dio.get(requestUrl)).map((response) {
      final findPlaceResponse = FindPlaceResponse.fromJson(response.data);
      if (findPlaceResponse.status == 'OK') {
        return findPlaceResponse.results;
      }
      if (findPlaceResponse.status == 'ZERO_RESULTS') {
        return [];
      }

      return [];
    });
  }

  Stream<GetPlaceDetailsResult> getPlaceDetails(
      GetPlaceDetailsRequest request) {
    final requestUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=${request.placeId}&language=${request.lang}&key=$androidKey';
    return Stream.fromFuture(dio.get(requestUrl)).map((response) {
      final getPlaceDetailsResponse =
          GetPlaceDetailsResponse.fromJson(response.data);
      final result = getPlaceDetailsResponse.result;
      if (getPlaceDetailsResponse.status == 'OK' && result != null) {
        return result;
      }

      throw CannotGetPlaceDetails();
    });
  }
}
