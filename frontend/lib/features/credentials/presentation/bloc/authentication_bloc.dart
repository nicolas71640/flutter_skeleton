// ignore_for_file: constant_identifier_names

import 'package:avecpaulette/features/credentials/domain/usecases/authentication_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationUseCase authenticationUseCase;

  AuthenticationBloc(this.authenticationUseCase)
      : super(AuthenticationInitial()) {
    on<AppLoaded>((event, emit) async {
      await emit.forEach<User>(
        authenticationUseCase.getCurentUser(),
        onData: (users) => Authenticated(),
        onError: (_, __) => NotAuthenticated(),
      );
    });
  }
}
