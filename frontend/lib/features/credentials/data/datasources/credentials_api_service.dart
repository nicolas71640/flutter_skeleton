import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../core/network/network_utils.dart';
import 'dart:developer' as developer;

import '../models/api/login_request.dart';
import '../models/api/login_response.dart';
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

  Stream<RefreshTokenResponse> refreshToken(String refreshToken) {
    developer.log("refreshToken");
    dio.options.headers["Authorization"] = NetworkUtils.BEARER + refreshToken;
    return Stream.fromFuture(dio.post('/auth/refreshToken'))
        .map((response) => RefreshTokenResponse.fromJson(response.data));
  }
}
