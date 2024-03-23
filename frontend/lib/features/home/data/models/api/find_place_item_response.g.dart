// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_place_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      (json['lat'] as num).toDouble(),
      (json['lng'] as num).toDouble(),
    );

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      Location.fromJson(json['location'] as Map<String, dynamic>),
    );

FindPlaceItemResponse _$FindPlaceItemResponseFromJson(
        Map<String, dynamic> json) =>
    FindPlaceItemResponse(
      json['place_id'] as String,
      json['formatted_address'] as String,
      Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    );
