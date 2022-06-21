import 'package:json_annotation/json_annotation.dart';

part 'get_stuff_response.g.dart';

@JsonSerializable(createToJson: false)
class GetStuffResponse {
  final String title;
  final String description;
  final String imageUrl;
  final String userId;

  final int price;

  GetStuffResponse(
      this.userId, this.title, this.description, this.imageUrl, this.price);

  factory GetStuffResponse.fromJson(Map<String, dynamic> json) =>
      _$GetStuffResponseFromJson(json);
}
