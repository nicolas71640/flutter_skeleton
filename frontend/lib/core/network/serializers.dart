import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:departments/features/credentials/data/models/refresh_token_response.dart';
import 'package:departments/features/credentials/data/models/login_response.dart';
import 'package:departments/features/credentials/data/models/signup_request.dart';
import 'package:departments/features/credentials/data/models/signup_response.dart';
import 'package:departments/features/stuff/data/models/get_stuff_response.dart';

import '../../features/credentials/data/models/login_request.dart';

part 'serializers.g.dart';

@SerializersFor([
  LoginRequest,
  LoginResponse,
  SignupRequest,
  SignupResponse,
  GetStuffResponse,
  RefreshTokenResponse,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
