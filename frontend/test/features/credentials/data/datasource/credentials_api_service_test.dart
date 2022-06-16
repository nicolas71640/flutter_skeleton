import 'dart:convert';

import 'package:departments/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:departments/features/credentials/data/models/api/login_request.dart';
import 'package:departments/features/credentials/data/models/api/signup_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'credentials_api_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late CredentialsApiService credentialsApiService;

  setUp(() {
    mockDio = MockDio();
    credentialsApiService = CredentialsApiService(mockDio);
  });

  group("Signup", () {
    test("should return a SignUpResponse when no error is thrown ", () async {
      when(mockDio.post(any, data: anyNamed("data"))).thenAnswer(
          (realInvocation) async => Response(
              requestOptions: RequestOptions(path: ""),
              statusCode: 200,
              data: fixtureJson("credentials/signup_ok.json")));

      final signupRequest = SignupRequest("email", "password");
      final result = await credentialsApiService
          .signup(signupRequest);

      verify(mockDio.post("/auth/signup",data: signupRequest.toJson()));
      expect(result.message, equals("User Created"));
    });

    test("shoud throw a DioError when an error is thrown", () async {
      when(mockDio.post(any, data: anyNamed("data")))
          .thenThrow(DioError(requestOptions: RequestOptions(path: "")));

      try {
        await credentialsApiService.signup(SignupRequest("email", "password"));
      } catch (error) {
        expect(error, isA<DioError>());
        return;
      }
      fail("No Error thrown");
    });
  });

  group("Login", () {
    test("should return a LoginResponse when no error is thrown ", () async {
      final jsonResponse = fixtureJson("credentials/login_ok.json");

      when(mockDio.post(any, data: anyNamed("data"))).thenAnswer(
          (realInvocation) async => Response(
              requestOptions: RequestOptions(path: ""),
              statusCode: 200,
              data: jsonResponse));

      final loginRequest = LoginRequest("email", "password");
      final response = await credentialsApiService
          .login(loginRequest);


      verify(mockDio.post("/auth/login",data: loginRequest.toJson()));

      expect(response.userId, equals(jsonResponse["userId"]));
      expect(response.accessToken, equals(jsonResponse["accessToken"]));
      expect(response.refreshToken, equals(jsonResponse["refreshToken"]));

    });

    test("shoud throw a DioError when an error is thrown", () async {
      when(mockDio.post(any, data: anyNamed("data")))
          .thenThrow(DioError(requestOptions: RequestOptions(path: "")));

      try {
        await credentialsApiService.login(LoginRequest("email", "password"));
      } catch (error) {
        expect(error, isA<DioError>());
        return;
      }
      fail("No Error thrown");
    });
  });


  group("RefreshToken", () {
    test("should return a RefreshTokenResponse when no error is thrown ", () async {
      final jsonResponse = fixtureJson("credentials/refresh_token_ok.json");

      when(mockDio.options).thenReturn(BaseOptions());
      when(mockDio.post(any)).thenAnswer(
          (realInvocation) async => Response(
              requestOptions: RequestOptions(path: ""),
              statusCode: 200,
              data: jsonResponse));

      final response = await credentialsApiService
          .refreshToken("refreshToken");

      verify(mockDio.post("/auth/refreshToken"));

      expect(response.accessToken, equals(jsonResponse["accessToken"]));

    });

    test("shoud throw a DioError when an error is thrown", () async {
            when(mockDio.options).thenReturn(BaseOptions());

      when(mockDio.post(any))
          .thenThrow(DioError(requestOptions: RequestOptions(path: "")));

      try {
        await credentialsApiService.refreshToken("refreshToken");
      } catch (error) {
        expect(error, isA<DioError>());
        return;
      }
      fail("No Error thrown");
    });
  });
}
