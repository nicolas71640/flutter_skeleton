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

  Future<SignupResponse> signup(SignupRequest signupRequest) async {
    developer.log("signup");

    Response response = await dio.post(
      '/auth/signup',
      data: signupRequest.toJson(),
    );

    SignupResponse signupResponse = SignupResponse.fromJson(response.data);

    return signupResponse;
  }

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    developer.log("login");

    Response response = await dio.post(
      '/auth/login',
      data: loginRequest.toJson(),
    );

    LoginResponse loginResponse = LoginResponse.fromJson(response.data);

    return loginResponse;
  }

  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    developer.log("refreshToken");
    dio.options.headers["Authorization"] = NetworkUtils.BEARER + refreshToken;
    Response response = await dio.post('/auth/refreshToken');

    RefreshTokenResponse refreshTokenResponse =
        RefreshTokenResponse.fromJson(response.data);

    return refreshTokenResponse;
  }
}
