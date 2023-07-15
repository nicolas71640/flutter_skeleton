import 'dart:io';
import 'package:avecpaulette/features/home/data/models/api/get_place_details_request.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/suggestion_entity.dart';
import '../models/api/find_place_request.dart';
import '../models/api/find_place_response.dart';
import '../models/api/get_place_details_response.dart';
import '../models/api/suggestion_request.dart';
import '../models/api/suggestion_response.dart';

class SuggestionService {
  final Dio dio;
  final String sessionToken;

  SuggestionService(this.dio, this.sessionToken);

  static const String androidKey = 'AIzaSyC_vDjUyeO6YbjqxRJKRK2w4syomcbJwfs';
  static const String iosKey = 'YOUR_API_KEY_HERE';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Stream<List<SuggestionEntity>> getSuggestions(SuggestionRequest request) {
    final requestUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${request.input}&language=${request.lang}&components=country:${request.country}&key=$androidKey&sessiontoken=$sessionToken';
    return Stream.fromFuture(dio.get(requestUrl)).map((response) {
      final suggestionResponse = SuggestionResponse.fromJson(response.data);

      if (suggestionResponse.status == 'OK') {
        return suggestionResponse.predictions
            .map((p) => SuggestionEntity(p.place_id, p.description, null))
            .toList();
      }

      if (suggestionResponse.status == 'ZERO_RESULTS') {
        return [];
      }

      return [];
    });
  }

  Stream<List<SuggestionEntity>> findPlace(FindPlaceRequest request) {
    final requestUrl =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=${request.input}&language=${request.lang}&key=$androidKey';
    return Stream.fromFuture(dio.get(requestUrl)).map((response) {
      final findPlaceResponse = FindPlaceResponse.fromJson(response.data);
      if (findPlaceResponse.status == 'OK') {
        return findPlaceResponse.results
            .map<SuggestionEntity>((p) => SuggestionEntity(
                p.place_id,
                p.formatted_address,
                LatLng(p.geometry.location.lat, p.geometry.location.lng)))
            .toList();
      }
      if (findPlaceResponse.status == 'ZERO_RESULTS') {
        return [];
      }

      return [];
    });
  }

  Stream<SuggestionEntity> getPlaceDetails(GetPlaceDetailsRequest request) {
    final requestUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=${request.placeId}&language=${request.lang}&key=$androidKey';
    return Stream.fromFuture(dio.get(requestUrl)).map((response) {
      final getPlaceDetailsResponse =
          GetPlaceDetailsResponse.fromJson(response.data);
      if (getPlaceDetailsResponse.status == 'OK') {
        var test = SuggestionEntity(
            request.placeId,
            getPlaceDetailsResponse.result.formatted_address,
            LatLng(getPlaceDetailsResponse.result.geometry.location.lat,
                getPlaceDetailsResponse.result.geometry.location.lng));
        print(test);
        return test;
      }
      throw Error();
    });
  }
}
