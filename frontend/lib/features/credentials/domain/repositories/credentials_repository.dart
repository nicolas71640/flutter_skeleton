import '../entities/user.dart';

abstract class CredentialsRepository {
  Stream<User> login(String mail, String password);
  Stream<User> googleLogin();
  Stream<User> signup(String mail, String password);
  Stream<void> forgetPassword(String email);
}
