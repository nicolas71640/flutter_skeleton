// ignore_for_file: constant_identifier_names

class NetworkUtils {
  static const String BASE_URL =
      String.fromEnvironment('BASE_URL', defaultValue: 'ERROR');
  static const String AUTH_HEADER = "Authorization";
  static const String BEARER = "Bearer ";
}
