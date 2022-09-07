import 'package:avecpaulette/core/local_data_source/credentials_local_data_source.dart';
import 'package:avecpaulette/core/network/network_utils.dart';
import 'package:avecpaulette/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:avecpaulette/features/credentials/data/models/api/signup_request.dart';
import 'package:avecpaulette/features/credentials/domain/entities/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';

class ApiUtils {
  final Dio dio = Dio(BaseOptions(baseUrl: NetworkUtils.BASE_URL));
  late CredentialsApiService credentialsApiService = CredentialsApiService(dio);
  late CredentialsLocalDataSource credentialsLocalDataSource = CredentialsLocalDataSourceImpl(const FlutterSecureStorage());

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

  Stream<void> cleanLocalDb()
  {
    return credentialsLocalDataSource.cleanCredentials();
  }

  // Stream<User> loginUser({String email = "test@test.com", String password = "default_password"})
  // {
  //     CredentialsRepositoryImpl()
  // }
}
