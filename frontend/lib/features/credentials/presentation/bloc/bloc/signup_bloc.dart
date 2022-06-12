import 'package:bloc/bloc.dart';
import 'package:departments/features/credentials/domain/usecases/signup_usecase.dart';
import 'package:departments/features/credentials/presentation/bloc/bloc/login_bloc.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase signupUseCase;

  SignupBloc(this.signupUseCase) : super(SignupInitial()) {
    on<TrySignupEvent>((event, emit) async {
      emit(Loading());
      final failureOrUser =
          await signupUseCase.call(event.mail, event.password);
      failureOrUser.fold(
        (failure) => emit(Error(message: "Couldn't signup")),
        (user) {
          print("emitt logged");
          emit(Logged());
        },
      );
    });
  }
}
