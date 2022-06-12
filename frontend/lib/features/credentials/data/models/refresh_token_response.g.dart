// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<RefreshTokenResponse> _$refreshTokenResponseSerializer =
    new _$RefreshTokenResponseSerializer();

class _$RefreshTokenResponseSerializer
    implements StructuredSerializer<RefreshTokenResponse> {
  @override
  final Iterable<Type> types = const [
    RefreshTokenResponse,
    _$RefreshTokenResponse
  ];
  @override
  final String wireName = 'RefreshTokenResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, RefreshTokenResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'accessToken',
      serializers.serialize(object.accessToken,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  RefreshTokenResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RefreshTokenResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'accessToken':
          result.accessToken = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$RefreshTokenResponse extends RefreshTokenResponse {
  @override
  final String accessToken;

  factory _$RefreshTokenResponse(
          [void Function(RefreshTokenResponseBuilder)? updates]) =>
      (new RefreshTokenResponseBuilder()..update(updates))._build();

  _$RefreshTokenResponse._({required this.accessToken}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        accessToken, r'RefreshTokenResponse', 'accessToken');
  }

  @override
  RefreshTokenResponse rebuild(
          void Function(RefreshTokenResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RefreshTokenResponseBuilder toBuilder() =>
      new RefreshTokenResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RefreshTokenResponse && accessToken == other.accessToken;
  }

  @override
  int get hashCode {
    return $jf($jc(0, accessToken.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RefreshTokenResponse')
          ..add('accessToken', accessToken))
        .toString();
  }
}

class RefreshTokenResponseBuilder
    implements Builder<RefreshTokenResponse, RefreshTokenResponseBuilder> {
  _$RefreshTokenResponse? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  RefreshTokenResponseBuilder();

  RefreshTokenResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RefreshTokenResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RefreshTokenResponse;
  }

  @override
  void update(void Function(RefreshTokenResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RefreshTokenResponse build() => _build();

  _$RefreshTokenResponse _build() {
    final _$result = _$v ??
        new _$RefreshTokenResponse._(
            accessToken: BuiltValueNullFieldError.checkNotNull(
                accessToken, r'RefreshTokenResponse', 'accessToken'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
