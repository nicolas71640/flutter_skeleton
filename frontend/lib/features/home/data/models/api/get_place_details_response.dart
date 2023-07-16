// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'find_place_item_response.dart';

part 'get_place_details_response.g.dart';

@JsonSerializable(createToJson: false)
class GetPlaceDetailsResult {
  final String formatted_address;
  final String place_id;
  final Geometry geometry;

  factory GetPlaceDetailsResult.fromJson(Map<String, dynamic> json) =>
      _$GetPlaceDetailsResultFromJson(json);

  GetPlaceDetailsResult(this.formatted_address, this.place_id, this.geometry);
}

@JsonSerializable(createToJson: false)
class GetPlaceDetailsResponse {
  final String status;
  final GetPlaceDetailsResult? result;

  factory GetPlaceDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPlaceDetailsResponseFromJson(json);

  GetPlaceDetailsResponse(this.status, this.result);
}
