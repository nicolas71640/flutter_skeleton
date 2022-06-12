import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'get_stuff_response.g.dart';

abstract class GetStuffResponse implements Built<GetStuffResponse, GetStuffResponseBuilder> {
  String get title;
  String get description;
  String get imageUrl;
  String get userId;
  int get price;

  GetStuffResponse._();

  factory GetStuffResponse([Function(GetStuffResponseBuilder b) updates]) = _$GetStuffResponse;

  static Serializer<GetStuffResponse> get serializer => _$getStuffResponseSerializer;
}