// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_place_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindPlaceResponse _$FindPlaceResponseFromJson(Map<String, dynamic> json) =>
    FindPlaceResponse(
      json['status'] as String,
      (json['results'] as List<dynamic>)
          .map((e) => FindPlaceItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
