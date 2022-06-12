import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:departments/core/network/credentials_local_data_source.dart';

import 'network_utils.dart';

class CustomHeaderInterceptor extends RequestInterceptor {
  final CredentialsLocalDataSource credentialsLocalDataSource;

  CustomHeaderInterceptor(this.credentialsLocalDataSource);

  @override
  FutureOr<Request> onRequest(Request request) async {
    try {
      final accessToken = await credentialsLocalDataSource.getAccessToken();
      Request newRequest = request
          .copyWith(headers: {NetworkUtils.AUTH_HEADER: NetworkUtils.BEARER + accessToken});
      return newRequest;
    } catch (error) {
      return request;
    }
  }
}
