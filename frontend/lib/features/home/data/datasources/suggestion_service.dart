import 'dart:convert';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import '../../domain/entities/suggestion_entity.dart';

class SuggestionService {
  final client = Client();
  final String sessionToken;

  SuggestionService(this.sessionToken);

  static const String androidKey = 'AIzaSyC_vDjUyeO6YbjqxRJKRK2w4syomcbJwfs';
  static const String iosKey = 'YOUR_API_KEY_HERE';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Stream<List<SuggestionEntity>> getSuggestions(
      String country, String input, String lang, int offset) {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=$lang&components=country:$country&key=$androidKey&sessiontoken=$sessionToken';
    return Stream.fromFuture(client.get(Uri.parse(request))).map((response) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        print(result);
        return result['predictions']
            .map<SuggestionEntity>(
                (p) => SuggestionEntity(p['place_id'], p['description'], null))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      print("ERROR"); //TODO to handle
      return [];
    });
  }

  Stream<List<SuggestionEntity>> findPlace(String input, String lang) {
    final request =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$input&language=$lang&key=$androidKey';
    return Stream.fromFuture(client.get(Uri.parse(request))).map((response) {
      print("FIND A PLACE ");
      print(response);
      final result = json.decode(response.body);
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
    return Stream.fromFuture(client.get(Uri.parse(request))).map((response) {
      final result = json.decode(response.body);
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
