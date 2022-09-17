import 'package:json_annotation/json_annotation.dart';

part 'cottage_response.g.dart';

@JsonSerializable(createToJson: false)
class CottageResponse {
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final double latitude;
  final double longitude;

  CottageResponse(this.title, this.description, this.imageUrl, this.price,
      this.latitude, this.longitude);

  factory CottageResponse.fromJson(Map<String, dynamic> json) =>
      _$CottageResponseFromJson(json);
}
