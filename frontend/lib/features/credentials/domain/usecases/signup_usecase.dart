import 'package:avecpaulette/features/credentials/domain/entities/user.dart';
import 'package:avecpaulette/features/credentials/domain/repositories/credentials_repository.dart';

class SignupUseCase {
  final CredentialsRepository repository;

  SignupUseCase(this.repository);

  Stream<User> call(String username, String password) {
    return repository.signup(username, password);
  }
}
