import 'package:departments/core/network/credentials_local_data_source.dart';
import 'package:departments/core/network/network_utils.dart';
import 'package:departments/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:dio/dio.dart';

class Api {
  static Dio createDio(CredentialsLocalDataSource credentialsLocalDataSource,
      CredentialsApiService credentialsApiService) {
    Dio dio = Dio(BaseOptions(baseUrl: NetworkUtils.BASE_URL));
    dio.interceptors.addAll({
      AppInterceptors(dio, credentialsLocalDataSource, credentialsApiService),
      LogInterceptor(),
    });
    return dio;
  }

  static Dio createCredentialsDio() {
    Dio dio = Dio(BaseOptions(baseUrl: NetworkUtils.BASE_URL));
    dio.interceptors.add(LogInterceptor());
    return dio;
  }
}

class AppInterceptors extends Interceptor {
  final Dio dio;
  final CredentialsLocalDataSource credentialsLocalDataSource;
  final CredentialsApiService credentialsApiService;
  int retries = 0;

  AppInterceptors(
      this.dio, this.credentialsLocalDataSource, this.credentialsApiService);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var accessToken = await credentialsLocalDataSource.getAccessToken();
    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    retries = 0;
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && retries++ < 3) {
      final refreshToken = await credentialsLocalDataSource.getRefreshToken();
      final accessTokenResponse =
          await credentialsApiService.refreshToken(refreshToken);
      await credentialsLocalDataSource
          .cacheAccessToken(accessTokenResponse.accessToken);
      try {
        await _retry(err.requestOptions);
      } on DioError catch (dioError) {
        handler.next(dioError);
      }
    } else {
      retries = 0;
      handler.next(err);
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}
