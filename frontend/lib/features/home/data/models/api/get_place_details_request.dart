import 'package:json_annotation/json_annotation.dart';

part 'get_place_details_request.g.dart';

@JsonSerializable(createFactory: false)
class GetPlaceDetailsRequest {
  final String placeId;
  final String lang;

  GetPlaceDetailsRequest(this.placeId, this.lang);

  Map<String, dynamic> toJson() => _$GetPlaceDetailsRequestToJson(this);
}
