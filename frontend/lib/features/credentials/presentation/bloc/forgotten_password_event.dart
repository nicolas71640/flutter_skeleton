part of 'forgotten_password_bloc.dart';

@immutable
abstract class ForgottenPasswordEvent extends Equatable {}

class TrySendForgottenPasswordEmail extends ForgottenPasswordEvent {
  final String mail;

  TrySendForgottenPasswordEmail(this.mail);

  @override
  List<Object> get props => [mail];
}
