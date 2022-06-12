import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'refresh_token_response.g.dart';

abstract class RefreshTokenResponse implements Built<RefreshTokenResponse, RefreshTokenResponseBuilder> {
  String get accessToken;

  RefreshTokenResponse._();

  factory RefreshTokenResponse([Function(RefreshTokenResponseBuilder b) updates]) = _$RefreshTokenResponse;

  static Serializer<RefreshTokenResponse> get serializer => _$refreshTokenResponseSerializer;
}