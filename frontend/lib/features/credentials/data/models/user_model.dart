import '../../domain/entities/user.dart';
import 'api/login_response.dart';

class UserModel extends User {
  const UserModel({required super.mail});

  factory UserModel.fromLoginReponse(LoginResponse loginResponse) {
    return UserModel(mail: loginResponse.userId);
  }
}
