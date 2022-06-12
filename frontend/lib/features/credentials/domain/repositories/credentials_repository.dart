import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class CredentialsRepository {
  Future<Either<Failure, User>> login(String mail, String password);
  Future<Either<Failure, User>> signup(String mail, String password);

}
