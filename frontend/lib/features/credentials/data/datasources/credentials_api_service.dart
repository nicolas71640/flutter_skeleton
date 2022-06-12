// Source code generation in Dart works by creating a new file which contains a "companion class".
// In order for the source gen to know which file to generate and which files are "linked", you need to use the part keyword.
import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:departments/core/network/build_value_converter.dart';
import 'package:departments/features/credentials/data/models/login_response.dart';
import 'package:departments/features/credentials/data/models/refresh_token_response.dart';
import 'package:departments/features/credentials/data/models/signup_request.dart';
import 'package:departments/features/credentials/data/models/signup_response.dart';

import '../../../../core/network/network_utils.dart';
import '../models/login_request.dart';

part 'credentials_api_service.chopper.dart';

@ChopperApi()
abstract class CredentialsApiService extends ChopperService {
  @Post(path: '/signup')
  Future<Response<SignupResponse>> signup(@Body() SignupRequest signupRequest);

  @Post(path: '/login')
  Future<Response<LoginResponse>> login(@Body() LoginRequest loginRequest);

  @Post(optionalBody: true, path: '/refreshToken')
  Future<Response<RefreshTokenResponse>> refreshToken(
    @Header('Authorization') String refreshToken,
  );

  static CredentialsApiService create() {
    final client = ChopperClient(
      interceptors: [HttpLoggingInterceptor()],
      // The first part of the URL is now here
      baseUrl: '${NetworkUtils.BASE_URL}/api/auth',
      services: [
        // The generated implementation
        _$CredentialsApiService(),
      ],
      // Converts data to & from JSON and adds the application/json header.
      converter: BuiltValueConverter(),
    );

    // The generated class with the ChopperClient passed in
    return _$CredentialsApiService(client);
  }
}

