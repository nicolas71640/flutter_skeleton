import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'signup_request.g.dart';

abstract class SignupRequest implements Built<SignupRequest, SignupRequestBuilder> {
  String get email;
  String get password;

  SignupRequest._();

  factory SignupRequest([Function(SignupRequestBuilder b) updates]) = _$SignupRequest;

  static Serializer<SignupRequest> get serializer => _$signupRequestSerializer;
}