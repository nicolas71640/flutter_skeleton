part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class Empty extends SignupState{}

class Error extends SignupState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}

class Loading extends SignupState{}

class Logged extends SignupState{}