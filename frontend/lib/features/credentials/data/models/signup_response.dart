import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'signup_response.g.dart';

abstract class SignupResponse implements Built<SignupResponse, SignupResponseBuilder> {
  String get message;

  SignupResponse._();

  factory SignupResponse([Function(SignupResponseBuilder b) updates]) = _$SignupResponse;

  static Serializer<SignupResponse> get serializer => _$signupResponseSerializer;
}