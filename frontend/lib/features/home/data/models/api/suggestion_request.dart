import 'package:json_annotation/json_annotation.dart';

part 'suggestion_request.g.dart';

@JsonSerializable(createFactory: false)
class SuggestionRequest {
  final String country;
  final String input;
  final String lang;

  SuggestionRequest(this.country, this.input, this.lang);

  Map<String, dynamic> toJson() => _$SuggestionRequestToJson(this);
}
