part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class Empty extends LoginState {}

class Error extends LoginState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}

class Logged extends LoginState {}
