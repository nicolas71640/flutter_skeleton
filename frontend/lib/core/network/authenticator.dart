import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:departments/core/network/credentials_local_data_source.dart';

import 'package:departments/features/credentials/data/datasources/credentials_api_service.dart';

import 'network_utils.dart';

class MyAuthenticator extends Authenticator {
  final CredentialsLocalDataSource credentialsLocalDataSource;
  final CredentialsApiService credentialsApiService;

  MyAuthenticator(this.credentialsLocalDataSource, this.credentialsApiService);

  @override
  FutureOr<Request?> authenticate(Request request, Response response,
      [Request? originalRequest]) async {
    if (response.statusCode == HttpStatus.unauthorized) {

      final refreshToken = await credentialsLocalDataSource.getRefreshToken();
      final response = await credentialsApiService.refreshToken(NetworkUtils.BEARER + refreshToken);
      String? newToken = response.body?.accessToken;

      final Map<String, String> updatedHeaders =
          Map<String, String>.of(request.headers);

      if (newToken != null) {
        credentialsLocalDataSource.cacheAccessToken(newToken);
        newToken = 'Bearer $newToken';
        updatedHeaders.update('Authorization', (String _) => newToken!,
            ifAbsent: () => newToken!);
        return request.copyWith(headers: updatedHeaders);
      }
    }
    return null;
  }
}
