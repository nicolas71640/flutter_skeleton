import 'package:json_annotation/json_annotation.dart';
part 'forget_password_response.g.dart';

@JsonSerializable(createToJson: false)
class ForgetPasswordResponse {
  final String message;

  ForgetPasswordResponse(this.message);

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseFromJson(json);
}
