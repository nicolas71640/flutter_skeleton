part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {}

class TryGoogleLoginEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class TryLoginEvent extends LoginEvent {
  final String mail;
  final String password;

  TryLoginEvent(this.mail, this.password);

  @override
  List<Object> get props => [mail, password];
}
