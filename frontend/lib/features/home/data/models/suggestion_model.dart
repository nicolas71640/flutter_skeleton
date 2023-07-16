import 'package:avecpaulette/features/home/data/models/api/find_place_item_response.dart';
import 'package:avecpaulette/features/home/data/models/api/get_place_details_response.dart';
import 'package:avecpaulette/features/home/data/models/api/suggestion_item_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/suggestion_entity.dart';

class SuggestionModel extends SuggestionEntity {
  const SuggestionModel(super.placeId, super.description, super.latLng);

  factory SuggestionModel.fromSuggestionItemReponse(
      SuggestionItemResponse suggestionItemResponse) {
    return SuggestionModel(suggestionItemResponse.place_id,
        suggestionItemResponse.description, null);
  }

  factory SuggestionModel.fromFindPlaceItemReponse(
      FindPlaceItemResponse findPlaceItemResponse) {
    return SuggestionModel(
        findPlaceItemResponse.place_id,
        findPlaceItemResponse.formatted_address,
        LatLng(findPlaceItemResponse.geometry.location.lat,
            findPlaceItemResponse.geometry.location.lng));
  }

  factory SuggestionModel.fromGetPlaceDetailsResult(
      GetPlaceDetailsResult getPlaceDetailsResult) {
    return SuggestionModel(
        getPlaceDetailsResult.place_id,
        getPlaceDetailsResult.formatted_address,
        LatLng(getPlaceDetailsResult.geometry.location.lat,
            getPlaceDetailsResult.geometry.location.lng));
  }
}
