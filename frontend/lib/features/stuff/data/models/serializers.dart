import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:departments/features/stuff/data/models/get_stuff_response.dart';



part 'serializers.g.dart';

@SerializersFor([
  GetStuffResponse
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
