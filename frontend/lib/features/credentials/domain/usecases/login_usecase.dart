import 'package:departments/features/credentials/domain/entities/user.dart';
import 'package:departments/features/credentials/domain/repositories/credentials_repository.dart';

class LoginUseCase {
  final CredentialsRepository repository;

  LoginUseCase(this.repository);

  Stream<User> call(String username, String password) {
    return repository.login(username, password);
  }
}
