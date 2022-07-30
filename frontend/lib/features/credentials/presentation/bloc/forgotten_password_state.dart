part of 'forgotten_password_bloc.dart';

abstract class ForgottenPasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgottenPasswordInitial extends ForgottenPasswordState {}

class Loading extends ForgottenPasswordState {}

class Error extends ForgottenPasswordState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}

class Success extends ForgottenPasswordState {}
