import 'package:avecpaulette/core/local_data_source/credentials_local_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DbUtils {
  final CredentialsLocalDataSource credentialsLocalDataSource = CredentialsLocalDataSourceImpl(const FlutterSecureStorage());

  Stream<void> cleanDb()
  {
    return credentialsLocalDataSource.cleanCredentials();
  }

}
