// Mocks generated by Mockito 5.3.2 from annotations
// in avecpaulette/test/features/credentials/data/repositories/credentials_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:avecpaulette/core/local_data_source/credentials_local_data_source.dart'
    as _i16;
import 'package:avecpaulette/features/credentials/data/datasources/credentials_api_service.dart'
    as _i5;
import 'package:avecpaulette/features/credentials/data/models/api/forget_password_request.dart'
    as _i15;
import 'package:avecpaulette/features/credentials/data/models/api/forget_password_response.dart'
    as _i14;
import 'package:avecpaulette/features/credentials/data/models/api/login_request.dart'
    as _i10;
import 'package:avecpaulette/features/credentials/data/models/api/login_response.dart'
    as _i9;
import 'package:avecpaulette/features/credentials/data/models/api/oauth_request.dart'
    as _i12;
import 'package:avecpaulette/features/credentials/data/models/api/oauth_response.dart'
    as _i11;
import 'package:avecpaulette/features/credentials/data/models/api/refresh_token_response.dart'
    as _i13;
import 'package:avecpaulette/features/credentials/data/models/api/signup_request.dart'
    as _i8;
import 'package:avecpaulette/features/credentials/data/models/api/signup_response.dart'
    as _i7;
import 'package:dio/dio.dart' as _i2;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i3;
import 'package:google_sign_in/google_sign_in.dart' as _i4;
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart'
    as _i17;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDio_0 extends _i1.SmartFake implements _i2.Dio {
  _FakeDio_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFlutterSecureStorage_1 extends _i1.SmartFake
    implements _i3.FlutterSecureStorage {
  _FakeFlutterSecureStorage_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGoogleSignInAuthentication_2 extends _i1.SmartFake
    implements _i4.GoogleSignInAuthentication {
  _FakeGoogleSignInAuthentication_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CredentialsApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockCredentialsApiService extends _i1.Mock
    implements _i5.CredentialsApiService {
  MockCredentialsApiService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Dio get dio => (super.noSuchMethod(
        Invocation.getter(#dio),
        returnValue: _FakeDio_0(
          this,
          Invocation.getter(#dio),
        ),
      ) as _i2.Dio);
  @override
  _i6.Stream<_i7.SignupResponse> signup(_i8.SignupRequest? signupRequest) =>
      (super.noSuchMethod(
        Invocation.method(
          #signup,
          [signupRequest],
        ),
        returnValue: _i6.Stream<_i7.SignupResponse>.empty(),
      ) as _i6.Stream<_i7.SignupResponse>);
  @override
  _i6.Stream<_i9.LoginResponse> login(_i10.LoginRequest? loginRequest) =>
      (super.noSuchMethod(
        Invocation.method(
          #login,
          [loginRequest],
        ),
        returnValue: _i6.Stream<_i9.LoginResponse>.empty(),
      ) as _i6.Stream<_i9.LoginResponse>);
  @override
  _i6.Stream<_i11.OAuthResponse> oauth(_i12.OAuthRequest? oAuthRequest) =>
      (super.noSuchMethod(
        Invocation.method(
          #oauth,
          [oAuthRequest],
        ),
        returnValue: _i6.Stream<_i11.OAuthResponse>.empty(),
      ) as _i6.Stream<_i11.OAuthResponse>);
  @override
  _i6.Stream<_i13.RefreshTokenResponse> refreshToken(String? refreshToken) =>
      (super.noSuchMethod(
        Invocation.method(
          #refreshToken,
          [refreshToken],
        ),
        returnValue: _i6.Stream<_i13.RefreshTokenResponse>.empty(),
      ) as _i6.Stream<_i13.RefreshTokenResponse>);
  @override
  _i6.Stream<_i14.ForgetPasswordResponse> forgetPassword(
          _i15.ForgetPasswordRequest? forgetPasswordRequest) =>
      (super.noSuchMethod(
        Invocation.method(
          #forgetPassword,
          [forgetPasswordRequest],
        ),
        returnValue: _i6.Stream<_i14.ForgetPasswordResponse>.empty(),
      ) as _i6.Stream<_i14.ForgetPasswordResponse>);
}

/// A class which mocks [CredentialsLocalDataSourceImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockCredentialsLocalDataSourceImpl extends _i1.Mock
    implements _i16.CredentialsLocalDataSourceImpl {
  MockCredentialsLocalDataSourceImpl() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.FlutterSecureStorage get flutterSecureStorage => (super.noSuchMethod(
        Invocation.getter(#flutterSecureStorage),
        returnValue: _FakeFlutterSecureStorage_1(
          this,
          Invocation.getter(#flutterSecureStorage),
        ),
      ) as _i3.FlutterSecureStorage);
  @override
  _i6.Stream<String> getEmail() => (super.noSuchMethod(
        Invocation.method(
          #getEmail,
          [],
        ),
        returnValue: _i6.Stream<String>.empty(),
      ) as _i6.Stream<String>);
  @override
  _i6.Stream<String> getAccessToken() => (super.noSuchMethod(
        Invocation.method(
          #getAccessToken,
          [],
        ),
        returnValue: _i6.Stream<String>.empty(),
      ) as _i6.Stream<String>);
  @override
  _i6.Stream<String> getRefreshToken() => (super.noSuchMethod(
        Invocation.method(
          #getRefreshToken,
          [],
        ),
        returnValue: _i6.Stream<String>.empty(),
      ) as _i6.Stream<String>);
  @override
  _i6.Stream<void> cacheCredentials(
    String? userId,
    String? accessToken,
    String? refreshToken,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #cacheCredentials,
          [
            userId,
            accessToken,
            refreshToken,
          ],
        ),
        returnValue: _i6.Stream<void>.empty(),
      ) as _i6.Stream<void>);
  @override
  _i6.Stream<void> cacheAccessToken(String? accessToken) => (super.noSuchMethod(
        Invocation.method(
          #cacheAccessToken,
          [accessToken],
        ),
        returnValue: _i6.Stream<void>.empty(),
      ) as _i6.Stream<void>);
  @override
  _i6.Stream<void> cleanCredentials() => (super.noSuchMethod(
        Invocation.method(
          #cleanCredentials,
          [],
        ),
        returnValue: _i6.Stream<void>.empty(),
      ) as _i6.Stream<void>);
}

/// A class which mocks [GoogleSignIn].
///
/// See the documentation for Mockito's code generation for more information.
class MockGoogleSignIn extends _i1.Mock implements _i4.GoogleSignIn {
  MockGoogleSignIn() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i17.SignInOption get signInOption => (super.noSuchMethod(
        Invocation.getter(#signInOption),
        returnValue: _i17.SignInOption.standard,
      ) as _i17.SignInOption);
  @override
  List<String> get scopes => (super.noSuchMethod(
        Invocation.getter(#scopes),
        returnValue: <String>[],
      ) as List<String>);
  @override
  bool get forceCodeForRefreshToken => (super.noSuchMethod(
        Invocation.getter(#forceCodeForRefreshToken),
        returnValue: false,
      ) as bool);
  @override
  _i6.Stream<_i4.GoogleSignInAccount?> get onCurrentUserChanged =>
      (super.noSuchMethod(
        Invocation.getter(#onCurrentUserChanged),
        returnValue: _i6.Stream<_i4.GoogleSignInAccount?>.empty(),
      ) as _i6.Stream<_i4.GoogleSignInAccount?>);
  @override
  _i6.Future<_i4.GoogleSignInAccount?> signInSilently({
    bool? suppressErrors = true,
    bool? reAuthenticate = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signInSilently,
          [],
          {
            #suppressErrors: suppressErrors,
            #reAuthenticate: reAuthenticate,
          },
        ),
        returnValue: _i6.Future<_i4.GoogleSignInAccount?>.value(),
      ) as _i6.Future<_i4.GoogleSignInAccount?>);
  @override
  _i6.Future<bool> isSignedIn() => (super.noSuchMethod(
        Invocation.method(
          #isSignedIn,
          [],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<_i4.GoogleSignInAccount?> signIn() => (super.noSuchMethod(
        Invocation.method(
          #signIn,
          [],
        ),
        returnValue: _i6.Future<_i4.GoogleSignInAccount?>.value(),
      ) as _i6.Future<_i4.GoogleSignInAccount?>);
  @override
  _i6.Future<_i4.GoogleSignInAccount?> signOut() => (super.noSuchMethod(
        Invocation.method(
          #signOut,
          [],
        ),
        returnValue: _i6.Future<_i4.GoogleSignInAccount?>.value(),
      ) as _i6.Future<_i4.GoogleSignInAccount?>);
  @override
  _i6.Future<_i4.GoogleSignInAccount?> disconnect() => (super.noSuchMethod(
        Invocation.method(
          #disconnect,
          [],
        ),
        returnValue: _i6.Future<_i4.GoogleSignInAccount?>.value(),
      ) as _i6.Future<_i4.GoogleSignInAccount?>);
  @override
  _i6.Future<bool> requestScopes(List<String>? scopes) => (super.noSuchMethod(
        Invocation.method(
          #requestScopes,
          [scopes],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
}

/// A class which mocks [GoogleSignInAccount].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockGoogleSignInAccount extends _i1.Mock
    implements _i4.GoogleSignInAccount {
  MockGoogleSignInAccount() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get email => (super.noSuchMethod(
        Invocation.getter(#email),
        returnValue: '',
      ) as String);
  @override
  String get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: '',
      ) as String);
  @override
  _i6.Future<_i4.GoogleSignInAuthentication> get authentication =>
      (super.noSuchMethod(
        Invocation.getter(#authentication),
        returnValue: _i6.Future<_i4.GoogleSignInAuthentication>.value(
            _FakeGoogleSignInAuthentication_2(
          this,
          Invocation.getter(#authentication),
        )),
      ) as _i6.Future<_i4.GoogleSignInAuthentication>);
  @override
  _i6.Future<Map<String, String>> get authHeaders => (super.noSuchMethod(
        Invocation.getter(#authHeaders),
        returnValue: _i6.Future<Map<String, String>>.value(<String, String>{}),
      ) as _i6.Future<Map<String, String>>);
  @override
  _i6.Future<void> clearAuthCache() => (super.noSuchMethod(
        Invocation.method(
          #clearAuthCache,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

/// A class which mocks [GoogleSignInAuthentication].
///
/// See the documentation for Mockito's code generation for more information.
class MockGoogleSignInAuthentication extends _i1.Mock
    implements _i4.GoogleSignInAuthentication {
  MockGoogleSignInAuthentication() {
    _i1.throwOnMissingStub(this);
  }
}
