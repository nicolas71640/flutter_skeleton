part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class Empty extends LoginState {}

class SignInLoading extends LoginState {}

class GoogleSignInLoading extends LoginState {}

class SignInError extends LoginState {
  final String message;

  SignInError({required this.message});

  @override
  List<Object> get props => [message];
}

class GoogleSignInError extends LoginState {
  final String message;

  GoogleSignInError({required this.message});

  @override
  List<Object> get props => [message];
}

class Logged extends LoginState {}
