// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SignupRequest> _$signupRequestSerializer =
    new _$SignupRequestSerializer();

class _$SignupRequestSerializer implements StructuredSerializer<SignupRequest> {
  @override
  final Iterable<Type> types = const [SignupRequest, _$SignupRequest];
  @override
  final String wireName = 'SignupRequest';

  @override
  Iterable<Object?> serialize(Serializers serializers, SignupRequest object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'password',
      serializers.serialize(object.password,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  SignupRequest deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SignupRequestBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'password':
          result.password = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SignupRequest extends SignupRequest {
  @override
  final String email;
  @override
  final String password;

  factory _$SignupRequest([void Function(SignupRequestBuilder)? updates]) =>
      (new SignupRequestBuilder()..update(updates))._build();

  _$SignupRequest._({required this.email, required this.password}) : super._() {
    BuiltValueNullFieldError.checkNotNull(email, r'SignupRequest', 'email');
    BuiltValueNullFieldError.checkNotNull(
        password, r'SignupRequest', 'password');
  }

  @override
  SignupRequest rebuild(void Function(SignupRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignupRequestBuilder toBuilder() => new SignupRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignupRequest &&
        email == other.email &&
        password == other.password;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, email.hashCode), password.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SignupRequest')
          ..add('email', email)
          ..add('password', password))
        .toString();
  }
}

class SignupRequestBuilder
    implements Builder<SignupRequest, SignupRequestBuilder> {
  _$SignupRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  SignupRequestBuilder();

  SignupRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignupRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SignupRequest;
  }

  @override
  void update(void Function(SignupRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignupRequest build() => _build();

  _$SignupRequest _build() {
    final _$result = _$v ??
        new _$SignupRequest._(
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'SignupRequest', 'email'),
            password: BuiltValueNullFieldError.checkNotNull(
                password, r'SignupRequest', 'password'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
