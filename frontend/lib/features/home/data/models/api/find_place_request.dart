import 'package:json_annotation/json_annotation.dart';

part 'find_place_request.g.dart';

@JsonSerializable(createFactory: false)
class FindPlaceRequest {
  final String input;
  final String lang;

  FindPlaceRequest(this.input, this.lang);

  Map<String, dynamic> toJson() => _$FindPlaceRequestToJson(this);
}
