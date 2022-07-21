import 'package:avecpaulette/features/credentials/data/models/api/oauth_response.dart';

import '../../domain/entities/user.dart';
import 'api/login_response.dart';

class UserModel extends User {
  const UserModel({required super.mail});

  factory UserModel.fromLoginReponse(LoginResponse loginResponse) {
    return UserModel(mail: loginResponse.email);
  }

  factory UserModel.fromOAuthResponse(OAuthResponse oAuthResponse) {
    return UserModel(mail: oAuthResponse.email);
  }
}
