// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:avecpaulette/features/credentials/domain/usecases/login_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

part 'login_event.dart';
part 'login_state.dart';

const String WRONG_ID_MESSAGE = "Wrong Ids";
const String GOOGLE_SIGNIN_ERROR = "Couldn't Sign you in with Google";

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<TryLoginEvent>((event, emit) async {
      emit(SignInLoading());
      await emit.forEach<User>(
        loginUseCase.call(event.mail, event.password),
        onData: (users) => Logged(),
        onError: (_, __) => SignInError(message: WRONG_ID_MESSAGE),
      );
    });

    on<TryGoogleLoginEvent>((event, emit) async {
      emit(GoogleSignInLoading());
      await emit.forEach<User>(
        loginUseCase.googleLogin(),
        onData: (users) => Logged(),
        onError: (_, __) => GoogleSignInError(message: GOOGLE_SIGNIN_ERROR),
      );
    });
  }
}
