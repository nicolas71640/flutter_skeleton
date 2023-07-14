import 'package:avecpaulette/core/error/exceptions.dart';
import 'package:avecpaulette/core/local_data_source/credentials_local_data_source.dart';
import 'package:avecpaulette/core/network/api.dart';
import 'package:avecpaulette/core/network/network_utils.dart';
import 'package:avecpaulette/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:avecpaulette/features/credentials/data/models/api/refresh_token_response.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'api_test.mocks.dart';

@GenerateMocks([
  Dio,
  CredentialsLocalDataSource,
  CredentialsApiService,
  RequestInterceptorHandler,
  ErrorInterceptorHandler,
  ResponseInterceptorHandler,
])
void main() {
  late AppInterceptors appInterceptors;
  late MockDio mockDio;
  late MockCredentialsLocalDataSource mockCredentialsLocalDataSource;
  late MockCredentialsApiService mockCredentialsApiService;

  setUp(() {
    mockDio = MockDio();
    mockCredentialsLocalDataSource = MockCredentialsLocalDataSource();
    mockCredentialsApiService = MockCredentialsApiService();
    appInterceptors = AppInterceptors(
      mockDio,
      mockCredentialsLocalDataSource,
      mockCredentialsApiService,
    );
  });

  group('AppInterceptors.onRequest', () {
    test("should add the access token the request", () async {
      const accessToken = "accessToken";
      var handler = MockRequestInterceptorHandler();
      var requestOptions = RequestOptions(path: "");
      when(mockCredentialsLocalDataSource.getAccessToken())
          .thenAnswer((realInvocation) => Stream.value(accessToken));

      appInterceptors.onRequest(requestOptions, handler);

      await untilCalled(handler.next(requestOptions));

      verify(handler.next(requestOptions));
      expect(requestOptions.headers['Authorization'],
          equals('Bearer $accessToken'));
    });

    test("should throw an error if no accessToken is avalaible", () async {
      var handler = MockRequestInterceptorHandler();
      var requestOptions = RequestOptions(path: "");

      when(mockCredentialsLocalDataSource.getAccessToken())
          .thenThrow(CacheException());

      expect(() => appInterceptors.onRequest(requestOptions, handler),
          throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('AppInterceptors.onError', () {
    test("should refresh the accessToken if statusCode is 401", () async {
      const refreshToken = "refreshToken";
      const newAccessToken = "newAccessToken";
      var handler = MockErrorInterceptorHandler();
      var requestOptions = RequestOptions(path: "");
      when(mockCredentialsLocalDataSource.getRefreshToken())
          .thenAnswer((realInvocation) => Stream.value(refreshToken));
      when(mockCredentialsApiService.refreshToken(any)).thenAnswer(
          (realInvocation) =>
              Stream.value(RefreshTokenResponse(newAccessToken)));
      when(mockCredentialsLocalDataSource.cacheAccessToken(any))
          .thenAnswer((realInvocation) => Stream.value(null));
      when(mockDio.request(any,
              data: anyNamed("data"),
              queryParameters: anyNamed("queryParameters"),
              options: anyNamed("options")))
          .thenAnswer((realInvocation) =>
              Future.value(Response(requestOptions: requestOptions)));

      appInterceptors.onError(
          DioError(
              requestOptions: requestOptions,
              response:
                  Response(requestOptions: requestOptions, statusCode: 401)),
          handler);

      await untilCalled(mockDio.request(requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: anyNamed("options")));

      verify(mockCredentialsLocalDataSource.getRefreshToken());
      verify(mockCredentialsApiService.refreshToken(refreshToken));
      verify(mockCredentialsLocalDataSource.cacheAccessToken(newAccessToken));
    });

    test("should retry 3 times to get the refreshToken", () async {
      const refreshToken = "refreshToken";
      const newAccessToken = "newAccessToken";
      var handler = MockErrorInterceptorHandler();
      var requestOptions = RequestOptions(path: "");
      var dioError = DioError(
          requestOptions: requestOptions,
          response: Response(requestOptions: requestOptions, statusCode: 401));

      when(mockCredentialsLocalDataSource.getRefreshToken())
          .thenAnswer((realInvocation) => Stream.value(refreshToken));
      when(mockCredentialsApiService.refreshToken(any)).thenAnswer(
          (realInvocation) =>
              Stream.value(RefreshTokenResponse(newAccessToken)));
      when(mockCredentialsLocalDataSource.cacheAccessToken(any))
          .thenAnswer((realInvocation) => Stream.value(null));
      when(mockDio.request(any,
              data: anyNamed("data"),
              queryParameters: anyNamed("queryParameters"),
              options: anyNamed("options")))
          .thenAnswer((realInvocation) {
        appInterceptors.onError(dioError, handler);
        return Future.value(Response(requestOptions: RequestOptions(path: "")));
      });

      appInterceptors.onError(dioError, handler);

      await untilCalled(handler.next(dioError));

      verify(mockCredentialsLocalDataSource.getRefreshToken()).called(3);
      verify(mockCredentialsApiService.refreshToken(refreshToken)).called(3);
      verify(mockCredentialsLocalDataSource.cacheAccessToken(newAccessToken))
          .called(3);
    });

    test("should reset retries after a response", () async {
      const refreshToken = "refreshToken";
      const newAccessToken = "newAccessToken";
      var retries = 0;
      var handler = MockErrorInterceptorHandler();
      var responseHandler = MockResponseInterceptorHandler();

      var requestOptions = RequestOptions(path: "");
      var dioError = DioError(
          requestOptions: requestOptions,
          response: Response(requestOptions: requestOptions, statusCode: 401));

      when(mockCredentialsLocalDataSource.getRefreshToken())
          .thenAnswer((realInvocation) => Stream.value(refreshToken));
      when(mockCredentialsApiService.refreshToken(any)).thenAnswer(
          (realInvocation) =>
              Stream.value(RefreshTokenResponse(newAccessToken)));
      when(mockCredentialsLocalDataSource.cacheAccessToken(any))
          .thenAnswer((realInvocation) => Stream.value(null));
      when(mockDio.request(any,
              data: anyNamed("data"),
              queryParameters: anyNamed("queryParameters"),
              options: anyNamed("options")))
          .thenAnswer((realInvocation) {
        retries++;
        if (retries == 1) {
          appInterceptors.onError(dioError, handler);
        } else if (retries == 2) {
          appInterceptors.onResponse(
              Response(requestOptions: requestOptions), responseHandler);
          appInterceptors.onError(dioError, handler);
        } else {
          appInterceptors.onError(dioError, handler);
        }

        return Future.value(Response(requestOptions: requestOptions));
      });

      appInterceptors.onError(dioError, handler);

      await untilCalled(handler.next(dioError));

      verify(mockCredentialsLocalDataSource.getRefreshToken()).called(5);
      verify(mockCredentialsApiService.refreshToken(refreshToken)).called(5);
      verify(mockCredentialsLocalDataSource.cacheAccessToken(newAccessToken))
          .called(5);
    });

    test("should forward error when retry throws an error", () async {
      const refreshToken = "refreshToken";
      const newAccessToken = "newAccessToken";
      var handler = MockErrorInterceptorHandler();

      var requestOptions = RequestOptions(path: "");
      var dioError = DioError(
          requestOptions: requestOptions,
          response: Response(requestOptions: requestOptions, statusCode: 401));

      when(mockCredentialsLocalDataSource.getRefreshToken())
          .thenAnswer((realInvocation) => Stream.value(refreshToken));
      when(mockCredentialsApiService.refreshToken(any)).thenAnswer(
          (realInvocation) =>
              Stream.value(RefreshTokenResponse(newAccessToken)));
      when(mockCredentialsLocalDataSource.cacheAccessToken(any))
          .thenAnswer((realInvocation) => Stream.value(null));
      when(mockDio.request(any,
              data: anyNamed("data"),
              queryParameters: anyNamed("queryParameters"),
              options: anyNamed("options")))
          .thenThrow(dioError);

      appInterceptors.onError(dioError, handler);

      await untilCalled(handler.next(dioError));

      verify(mockCredentialsLocalDataSource.getRefreshToken()).called(1);
      verify(mockCredentialsApiService.refreshToken(refreshToken)).called(1);
      verify(mockCredentialsLocalDataSource.cacheAccessToken(newAccessToken))
          .called(1);
    });
  });

  group('Api.createDio', () {
    test(
        "should create a dio with the corect URL and the correct interceptors (Log and App)",
        () async {
      var dio = Api.createInternalDio(
          mockCredentialsLocalDataSource, mockCredentialsApiService);
      expect(dio.options.baseUrl, NetworkUtils.BASE_URL);
      expect(dio.interceptors[0], const TypeMatcher<AppInterceptors>());
      expect(dio.interceptors[1], const TypeMatcher<LogInterceptor>());
    });
  });

  group('Api.createCredentialsDio', () {
    test(
        "should create a dio with the correct URL and only the log interceptor",
        () async {
      var dio = Api.createCredentialsDio();
      expect(dio.options.baseUrl, NetworkUtils.BASE_URL);
      expect(dio.interceptors[0], const TypeMatcher<LogInterceptor>());
    });
  });
}
