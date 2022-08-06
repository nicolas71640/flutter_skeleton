import 'package:json_annotation/json_annotation.dart';

part 'itinerary_response.g.dart';

@JsonSerializable(createToJson: false)
class ItineraryResponse {
  ItineraryResponse();

  factory ItineraryResponse.fromJson(Map<String, dynamic> json) =>
      _$ItineraryResponseFromJson(json);
}
