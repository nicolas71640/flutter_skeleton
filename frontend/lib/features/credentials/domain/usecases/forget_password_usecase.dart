import 'package:avecpaulette/features/credentials/domain/repositories/credentials_repository.dart';

class ForgetPasswordUseCase {
  final CredentialsRepository repository;

  ForgetPasswordUseCase(this.repository);

  Stream<void> call(String email) {
    return repository.forgetPassword(email);
  }
}
