import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_request.g.dart';

abstract class LoginRequest implements Built<LoginRequest, LoginRequestBuilder> {
  // IDs are set in the back-end.
  // In a POST request, BuiltPost's ID will be null.
  // Only BuiltPosts obtained through a GET request will have an ID.
  int? get id;

  String get email;
  String get password;

  LoginRequest._();

  factory LoginRequest([Function(LoginRequestBuilder b) updates]) = _$LoginRequest;

  static Serializer<LoginRequest> get serializer => _$loginRequestSerializer;
}