// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cottage_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CottageResponse _$CottageResponseFromJson(Map<String, dynamic> json) =>
    CottageResponse(
      json['title'] as String,
      json['description'] as String,
      json['imageUrl'] as String,
      (json['price'] as num).toDouble(),
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    );
