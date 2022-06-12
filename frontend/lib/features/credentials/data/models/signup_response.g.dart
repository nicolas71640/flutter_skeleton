// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SignupResponse> _$signupResponseSerializer =
    new _$SignupResponseSerializer();

class _$SignupResponseSerializer
    implements StructuredSerializer<SignupResponse> {
  @override
  final Iterable<Type> types = const [SignupResponse, _$SignupResponse];
  @override
  final String wireName = 'SignupResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, SignupResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  SignupResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SignupResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SignupResponse extends SignupResponse {
  @override
  final String message;

  factory _$SignupResponse([void Function(SignupResponseBuilder)? updates]) =>
      (new SignupResponseBuilder()..update(updates))._build();

  _$SignupResponse._({required this.message}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        message, r'SignupResponse', 'message');
  }

  @override
  SignupResponse rebuild(void Function(SignupResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignupResponseBuilder toBuilder() =>
      new SignupResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignupResponse && message == other.message;
  }

  @override
  int get hashCode {
    return $jf($jc(0, message.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SignupResponse')
          ..add('message', message))
        .toString();
  }
}

class SignupResponseBuilder
    implements Builder<SignupResponse, SignupResponseBuilder> {
  _$SignupResponse? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  SignupResponseBuilder();

  SignupResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignupResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SignupResponse;
  }

  @override
  void update(void Function(SignupResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignupResponse build() => _build();

  _$SignupResponse _build() {
    final _$result = _$v ??
        new _$SignupResponse._(
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'SignupResponse', 'message'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
