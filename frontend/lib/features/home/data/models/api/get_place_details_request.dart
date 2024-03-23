import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_place_details_request.g.dart';

@JsonSerializable(createFactory: false)
class GetPlaceDetailsRequest extends Equatable {
  final String placeId;
  final String lang;

  const GetPlaceDetailsRequest(this.placeId, this.lang);

  Map<String, dynamic> toJson() => _$GetPlaceDetailsRequestToJson(this);

  @override
  List<Object?> get props => [placeId, lang];
}
