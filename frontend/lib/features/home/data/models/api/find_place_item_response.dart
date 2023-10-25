// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'find_place_item_response.g.dart';

@JsonSerializable(createToJson: false)
class Location {
  final double lat;
  final double lng;

  Location(this.lat, this.lng);

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@JsonSerializable(createToJson: false)
class Geometry {
  final Location location;

  Geometry(this.location);

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);
}

@JsonSerializable(createToJson: false)
class FindPlaceItemResponse {
  final String place_id;
  final String formatted_address;
  final Geometry geometry;

  FindPlaceItemResponse(this.place_id, this.formatted_address, this.geometry);

  factory FindPlaceItemResponse.fromJson(Map<String, dynamic> json) =>
      _$FindPlaceItemResponseFromJson(json);
}
