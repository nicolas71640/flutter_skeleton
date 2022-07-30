import 'dart:async';

import 'package:avecpaulette/features/credentials/data/models/api/forget_password_request.dart';
import 'package:avecpaulette/features/credentials/data/models/api/forget_password_response.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/network_utils.dart';
import 'dart:developer' as developer;

import '../models/api/login_request.dart';
import '../models/api/login_response.dart';
import '../models/api/oauth_request.dart';
import '../models/api/oauth_response.dart';
import '../models/api/refresh_token_response.dart';
import '../models/api/signup_request.dart';
import '../models/api/signup_response.dart';

class CredentialsApiService {
  final Dio dio;

  CredentialsApiService(this.dio);

  Stream<SignupResponse> signup(SignupRequest signupRequest) {
    developer.log("signup");

    return Stream.fromFuture(dio.post(
      '/auth/signup',
      data: signupRequest.toJson(),
    )).map((response) => SignupResponse.fromJson(response.data));
  }

  Stream<LoginResponse> login(LoginRequest loginRequest) {
    developer.log("login");

    return Stream.fromFuture(dio.post(
      '/auth/login',
      data: loginRequest.toJson(),
    )).map((response) => LoginResponse.fromJson(response.data));
  }

  Stream<OAuthResponse> oauth(OAuthRequest oAuthRequest) {
    developer.log("oauth");

    return Stream.fromFuture(dio.post(
      '/auth/oauth',
      data: oAuthRequest.toJson(),
    )).map((response) => OAuthResponse.fromJson(response.data));
  }

  Stream<RefreshTokenResponse> refreshToken(String refreshToken) {
    developer.log("refreshToken");
    dio.options.headers["Authorization"] = NetworkUtils.BEARER + refreshToken;
    return Stream.fromFuture(dio.post('/auth/refreshToken'))
        .map((response) => RefreshTokenResponse.fromJson(response.data));
  }

  Stream<ForgetPasswordResponse> forgetPassword(
      ForgetPasswordRequest forgetPasswordRequest) {
    developer.log("forgetPassword");
    return Stream.fromFuture(dio.post('/auth/forgetPassword',
            data: forgetPasswordRequest.toJson()))
        .map((response) => ForgetPasswordResponse.fromJson(response.data));
  }
}
