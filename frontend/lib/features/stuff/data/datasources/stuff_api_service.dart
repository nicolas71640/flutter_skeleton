// Source code generation in Dart works by creating a new file which contains a "companion class".
// In order for the source gen to know which file to generate and which files are "linked", you need to use the part keyword.
import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:departments/core/network/credentials_local_data_source.dart';
import 'package:departments/core/network/build_value_converter.dart';
import 'package:departments/core/network/authenticator.dart';
import 'package:departments/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:departments/features/stuff/data/models/get_stuff_response.dart';

import '../../../../core/network/header_interceptor.dart';
import 'package:built_collection/built_collection.dart';

import '../../../../core/network/network_utils.dart';

part 'stuff_api_service.chopper.dart';

@ChopperApi()
abstract class StuffApiService extends ChopperService {
  @Get(path: '/')
  Future<Response<BuiltList<GetStuffResponse>>> getStuff();

  static StuffApiService create(
      CredentialsLocalDataSource credentialsLocalDataSource,
      CredentialsApiService credentialsApiService) {
    final client = ChopperClient(
      // The first part of the URL is now here
      baseUrl: '${NetworkUtils.BASE_URL}/api/stuff',
      authenticator: MyAuthenticator(credentialsLocalDataSource,credentialsApiService),
      interceptors: [
        CustomHeaderInterceptor(credentialsLocalDataSource),
        HttpLoggingInterceptor()
      ],
      services: [
        // The generated implementation
        _$StuffApiService(),
      ],
      // Converts data to & from JSON and adds the application/json header.
      converter: BuiltValueConverter(),
    );

    // The generated class with the ChopperClient passed in
    return _$StuffApiService(client);
  }
}
