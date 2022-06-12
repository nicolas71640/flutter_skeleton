import 'package:departments/features/credentials/data/models/login_response.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required super.mail});

  factory UserModel.fromLoginReponse(LoginResponse loginResponse) {
    return UserModel(mail: loginResponse.userId);
  }
}
