part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class TrySignupEvent extends SignupEvent {
  final String mail;
  final String password;

  TrySignupEvent(this.mail, this.password);
}

