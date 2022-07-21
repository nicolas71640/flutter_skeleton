import 'package:json_annotation/json_annotation.dart';

part 'oauth_response.g.dart';

@JsonSerializable(createToJson: false)
class OAuthResponse {
  final String email;
  final String accessToken;
  final String refreshToken;

  OAuthResponse(this.email, this.accessToken, this.refreshToken);

  factory OAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$OAuthResponseFromJson(json);
}
