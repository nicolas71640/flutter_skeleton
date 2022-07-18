import 'package:bloc/bloc.dart';
import 'package:avecpaulette/features/credentials/domain/usecases/login_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/user.dart';

part 'login_event.dart';
part 'login_state.dart';

// ignore: constant_identifier_names
const String WRONG_ID_MESSAGE = "Wrong Ids";

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<TryLoginEvent>((event, emit) async {
      emit(Loading());
      await emit.forEach<User>(
        loginUseCase.call(event.mail, event.password),
        onData: (users) => Logged(),
        onError: (_, __) => Error(message: WRONG_ID_MESSAGE),
      );
    });
  }
}
