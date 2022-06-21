import '../entities/user.dart';

abstract class CredentialsRepository {
  Stream<User> login(String mail, String password);
  Stream<User> signup(String mail, String password);
}
