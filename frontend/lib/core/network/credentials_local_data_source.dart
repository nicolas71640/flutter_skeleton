// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:departments/core/error/exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class CredentialsLocalDataSource {
  Stream<String> getUserId();
  Stream<String> getAccessToken();
  Stream<String> getRefreshToken();
  Stream<void> cacheAccessToken(String accessToken);
  Stream<void> cacheCredentials(
      String userId, String accessToken, String refreshToken);
}

const ACCESS_TOKEN = "ACCESS_TOKEN";
const REFRESH_TOKEN = "REFRESH_TOKEN";
const USER_ID = "USER_ID";

class CredentialsLocalDataSourceImpl implements CredentialsLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;

  CredentialsLocalDataSourceImpl(this.flutterSecureStorage);

  @override
  Stream<String> getUserId() {
    return _getString(USER_ID);
  }

  @override
  Stream<String> getAccessToken() {
    return _getString(ACCESS_TOKEN);
  }

  @override
  Stream<String> getRefreshToken() {
    return _getString(REFRESH_TOKEN);
  }

  @override
  Stream<void> cacheCredentials(
      String userId, String accessToken, String refreshToken) {
    return Stream.fromFuture(flutterSecureStorage
        .write(key: REFRESH_TOKEN, value: refreshToken)
        .then((_) =>
            flutterSecureStorage.write(key: ACCESS_TOKEN, value: accessToken))
        .then((_) => flutterSecureStorage.write(key: USER_ID, value: userId)));
  }

  @override
  Stream<void> cacheAccessToken(String accessToken) {
    return Stream.fromFuture(
        flutterSecureStorage.write(key: ACCESS_TOKEN, value: accessToken));
  }

  Stream<String> _getString(String key) {
    return Stream.fromFuture(flutterSecureStorage.read(key: key)).map((value) {
      if (value != null) {
        return value;
      } else {
        throw CacheException();
      }
    });
  }
}
