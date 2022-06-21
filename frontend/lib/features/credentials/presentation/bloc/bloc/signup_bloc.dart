import 'package:bloc/bloc.dart';
import 'package:departments/features/credentials/domain/usecases/signup_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/user.dart';

part 'signup_event.dart';
part 'signup_state.dart';

const String COULD_NOT_SIGNUP_MESSAGE = "Couldn't signup";

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase signupUseCase;

  final signupController = PublishSubject<SignupEvent>();

  SignupBloc(this.signupUseCase) : super(SignupInitial()) {
    on<TrySignupEvent>((event, emit) async {
      emit(Loading());
      await emit.forEach<User>(
        signupUseCase.call(event.mail, event.password),
        onData: (users) => Logged(),
        onError: (_, __) => Error(message: COULD_NOT_SIGNUP_MESSAGE),
      );
    });
  }
}
