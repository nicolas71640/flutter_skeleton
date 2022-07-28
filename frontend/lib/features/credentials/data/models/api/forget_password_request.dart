import 'package:json_annotation/json_annotation.dart';

part 'forget_password_request.g.dart';

@JsonSerializable(createFactory: false)
class ForgetPasswordRequest {
  final String email;

  ForgetPasswordRequest(this.email);

  Map<String, dynamic> toJson() => _$ForgetPasswordRequestToJson(this);
}
