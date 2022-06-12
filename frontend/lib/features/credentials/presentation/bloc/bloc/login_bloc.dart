import 'package:bloc/bloc.dart';
import 'package:departments/features/credentials/domain/usecases/login_usecase.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<TryLoginEvent>((event, emit) async {
      final failureOrUser = await loginUseCase.call(event.mail, event.password);
      failureOrUser.fold(
        (failure) => emit(Error(message: "Wrong Ids")),
        (user) {
          emit(Logged());
        },
      );
    });
  }
}
