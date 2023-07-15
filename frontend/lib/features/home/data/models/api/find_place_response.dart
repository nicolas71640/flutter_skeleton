import 'package:json_annotation/json_annotation.dart';

import 'find_place_item_response.dart';

part 'find_place_response.g.dart';

@JsonSerializable(createToJson: false)
class FindPlaceResponse {
  final String status;
  final List<FindPlaceItemResponse> results;

  FindPlaceResponse(this.status, this.results);

  factory FindPlaceResponse.fromJson(Map<String, dynamic> json) =>
      _$FindPlaceResponseFromJson(json);

}
