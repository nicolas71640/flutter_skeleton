part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class Authenticated extends AuthenticationState {}
class NotAuthenticated extends AuthenticationState {}
