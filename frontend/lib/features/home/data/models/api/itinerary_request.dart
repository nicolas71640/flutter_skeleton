import 'package:json_annotation/json_annotation.dart';

part 'itinerary_request.g.dart';

@JsonSerializable(createFactory: false)
class ItineraryRequest {
  final String from;
  final String to;

  ItineraryRequest(this.from, this.to);

  Map<String, dynamic> toJson() => _$ItineraryRequestToJson(this);
}
