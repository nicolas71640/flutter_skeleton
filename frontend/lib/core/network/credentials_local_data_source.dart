// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:departments/core/error/exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class CredentialsLocalDataSource {
  Future<String> getUserId();
  Future<String> getAccessToken();
  Future<String> getRefreshToken();
  Future<void> cacheAccessToken(String accessToken);
  Future<void> cacheCredentials(
      String userId, String accessToken, String refreshToken);
}

const ACCESS_TOKEN = "ACCESS_TOKEN";
const REFRESH_TOKEN = "REFRESH_TOKEN";
const USER_ID = "USER_ID";

class CredentialsLocalDataSourceImpl implements CredentialsLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;

  CredentialsLocalDataSourceImpl(this.flutterSecureStorage);

  @override
  Future<String> getUserId() async {
    final userId = await flutterSecureStorage.read(key: USER_ID);
    if (userId != null) {
      return Future.value(userId);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<String> getAccessToken() async {
    final accessToken = await flutterSecureStorage.read(key: ACCESS_TOKEN);
    if (accessToken != null) {
      return Future.value(accessToken);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<String> getRefreshToken() async {
    final refreshToken = await flutterSecureStorage.read(key: REFRESH_TOKEN);
    if (refreshToken != null) {
      return Future.value(refreshToken);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCredentials(
      String userId, String accessToken, String refreshToken) async {
    return flutterSecureStorage
        .write(key: REFRESH_TOKEN, value: refreshToken)
        .then((_) =>
            flutterSecureStorage.write(key: ACCESS_TOKEN, value: accessToken))
        .then((_) => flutterSecureStorage.write(key: USER_ID, value: userId));
  }

  @override
  Future<void> cacheAccessToken(String accessToken) {
    return flutterSecureStorage.write(key: ACCESS_TOKEN, value: accessToken);
  }
}
