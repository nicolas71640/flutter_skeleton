import 'dart:io';

import 'package:departments/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:departments/features/credentials/data/models/user_model.dart';
import 'package:departments/features/credentials/domain/entities/user.dart';
import 'package:departments/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:departments/features/credentials/domain/repositories/credentials_repository.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/credentials_local_data_source.dart';
import '../models/api/login_request.dart';
import '../models/api/signup_request.dart';

class WrongIds extends ServerFailure {}

class EmailAlreadyUsed extends ServerFailure {}

class CredentialsRepositoryImpl implements CredentialsRepository {
  final CredentialsApiService credentialsApiService;
  final CredentialsLocalDataSource credentialsLocalDataSource;

  CredentialsRepositoryImpl(
      this.credentialsApiService, this.credentialsLocalDataSource);

  @override
  Future<Either<Failure, User>> login(String mail, String password) async {
    try {
      final user = await credentialsApiService
          .login(LoginRequest(mail, password))
          .then((loginResponse) async {
        await credentialsLocalDataSource.cacheCredentials(loginResponse.userId,
            loginResponse.accessToken, loginResponse.refreshToken);
        return UserModel.fromLoginReponse(loginResponse);
      });
      return Right(user);
    } on DioError catch (error) {
      if (error.response?.statusCode == HttpStatus.unauthorized) {
        return Left(WrongIds());
      } else {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, User>> signup(String mail, String password) async {
    try {
      final result = await credentialsApiService
          .signup(SignupRequest(mail, password))
          .then((signupResponse) {
        return login(mail, password);
      });
      return result;
    } on DioError catch (error) {
      if (error.response?.statusCode == HttpStatus.badRequest) {
        return Left(EmailAlreadyUsed());
      } else {
        return Left(ServerFailure());
      }
    }
  }
}
