import 'package:avecpaulette/features/credentials/domain/usecases/forgotten_password_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
part 'forgotten_password_event.dart';
part 'forgotten_password_state.dart';

// ignore: constant_identifier_names
const String EMAIL_NOT_FOUND_MESSAGE = "Email not found";

class ForgottenPasswordBloc
    extends Bloc<ForgottenPasswordEvent, ForgottenPasswordState> {
  final ForgottenPasswordUseCase forgottenPasswordUseCase;

  ForgottenPasswordBloc(this.forgottenPasswordUseCase)
      : super(ForgottenPasswordInitial()) {
    on<TrySendForgottenPasswordEmail>((event, emit) async {
      emit(Loading());

      await emit.forEach<void>(
        forgottenPasswordUseCase.call(event.mail),
        onData: (users) => Success(),
        onError: (_, __) => Error(message: EMAIL_NOT_FOUND_MESSAGE),
      );
    });
  }
}
