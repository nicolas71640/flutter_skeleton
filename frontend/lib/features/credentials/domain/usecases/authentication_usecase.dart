import 'package:avecpaulette/features/credentials/domain/entities/user.dart';
import 'package:avecpaulette/features/credentials/domain/repositories/credentials_repository.dart';

class AuthenticationUseCase {
  final CredentialsRepository repository;

  AuthenticationUseCase(this.repository);

  Stream<User> getCurentUser() {
    return repository.getCurrentUser();
  }
}
