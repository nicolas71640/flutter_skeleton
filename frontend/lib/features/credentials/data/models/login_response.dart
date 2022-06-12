import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_response.g.dart';

abstract class LoginResponse implements Built<LoginResponse, LoginResponseBuilder> {
  String get userId;
  String get accessToken;
  String get refreshToken;

  LoginResponse._();

  factory LoginResponse([Function(LoginResponseBuilder b) updates]) = _$LoginResponse;

  static Serializer<LoginResponse> get serializer => _$loginResponseSerializer;
}