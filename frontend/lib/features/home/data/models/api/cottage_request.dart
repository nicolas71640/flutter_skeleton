import 'package:json_annotation/json_annotation.dart';

part 'cottage_request.g.dart';

@JsonSerializable(createFactory: false)
class CottageRequest {
  CottageRequest();

  Map<String, dynamic> toJson() => _$CottageRequestToJson(this);
}
