import 'package:avecpaulette/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:avecpaulette/features/credentials/data/models/api/forget_password_request.dart';
import 'package:avecpaulette/features/credentials/data/models/api/login_request.dart';
import 'package:avecpaulette/features/credentials/data/models/api/oauth_request.dart';
import 'package:avecpaulette/features/credentials/data/models/api/signup_request.dart';
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

      final signupResponse =
          await credentialsApiService.signup(signupRequest).first;

      expect(signupResponse.message, "User Created");
      verify(mockDio.post("/auth/signup", data: signupRequest.toJson()));
    });

    test("shoud throw a DioError when an error is thrown", () async {
      final dioError = DioError(requestOptions: RequestOptions(path: ""));

      when(mockDio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => throw dioError);

      expect(credentialsApiService.signup(SignupRequest("email", "password")),
          emitsError(dioError));
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

      final loginResponse =
          await credentialsApiService.login(loginRequest).first;

      expect(loginResponse.email, equals(jsonResponse["email"]));
      expect(loginResponse.accessToken, equals(jsonResponse["accessToken"]));
      expect(loginResponse.refreshToken, equals(jsonResponse["refreshToken"]));
      verify(mockDio.post("/auth/login", data: loginRequest.toJson()));
    });

    test("shoud throw a DioError when an error is thrown", () async {
      final dioError = DioError(requestOptions: RequestOptions(path: ""));

      when(mockDio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => throw dioError);

      expect(credentialsApiService.login(LoginRequest("email", "password")),
          emitsError(dioError));
    });
  });

  group("RefreshToken", () {
    test("should return a RefreshTokenResponse when no error is thrown ",
        () async {
      final jsonResponse = fixtureJson("credentials/refresh_token_ok.json");

      when(mockDio.options).thenReturn(BaseOptions());
      when(mockDio.post(any)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(path: ""),
          statusCode: 200,
          data: jsonResponse));

      final response =
          await credentialsApiService.refreshToken("refreshToken").first;

      verify(mockDio.post("/auth/refreshToken"));

      expect(response.accessToken, equals(jsonResponse["accessToken"]));
    });

    test("shoud throw a DioError when an error is thrown", () async {
      final dioError = DioError(requestOptions: RequestOptions(path: ""));

      when(mockDio.options).thenReturn(BaseOptions());
      when(mockDio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => throw dioError);

      expect(credentialsApiService.refreshToken("refreshToken"),
          emitsError(dioError));
    });
  });

  group("oauth", () {
    test("should return a AuthenticationResponse when no error is thrown ",
        () async {
      final jsonResponse = fixtureJson("credentials/oauth_ok.json");
      when(mockDio.post(any, data: anyNamed("data"))).thenAnswer(
          (realInvocation) async => Response(
              requestOptions: RequestOptions(path: ""),
              statusCode: 200,
              data: jsonResponse));
      final oAuthRequest = OAuthRequest("idToken");

      final oAuthResponse =
          await credentialsApiService.oauth(oAuthRequest).first;

      expect(oAuthResponse.email, equals(jsonResponse["email"]));
      expect(oAuthResponse.accessToken, equals(jsonResponse["accessToken"]));
      expect(oAuthResponse.refreshToken, equals(jsonResponse["refreshToken"]));
      verify(mockDio.post("/auth/oauth", data: oAuthRequest.toJson()));
    });
  });

  group("forgetPassword", () {
    test("should return a ForgetPasswordResponse when no error is thrown ",
        () async {
      final jsonResponse = fixtureJson("credentials/forget_password_ok.json");
      when(mockDio.post(any, data: anyNamed("data"))).thenAnswer(
          (realInvocation) async => Response(
              requestOptions: RequestOptions(path: ""),
              statusCode: 201,
              data: jsonResponse));

      final forgetPasswordRequest = ForgetPasswordRequest("email");

      final forgetPasswordResponse = await credentialsApiService
          .forgetPassword(forgetPasswordRequest)
          .first;

      expect(forgetPasswordResponse.message, equals(jsonResponse["message"]));
      verify(mockDio.post("/auth/forgetPassword",
          data: forgetPasswordRequest.toJson()));
    });
  });
}
