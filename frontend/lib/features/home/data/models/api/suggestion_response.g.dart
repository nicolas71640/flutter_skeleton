// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuggestionResponse _$SuggestionResponseFromJson(Map<String, dynamic> json) =>
    SuggestionResponse(
      json['status'] as String,
      (json['predictions'] as List<dynamic>)
          .map(
              (e) => SuggestionItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
