import 'package:avecpaulette/core/error/exceptions.dart';
import 'package:avecpaulette/core/local_data_source/credentials_local_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'credentials_local_data_source_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late CredentialsLocalDataSourceImpl credentialsLocalDataSourceImpl;
  late MockFlutterSecureStorage mockFlutterSecureStorage;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    credentialsLocalDataSourceImpl =
        CredentialsLocalDataSourceImpl(mockFlutterSecureStorage);
  });

  group('getEmail', () {
    test(
        "should forward the call to the FlutterSecureStorage and get the string related to the EMAIL key",
        () async {
      const email = "email@gmail.com";
      when(mockFlutterSecureStorage.read(key: anyNamed("key")))
          .thenAnswer((_) => Future.value(email));

      final result = credentialsLocalDataSourceImpl.getEmail();
      verify(mockFlutterSecureStorage.read(key: "EMAIL"));
      expect(result, emits(email));
    });

    test("should return a CacheException is SecureStorage return null",
        () async {
      when(mockFlutterSecureStorage.read(key: anyNamed("key")))
          .thenAnswer((_) => Future.value(null));

      final result = credentialsLocalDataSourceImpl.getEmail();
      expect(result, emitsError(isA<CacheException>()));
      verify(mockFlutterSecureStorage.read(key: "EMAIL"));
    });
  });

  group('getAccessToken', () {
    test(
        "should forward the call to the FlutterSecureStorage and get the string related to the ACCESS_TOKEN key",
        () async {
      const accessToken = "accessToken";
      when(mockFlutterSecureStorage.read(key: anyNamed("key")))
          .thenAnswer((_) => Future.value(accessToken));

      final result = credentialsLocalDataSourceImpl.getAccessToken();
      verify(mockFlutterSecureStorage.read(key: "ACCESS_TOKEN"));
      expect(result, emits(accessToken));
    });

    test("should return a CacheException is SecureStorage return null",
        () async {
      when(mockFlutterSecureStorage.read(key: anyNamed("key")))
          .thenAnswer((_) => Future.value(null));

      final result = credentialsLocalDataSourceImpl.getAccessToken();
      expect(result, emitsError(isA<CacheException>()));
      verify(mockFlutterSecureStorage.read(key: "ACCESS_TOKEN"));
    });
  });

  group('getRefreshToken', () {
    test(
        "should forward the call to the FlutterSecureStorage and get the string related to the REFRESH_TOKEN key",
        () async {
      const refreshToken = "refreshToken";
      when(mockFlutterSecureStorage.read(key: anyNamed("key")))
          .thenAnswer((_) => Future.value(refreshToken));

      final result = credentialsLocalDataSourceImpl.getRefreshToken();
      verify(mockFlutterSecureStorage.read(key: "REFRESH_TOKEN"));
      expect(result, emits(refreshToken));
    });

    test("should return a CacheException is SecureStorage return null",
        () async {
      when(mockFlutterSecureStorage.read(key: anyNamed("key")))
          .thenAnswer((_) => Future.value(null));

      final result = credentialsLocalDataSourceImpl.getRefreshToken();
      expect(result, emitsError(isA<CacheException>()));
      verify(mockFlutterSecureStorage.read(key: "REFRESH_TOKEN"));
    });
  });

  group('cacheCredentials', () {
    test(
        "should save userId, accessToken and refresh token to flutterSecureStorage",
        () async {
      const userId = "userId";
      const accessToken = "accessToken";
      const refreshToken = "refreshToken";

      when(mockFlutterSecureStorage.write(
              key: anyNamed("key"), value: anyNamed("value")))
          .thenAnswer((_) => Future.value());

      expectLater(
          credentialsLocalDataSourceImpl.cacheCredentials(
            userId,
            accessToken,
            refreshToken,
          ),
          emitsInAnyOrder([null, emitsDone]));

      await untilCalled(
          mockFlutterSecureStorage.write(key: "EMAIL", value: userId));

      verify(mockFlutterSecureStorage.write(
          key: "REFRESH_TOKEN", value: refreshToken));
      verify(mockFlutterSecureStorage.write(
          key: "ACCESS_TOKEN", value: accessToken));
      verify(mockFlutterSecureStorage.write(key: "EMAIL", value: userId));
    });
  });

  group('cacheAccessToken', () {
    test("should save accessToken to flutterSecureStorage", () async {
      const accessToken = "accessToken";

      when(mockFlutterSecureStorage.write(
              key: anyNamed("key"), value: anyNamed("value")))
          .thenAnswer((_) => Future.value());

      expectLater(
          credentialsLocalDataSourceImpl.cacheAccessToken(
            accessToken,
          ),
          emitsInAnyOrder([null, emitsDone]));

      await untilCalled(mockFlutterSecureStorage.write(
          key: "ACCESS_TOKEN", value: accessToken));

      verify(mockFlutterSecureStorage.write(
          key: "ACCESS_TOKEN", value: accessToken));
    });
  });
}
