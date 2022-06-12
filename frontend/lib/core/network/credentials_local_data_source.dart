// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:departments/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';


//TODO use secure storage
abstract class CredentialsLocalDataSource {
  Future<String> getUserId();
  Future<String> getAccessToken();
  Future<String> getRefreshToken();
  Future<void> cacheAccessToken(String accessToken);
  Future<void> cacheCredentials(
      String userId, String accessToken, String refreshToken);
}

// ignore: constant_identifier_names
const ACCESS_TOKEN = "ACCESS_TOKEN";
const REFRESH_TOKEN = "REFRESH_TOKEN";
const USER_ID = "USER_ID";

class CredentialsLocalDataSourceImpl implements CredentialsLocalDataSource {
  final SharedPreferences sharedPreferences;

  CredentialsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<String> getUserId() {
    final userId = sharedPreferences.getString(USER_ID);
    if (userId != null) {
      return Future.value(userId);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<String> getAccessToken() async {
    final accessToken = sharedPreferences.getString(ACCESS_TOKEN);
    if (accessToken != null) {
      return Future.value(accessToken);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<String> getRefreshToken() async {
    final refreshToken = sharedPreferences.getString(REFRESH_TOKEN);
    if (refreshToken != null) {
      return Future.value(refreshToken);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCredentials(
      String userId, String accessToken, String refreshToken) async {
    return sharedPreferences
        .setString(REFRESH_TOKEN, refreshToken)
        .then((_) => sharedPreferences.setString(ACCESS_TOKEN, accessToken))
        .then((_) => sharedPreferences.setString(USER_ID, userId));
  }
  
  @override
  Future<void> cacheAccessToken(String accessToken) {
    return sharedPreferences
        .setString(ACCESS_TOKEN, accessToken);
  }
}
