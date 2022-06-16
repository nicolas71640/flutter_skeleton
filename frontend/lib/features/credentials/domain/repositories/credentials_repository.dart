import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class CredentialsRepository {
  Stream<User> login(String mail, String password);
  Stream<User> signup(String mail, String password);

}
