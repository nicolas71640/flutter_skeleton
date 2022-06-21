import 'package:json_annotation/json_annotation.dart';

part 'signup_request.g.dart';

@JsonSerializable(createFactory: false)
class SignupRequest {
  final String email;
  final String password;

  SignupRequest(this.email, this.password);

  Map<String, dynamic> toJson() => _$SignupRequestToJson(this);
}
