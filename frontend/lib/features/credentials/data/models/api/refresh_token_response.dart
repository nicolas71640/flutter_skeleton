import 'package:json_annotation/json_annotation.dart';
part 'refresh_token_response.g.dart';

@JsonSerializable(createToJson: false)
class RefreshTokenResponse {
  final String accessToken;

  RefreshTokenResponse(this.accessToken);

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}
