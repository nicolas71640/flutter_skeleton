import 'package:avecpaulette/features/credentials/domain/repositories/credentials_repository.dart';

class ForgottenPasswordUseCase {
  final CredentialsRepository repository;

  ForgottenPasswordUseCase(this.repository);

  Stream<void> call(String username) {
    return repository.forgetPassword(username);
  }
}
