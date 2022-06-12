// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$CredentialsApiService extends CredentialsApiService {
  _$CredentialsApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = CredentialsApiService;

  @override
  Future<Response<SignupResponse>> signup(SignupRequest signupRequest) {
    final $url = '/signup';
    final $body = signupRequest;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<SignupResponse, SignupResponse>($request);
  }

  @override
  Future<Response<LoginResponse>> login(LoginRequest loginRequest) {
    final $url = '/login';
    final $body = loginRequest;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<LoginResponse, LoginResponse>($request);
  }

  @override
  Future<Response<RefreshTokenResponse>> refreshToken(String refreshToken) {
    final $url = '/refreshToken';
    final $headers = {
      'Authorization': refreshToken,
    };

    final $request = Request('POST', $url, client.baseUrl, headers: $headers);
    return client.send<RefreshTokenResponse, RefreshTokenResponse>($request);
  }
}
