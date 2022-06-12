// Source code generation in Dart works by creating a new file which contains a "companion class".
// In order for the source gen to know which file to generate and which files are "linked", you need to use the part keyword.
import 'dart:async';

import 'package:dio/dio.dart';

import '../models/api/get_stuff_response.dart';


class StuffApiService {
  final Dio dio;

  StuffApiService(this.dio);

  Future<List<GetStuffResponse>> getStuff() async {
    Response response = await dio.get('/stuff/'
    );

    List<GetStuffResponse> getStuffResponse = response.data.map<GetStuffResponse>((item) =>  GetStuffResponse.fromJson(item)).toList();

    return getStuffResponse;
  }

  
}



// @ChopperApi()
// abstract class StuffApiService extends ChopperService {
//   @Get(path: '/')
//   Future<Response<BuiltList<GetStuffResponse>>> getStuff();

//   static StuffApiService create(
//       CredentialsLocalDataSource credentialsLocalDataSource,
//       CredentialsApiService credentialsApiService) {
//     final client = ChopperClient(
//       // The first part of the URL is now here
//       baseUrl: '${NetworkUtils.BASE_URL}/api/stuff',
//       authenticator: MyAuthenticator(credentialsLocalDataSource,credentialsApiService),
//       interceptors: [
//         CustomHeaderInterceptor(credentialsLocalDataSource),
//         HttpLoggingInterceptor()
//       ],
//       services: [
//         // The generated implementation
//         _$StuffApiService(),
//       ],
//       // Converts data to & from JSON and adds the application/json header.
//       converter: BuiltValueConverter(),
//     );

//     // The generated class with the ChopperClient passed in
//     return _$StuffApiService(client);
//   }
// }
