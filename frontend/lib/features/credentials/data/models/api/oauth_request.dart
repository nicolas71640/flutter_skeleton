import 'package:json_annotation/json_annotation.dart';

part 'oauth_request.g.dart';

@JsonSerializable(createFactory: false)
class OAuthRequest {
  final String idToken;

  OAuthRequest(this.idToken);

  Map<String, dynamic> toJson() => _$OAuthRequestToJson(this);
}
