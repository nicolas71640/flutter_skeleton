import 'dart:io';

import 'package:avecpaulette/core/error/failures.dart';
import 'package:avecpaulette/core/local_data_source/credentials_local_data_source.dart';
import 'package:avecpaulette/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:avecpaulette/features/credentials/data/models/api/forget_password_response.dart';
import 'package:avecpaulette/features/credentials/data/models/api/login_response.dart';
import 'package:avecpaulette/features/credentials/data/models/api/oauth_response.dart';
import 'package:avecpaulette/features/credentials/data/models/api/signup_response.dart';
import 'package:avecpaulette/features/credentials/data/repositories/credentials_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'credentials_repository_impl_test.mocks.dart';

@GenerateMocks([
  CredentialsApiService,
  CredentialsLocalDataSourceImpl,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
])
void main() {
  late MockCredentialsApiService mockCredentialsApiService;
  late MockCredentialsLocalDataSourceImpl mockCredentialsLocalDataSourceImpl;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;

  late CredentialsRepositoryImpl credentialsRepositoryImpl;

  setUp(() {
    mockCredentialsApiService = MockCredentialsApiService();
    mockCredentialsLocalDataSourceImpl = MockCredentialsLocalDataSourceImpl();
    mockGoogleSignIn = MockGoogleSignIn();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();

    credentialsRepositoryImpl = CredentialsRepositoryImpl(
        mockCredentialsApiService,
        mockCredentialsLocalDataSourceImpl,
        mockGoogleSignIn);

    when(mockCredentialsLocalDataSourceImpl.cacheCredentials(any, any, any))
        .thenAnswer((_) => Stream.value(null));

    when(mockCredentialsApiService.signup(any))
        .thenAnswer((_) => Stream.value(SignupResponse("User Created")));

    when(mockGoogleSignIn.signIn())
        .thenAnswer((_) => Future.value(mockGoogleSignInAccount));

    when(mockGoogleSignInAccount.authentication)
        .thenAnswer((_) => Future.value(mockGoogleSignInAuthentication));

    when(mockGoogleSignInAuthentication.idToken).thenAnswer((_) => "idToken");
  });

  group("signup", () {
    test("should return a User when no error is thrown ", () async {
      const userId = "userId";

      when(mockCredentialsApiService.login(any)).thenAnswer((_) =>
          Stream.value(LoginResponse(userId, "accessToken", "refreshToken")));

      final user =
          await credentialsRepositoryImpl.signup("mail", "password").first;

      expect(user.mail, equals(userId));
    });

    test(
        "should throw a EmailAlreadyUsed error when a  dio error is thrown with a status code unauthorized ",
        () async {
      final dioError = DioError(
          requestOptions: RequestOptions(path: ""),
          response: Response(
              statusCode: HttpStatus.unauthorized,
              requestOptions: RequestOptions(path: "")));

      when(mockCredentialsApiService.signup(any))
          .thenAnswer((_) => Stream.error(dioError));

      expect(credentialsRepositoryImpl.signup("email", "password"),
          emitsError(const TypeMatcher<EmailAlreadyUsed>()));
    });

    test(
        "should throw a ServerFailure error when a  dio error is thrown with another status code than unauthorized ",
        () async {
      final dioError = DioError(
          requestOptions: RequestOptions(path: ""),
          response: Response(
              statusCode: HttpStatus.badRequest,
              requestOptions: RequestOptions(path: "")));

      when(mockCredentialsApiService.signup(any))
          .thenAnswer((_) => Stream.error(dioError));

      expect(credentialsRepositoryImpl.signup("email", "password"),
          emitsError(const TypeMatcher<ServerFailure>()));
    });

    test(
        "should throw the same error when another error than a dio error is thrown ",
        () async {
      final error = Error();

      when(mockCredentialsApiService.signup(any))
          .thenAnswer((_) => Stream.error(error));

      expect(credentialsRepositoryImpl.signup("email", "password"),
          emitsError(error));
    });
  });

  group("login", () {
    test("should return a User when no error is thrown ", () async {
      const email = "email@test.com";
      const accessToken = "accessToken";
      const refreshToken = "refreshToken";

      when(mockCredentialsApiService.login(any)).thenAnswer(
          (_) => Stream.value(LoginResponse(email, accessToken, refreshToken)));

      final user =
          await credentialsRepositoryImpl.login("mail", "password").first;

      expect(user.mail, equals(email));
      verify(mockCredentialsLocalDataSourceImpl.cacheCredentials(
          email, accessToken, refreshToken));
    });

    test(
        "should throw a WrongId error when a  dio error is thrown with a status code unauthorized ",
        () async {
      final dioError = DioError(
          requestOptions: RequestOptions(path: ""),
          response: Response(
              statusCode: HttpStatus.unauthorized,
              requestOptions: RequestOptions(path: "")));

      when(mockCredentialsApiService.login(any))
          .thenAnswer((_) => Stream.error(dioError));

      expect(credentialsRepositoryImpl.login("email", "password"),
          emitsError(const TypeMatcher<WrongIds>()));
    });

    test(
        "should throw a ServerFailure error when a  dio error is thrown with another status code than unauthorized ",
        () async {
      final dioError = DioError(
          requestOptions: RequestOptions(path: ""),
          response: Response(
              statusCode: HttpStatus.badRequest,
              requestOptions: RequestOptions(path: "")));

      when(mockCredentialsApiService.login(any))
          .thenAnswer((_) => Stream.error(dioError));

      expect(credentialsRepositoryImpl.login("email", "password"),
          emitsError(const TypeMatcher<ServerFailure>()));
    });

    test(
        "should throw the same error when another error than a dio error is thrown ",
        () async {
      final error = Error();

      when(mockCredentialsApiService.login(any))
          .thenAnswer((_) => Stream.error(error));

      expect(credentialsRepositoryImpl.login("email", "password"),
          emitsError(error));
    });
  });

  group("googleLogin", () {
    test("should return a User when no error is thrown ", () async {
      const email = "email@test.com";
      const accessToken = "accessToken";
      const refreshToken = "refreshToken";

      when(mockCredentialsApiService.oauth(any)).thenAnswer(
          (_) => Stream.value(OAuthResponse(email, accessToken, refreshToken)));

      final user = await credentialsRepositoryImpl.googleLogin().first;

      expect(user.mail, equals(email));
      verify(mockCredentialsLocalDataSourceImpl.cacheCredentials(
          email, accessToken, refreshToken));
    });

    test("should return a ServerFailure when Google can't sign in", () async {
      when(mockGoogleSignIn.signIn()).thenAnswer((_) => Future.value(null));

      expect(credentialsRepositoryImpl.googleLogin(),
          emitsError(const TypeMatcher<ServerFailure>()));
    });

    test(
        "should return a EmailAlreadyUsed when a dio error is thrown with a status code unauthorized",
        () async {
      final dioError = DioError(
          requestOptions: RequestOptions(path: ""),
          response: Response(
              statusCode: HttpStatus.unauthorized,
              requestOptions: RequestOptions(path: "")));

      when(mockCredentialsApiService.oauth(any))
          .thenAnswer((_) => Stream.error(dioError));

      expect(credentialsRepositoryImpl.googleLogin(),
          emitsError(const TypeMatcher<EmailAlreadyUsed>()));
    });

    test(
        "should throw a ServerFailure error when a  dio error is thrown with another status code than unauthorized ",
        () async {
      final dioError = DioError(
          requestOptions: RequestOptions(path: ""),
          response: Response(
              statusCode: HttpStatus.badRequest,
              requestOptions: RequestOptions(path: "")));

      when(mockCredentialsApiService.oauth(any))
          .thenAnswer((_) => Stream.error(dioError));

      expect(credentialsRepositoryImpl.googleLogin(),
          emitsError(const TypeMatcher<ServerFailure>()));
    });

    test(
        "should throw the same error when another error than a dio error is thrown ",
        () async {
      final error = Error();

      when(mockCredentialsApiService.oauth(any))
          .thenAnswer((_) => Stream.error(error));

      expect(credentialsRepositoryImpl.googleLogin(), emitsError(error));
    });
  });

  group("forgetPassword", () {
    test("should complete when api service return no error", () async {
      when(mockCredentialsApiService.forgetPassword(any))
          .thenAnswer((_) => Stream.value(ForgetPasswordResponse("ok")));

      expectLater(credentialsRepositoryImpl.forgetPassword("mail"), emitsDone);

      verify(mockCredentialsApiService.forgetPassword(any));
    });

    test("should return EmailNotFound when api service return an 401 error",
        () async {
      when(mockCredentialsApiService.forgetPassword(any)).thenAnswer((_) =>
          Stream.error(DioError(
              requestOptions: RequestOptions(path: ""),
              response: Response(
                  requestOptions: RequestOptions(path: ""),
                  statusCode: HttpStatus.unauthorized))));

      expect(credentialsRepositoryImpl.forgetPassword("email"),
          emitsError(const TypeMatcher<EmailNotFound>()));
    });

    test("should return ServerFailure when api service return an 500 error",
        () async {
      when(mockCredentialsApiService.forgetPassword(any)).thenAnswer((_) =>
          Stream.error(DioError(
              requestOptions: RequestOptions(path: ""),
              response: Response(
                  requestOptions: RequestOptions(path: ""),
                  statusCode: HttpStatus.internalServerError))));

      expect(credentialsRepositoryImpl.forgetPassword("email"),
          emitsError(const TypeMatcher<ServerFailure>()));
    });

    test(
        "should throw the same error when another error than a dio error is thrown ",
        () async {
      final error = Error();

      when(mockCredentialsApiService.forgetPassword(any))
          .thenAnswer((_) => Stream.error(error));

      expect(
          credentialsRepositoryImpl.forgetPassword("email"), emitsError(error));
    });
  });
}
