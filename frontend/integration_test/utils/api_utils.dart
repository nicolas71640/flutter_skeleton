import 'package:avecpaulette/core/network/network_utils.dart';
import 'package:avecpaulette/features/credentials/data/models/api/signup_request.dart';
import 'package:avecpaulette/features/credentials/domain/entities/user.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class ApiUtils {
  final Dio dio = Dio(BaseOptions(baseUrl: NetworkUtils.BASE_URL));

  Stream<void> deleteUser(String email) {
    return Stream.fromFuture(dio.post(
      '/auth/devDelete',
      data: {"email": email},
    ));
  }

  Stream<User> createUser(
      {String email = "test@test.com", String password = "default_password"}) {
    return Stream.fromFuture(dio.post(
      '/auth/signup',
      data: SignupRequest(email, password).toJson(),
    )).flatMap((_) => Stream.value(User(mail: email)));
  }
}
