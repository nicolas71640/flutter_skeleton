// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:avecpaulette/core/error/exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class CredentialsLocalDataSource {
  Stream<String> getEmail();
  Stream<String> getAccessToken();
  Stream<String> getRefreshToken();
  Stream<void> cacheAccessToken(String accessToken);
  Stream<void> cacheCredentials(
      String email, String accessToken, String refreshToken);
  Stream<void> cleanCredentials();
}

const ACCESS_TOKEN = "ACCESS_TOKEN";
const REFRESH_TOKEN = "REFRESH_TOKEN";
const EMAIL = "EMAIL";

class CredentialsLocalDataSourceImpl implements CredentialsLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;

  CredentialsLocalDataSourceImpl(this.flutterSecureStorage);

  @override
  Stream<String> getEmail() {
    return _getString(EMAIL);
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
        .then((_) => flutterSecureStorage.write(key: EMAIL, value: userId)));
  }

  @override
  Stream<void> cacheAccessToken(String accessToken) {
    return Stream.fromFuture(
        flutterSecureStorage.write(key: ACCESS_TOKEN, value: accessToken));
  }

  @override
  Stream<void> cleanCredentials() {
    return Stream.fromFuture(flutterSecureStorage
        .delete(key: EMAIL)
        .then((_) => flutterSecureStorage.delete(key: ACCESS_TOKEN))
        .then((_) => flutterSecureStorage.delete(key: REFRESH_TOKEN)));
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
