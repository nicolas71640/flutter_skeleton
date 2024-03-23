import 'package:avecpaulette/features/home/data/models/api/suggestion_item_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'suggestion_response.g.dart';

@JsonSerializable(createToJson: false)
class SuggestionResponse {
  final String status;
  final List<SuggestionItemResponse> predictions;

  SuggestionResponse(this.status, this.predictions);

  factory SuggestionResponse.fromJson(Map<String, dynamic> json) =>
      _$SuggestionResponseFromJson(json);
}
