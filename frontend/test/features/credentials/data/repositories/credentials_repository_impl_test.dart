import 'dart:io';

import 'package:avecpaulette/core/error/failures.dart';
import 'package:avecpaulette/core/network/credentials_local_data_source.dart';
import 'package:avecpaulette/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:avecpaulette/features/credentials/data/models/api/login_response.dart';
import 'package:avecpaulette/features/credentials/data/models/api/signup_response.dart';
import 'package:avecpaulette/features/credentials/data/repositories/credentials_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'credentials_repository_impl_test.mocks.dart';

@GenerateMocks([CredentialsApiService, CredentialsLocalDataSourceImpl])
void main() {
  late MockCredentialsApiService mockCredentialsApiService;
  late MockCredentialsLocalDataSourceImpl mockCredentialsLocalDataSourceImpl;

  late CredentialsRepositoryImpl credentialsRepositoryImpl;

  setUp(() {
    mockCredentialsApiService = MockCredentialsApiService();
    mockCredentialsLocalDataSourceImpl = MockCredentialsLocalDataSourceImpl();
    credentialsRepositoryImpl = CredentialsRepositoryImpl(
        mockCredentialsApiService, mockCredentialsLocalDataSourceImpl);

    when(mockCredentialsLocalDataSourceImpl.cacheCredentials(any, any, any))
        .thenAnswer((_) => Stream.value(null));

    when(mockCredentialsApiService.signup(any))
        .thenAnswer((_) => Stream.value(SignupResponse("User Created")));
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
      const userId = "userId";
      const accessToken = "userId";
      const refreshToken = "refreshToken";

      when(mockCredentialsApiService.login(any)).thenAnswer((_) =>
          Stream.value(LoginResponse(userId, accessToken, refreshToken)));

      final user =
          await credentialsRepositoryImpl.login("mail", "password").first;

      expect(user.mail, equals(userId));
      verify(mockCredentialsLocalDataSourceImpl.cacheCredentials(
          userId, accessToken, refreshToken));
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
}
