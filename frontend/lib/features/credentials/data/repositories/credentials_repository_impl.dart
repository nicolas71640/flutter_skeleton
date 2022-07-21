import 'dart:io';

import 'package:avecpaulette/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:avecpaulette/features/credentials/data/models/api/oauth_request.dart';
import 'package:avecpaulette/features/credentials/data/models/user_model.dart';
import 'package:avecpaulette/features/credentials/domain/entities/user.dart';
import 'package:avecpaulette/core/error/failures.dart';
import 'package:avecpaulette/features/credentials/domain/repositories/credentials_repository.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/network/credentials_local_data_source.dart';
import '../models/api/login_request.dart';
import '../models/api/signup_request.dart';

class WrongIds extends ServerFailure {}

class EmailAlreadyUsed extends ServerFailure {}

class CredentialsRepositoryImpl implements CredentialsRepository {
  final CredentialsApiService credentialsApiService;
  final CredentialsLocalDataSource credentialsLocalDataSource;
  final GoogleSignIn googleSignIn;

  CredentialsRepositoryImpl(this.credentialsApiService,
      this.credentialsLocalDataSource, this.googleSignIn);

  @override
  Stream<User> signup(String mail, String password) {
    return credentialsApiService
        .signup(SignupRequest(mail, password))
        .flatMap((_) => login(mail, password))
        .onErrorResume((error, stackTrace) {
      if (error is DioError) {
        if (error.response?.statusCode == HttpStatus.unauthorized) {
          return Stream.error(EmailAlreadyUsed());
        } else {
          return Stream.error(ServerFailure());
        }
      }
      return Stream.error(error);
    });
  }

  @override
  Stream<User> login(String mail, String password) {
    return credentialsApiService
        .login(LoginRequest(mail, password))
        .flatMap((loginResponse) {
      return credentialsLocalDataSource
          .cacheCredentials(loginResponse.email, loginResponse.accessToken,
              loginResponse.refreshToken)
          .map(((_) => UserModel.fromLoginReponse(loginResponse)));
    }).onErrorResume((error, stackTrace) {
      if (error is DioError) {
        if (error.response?.statusCode == HttpStatus.unauthorized) {
          return Stream.error(WrongIds());
        } else {
          return Stream.error(ServerFailure());
        }
      }
      return Stream.error(error);
    });
  }

  @override
  Stream<User> googleLogin() {
    return Stream.fromFuture(googleSignIn.signIn())
        .flatMap((account) {
          if (account != null) {
            return Stream.value(account);
          } else {
            return Stream.error(ServerFailure());
          }
        })
        .flatMap((account) => Stream.fromFuture(account.authentication))
        .flatMap((authentication) {
          return credentialsApiService
              .oauth(OAuthRequest(authentication.idToken));
        })
        .flatMap((oAuthResponse) {
          return credentialsLocalDataSource
              .cacheCredentials(oAuthResponse.email, oAuthResponse.accessToken,
                  oAuthResponse.refreshToken)
              .map(((_) => UserModel.fromOAuthResponse(oAuthResponse)));
        })
        .onErrorResume((error, stackTrace) {
          if (error is DioError) {
            if (error.response?.statusCode == HttpStatus.unauthorized) {
              return Stream.error(EmailAlreadyUsed());
            } else {
              return Stream.error(ServerFailure());
            }
          }
          return Stream.error(error);
        });
  }
}
