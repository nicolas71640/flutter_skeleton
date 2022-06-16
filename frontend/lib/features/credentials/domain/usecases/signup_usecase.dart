import 'package:dartz/dartz.dart';
import 'package:departments/features/credentials/domain/entities/user.dart';
import 'package:departments/features/credentials/domain/repositories/credentials_repository.dart';

import '../../../../core/error/failures.dart';

class SignupUseCase {
  final CredentialsRepository repository;

  SignupUseCase(this.repository);

  Stream<User> call(String username, String password)  {
    return repository.signup(username,password);
  }
}
