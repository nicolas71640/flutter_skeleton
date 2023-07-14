// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'suggestion_item_response.g.dart';

@JsonSerializable(createToJson: false)
class SuggestionItemResponse {
  final String description;
  final String place_id;

  SuggestionItemResponse(this.description, this.place_id);

  factory SuggestionItemResponse.fromJson(Map<String, dynamic> json) =>
      _$SuggestionItemResponseFromJson(json);

}
