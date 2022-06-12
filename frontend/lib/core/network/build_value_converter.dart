import 'package:built_value/serializer.dart';
import 'package:chopper/chopper.dart';
// ignore: depend_on_referenced_packages
import 'package:built_collection/built_collection.dart';

import 'serializers.dart';

class BuiltValueConverter extends JsonConverter {
  @override
  Request convertRequest(Request request) {
    final serializedObject =
        serializers.serializerForType(request.body.runtimeType);
    if (serializedObject != null) {
      return super.convertRequest(
        request.copyWith(
          body: serializers.serializeWith(
            serializedObject,
            request.body,
          ),
        ),
      );
    } else {
      return request;
    }
  }

  @override
  Response<BodyType> convertResponse<BodyType, SingleItemType>(
    Response response,
  ) {
    final Response dynamicResponse = super.convertResponse(response);
    final BodyType customBody =
        _convertToCustomObject<SingleItemType>(dynamicResponse.body);
    return dynamicResponse.copyWith<BodyType>(body: customBody);
  }

  dynamic _convertToCustomObject<SingleItemType>(dynamic element) {
    if (element is SingleItemType) return element;

    if (element is List) {
      return _deserializeListOf<SingleItemType>(element);
    } else {
      return _deserialize<SingleItemType>(element);
    }
  }

  BuiltList<SingleItemType> _deserializeListOf<SingleItemType>(
    List dynamicList,
  ) {
    return BuiltList<SingleItemType>(
      dynamicList.map((element) => _deserialize<SingleItemType>(element)),
    );
  }

  SingleItemType? _deserialize<SingleItemType>(
    Map<String, dynamic> value,
  ) {
    final serializer = serializers.serializerForType(SingleItemType) as Serializer<SingleItemType>?;
    if (serializer != null) {
      return serializers.deserializeWith(
        serializer,
        value,
      );
    }
    else {
      return null;
    }
  }
}
