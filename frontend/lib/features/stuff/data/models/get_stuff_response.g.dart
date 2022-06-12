// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_stuff_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GetStuffResponse> _$getStuffResponseSerializer =
    new _$GetStuffResponseSerializer();

class _$GetStuffResponseSerializer
    implements StructuredSerializer<GetStuffResponse> {
  @override
  final Iterable<Type> types = const [GetStuffResponse, _$GetStuffResponse];
  @override
  final String wireName = 'GetStuffResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, GetStuffResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'imageUrl',
      serializers.serialize(object.imageUrl,
          specifiedType: const FullType(String)),
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'price',
      serializers.serialize(object.price, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  GetStuffResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GetStuffResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'imageUrl':
          result.imageUrl = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$GetStuffResponse extends GetStuffResponse {
  @override
  final String title;
  @override
  final String description;
  @override
  final String imageUrl;
  @override
  final String userId;
  @override
  final int price;

  factory _$GetStuffResponse(
          [void Function(GetStuffResponseBuilder)? updates]) =>
      (new GetStuffResponseBuilder()..update(updates))._build();

  _$GetStuffResponse._(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.userId,
      required this.price})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'GetStuffResponse', 'title');
    BuiltValueNullFieldError.checkNotNull(
        description, r'GetStuffResponse', 'description');
    BuiltValueNullFieldError.checkNotNull(
        imageUrl, r'GetStuffResponse', 'imageUrl');
    BuiltValueNullFieldError.checkNotNull(
        userId, r'GetStuffResponse', 'userId');
    BuiltValueNullFieldError.checkNotNull(price, r'GetStuffResponse', 'price');
  }

  @override
  GetStuffResponse rebuild(void Function(GetStuffResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetStuffResponseBuilder toBuilder() =>
      new GetStuffResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetStuffResponse &&
        title == other.title &&
        description == other.description &&
        imageUrl == other.imageUrl &&
        userId == other.userId &&
        price == other.price;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, title.hashCode), description.hashCode),
                imageUrl.hashCode),
            userId.hashCode),
        price.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetStuffResponse')
          ..add('title', title)
          ..add('description', description)
          ..add('imageUrl', imageUrl)
          ..add('userId', userId)
          ..add('price', price))
        .toString();
  }
}

class GetStuffResponseBuilder
    implements Builder<GetStuffResponse, GetStuffResponseBuilder> {
  _$GetStuffResponse? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  int? _price;
  int? get price => _$this._price;
  set price(int? price) => _$this._price = price;

  GetStuffResponseBuilder();

  GetStuffResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _description = $v.description;
      _imageUrl = $v.imageUrl;
      _userId = $v.userId;
      _price = $v.price;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetStuffResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GetStuffResponse;
  }

  @override
  void update(void Function(GetStuffResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetStuffResponse build() => _build();

  _$GetStuffResponse _build() {
    final _$result = _$v ??
        new _$GetStuffResponse._(
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'GetStuffResponse', 'title'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'GetStuffResponse', 'description'),
            imageUrl: BuiltValueNullFieldError.checkNotNull(
                imageUrl, r'GetStuffResponse', 'imageUrl'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'GetStuffResponse', 'userId'),
            price: BuiltValueNullFieldError.checkNotNull(
                price, r'GetStuffResponse', 'price'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
