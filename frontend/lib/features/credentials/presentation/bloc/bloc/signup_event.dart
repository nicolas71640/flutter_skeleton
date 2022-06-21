part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent extends Equatable {}

class TrySignupEvent extends SignupEvent {
  final String mail;
  final String password;

  TrySignupEvent(this.mail, this.password);

  @override
  List<Object?> get props => [mail, password];
}
