

import 'package:departments/core/network/credentials_local_data_source.dart';
import 'package:departments/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:departments/features/credentials/data/repositories/credentials_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final CredentialsRepositoryImpl repository = CredentialsRepositoryImpl(CredentialsApiService.create(), CredentialsLocalDataSourceImpl(sharedPreferences));

  test("Login", () async {
      final response = await repository.login("mail", "password");
      print(response);
  });

  test("SignUp", () async {
      final response = await repository.signup("mail", "password");
      print(response);
  });
 
}
