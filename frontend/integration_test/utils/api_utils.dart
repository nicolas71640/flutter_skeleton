import 'package:avecpaulette/core/network/network_utils.dart';
import 'package:dio/dio.dart';

class ApiUtils {
  final Dio dio = Dio(BaseOptions(baseUrl: NetworkUtils.BASE_URL));

  Stream<void> deleteUser(String email) {
    return Stream.fromFuture(dio.post(
      '/auth/devDelete',
      data: {"email": email},
    ));
  }
}
