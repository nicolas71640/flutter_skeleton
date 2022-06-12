import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:departments/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:departments/features/credentials/data/models/login_request.dart';
import 'package:departments/features/credentials/data/models/signup_request.dart';
import 'package:departments/features/credentials/data/models/user_model.dart';
import 'package:departments/features/credentials/domain/entities/user.dart';
import 'package:departments/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:departments/features/credentials/domain/repositories/credentials_repository.dart';
import 'dart:developer' as developer;

import '../../../../core/network/credentials_local_data_source.dart';
import '../models/login_response.dart';

class WrongIds extends ServerFailure {}

class EmailAlreadyUsed extends ServerFailure {}

class CredentialsRepositoryImpl implements CredentialsRepository {
  final CredentialsApiService credentialsApiService;
  final CredentialsLocalDataSource credentialsLocalDataSource;

  CredentialsRepositoryImpl(this.credentialsApiService, this.credentialsLocalDataSource);

  @override
  Future<Either<Failure, User>> login(String mail, String password) async {
    try {
      Response<LoginResponse> response =
          await credentialsApiService.login(LoginRequest((b) => b
            ..email = mail
            ..password = password));

      final loginResponse = response.body;
      print(loginResponse);

      if (response.statusCode == HttpStatus.ok && loginResponse != null) {
        await credentialsLocalDataSource.cacheCredentials(loginResponse.userId,loginResponse.accessToken,loginResponse.refreshToken);
        return Right(UserModel.fromLoginReponse(loginResponse));
      } else if (response.statusCode == HttpStatus.unauthorized) {
        return Left(WrongIds());
      } else {
        developer.log(response.error.toString());
        return Left(ServerFailure());
      }
    } catch (error) {
      developer.log(error.toString());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signup(String mail, String password) async {
    try {
      Response response =
          await credentialsApiService.signup(SignupRequest((b) => b
            ..email = mail
            ..password = password));

      if (response.statusCode == HttpStatus.created) {
        developer.log("Signup succeed");
        return login(mail, password);
      } else if (response.statusCode == HttpStatus.badRequest) {
        developer.log(response.error.toString());
        return Left(EmailAlreadyUsed());
      } else {
        developer.log(response.error.toString());
        return Left(ServerFailure());
      }
    } catch (error) {
      developer.log(error.toString());
      return Left(ServerFailure());
    }
  }
}
