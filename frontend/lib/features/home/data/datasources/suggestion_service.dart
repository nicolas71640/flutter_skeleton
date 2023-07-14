import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/suggestion_entity.dart';
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

  Stream<List<SuggestionEntity>> findPlace(String input, String lang) {
    final request =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$input&language=$lang&key=$androidKey';
    return Stream.fromFuture(dio.get(request)).map((response) {
      print("FIND A PLACE ");
      print(response);
      final result = json.decode(response.data);
      if (result['status'] == 'OK') {
        print(result);
        return result['results']
            .map<SuggestionEntity>((p) => SuggestionEntity(
                p['place_id'],
                p['formatted_address'],
                LatLng(p['geometry']['location']['lat'] as double,
                    p['geometry']['location']['lng'] as double)))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      print("ERROR"); //TODO to handle
      return [];
    });
  }

  Stream<SuggestionEntity> getPlaceDetails(String placeId, String lang) {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&language=$lang&key=$androidKey';
    return Stream.fromFuture(dio.get(request)).map((response) {
      final result = json.decode(response.data);
      print(result);
      if (result['status'] == 'OK') {
        print(result['result']['geometry']['location']);

        //TODO clean up !!
        var test = SuggestionEntity(
            placeId,
            result['result']['formatted_address'],
            LatLng(result['result']['geometry']["location"]["lat"] as double,
                result['result']['geometry']["location"]["lng"] as double));
        print(test);
        return test;
      }
      throw Error();
    });
  }
}
