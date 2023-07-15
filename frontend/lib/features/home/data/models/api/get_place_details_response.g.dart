// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_place_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      json['formatted_address'] as String,
      json['place_id'] as String,
      Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    );

GetPlaceDetailsResponse _$GetPlaceDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    GetPlaceDetailsResponse(
      json['status'] as String,
      Result.fromJson(json['result'] as Map<String, dynamic>),
    );
