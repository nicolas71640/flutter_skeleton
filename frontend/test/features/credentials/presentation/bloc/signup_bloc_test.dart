import 'package:avecpaulette/features/credentials/data/repositories/credentials_repository_impl.dart';
import 'package:avecpaulette/features/credentials/domain/entities/user.dart';
import 'package:avecpaulette/features/credentials/domain/usecases/signup_usecase.dart';
import 'package:avecpaulette/features/credentials/presentation/bloc/signup_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'signup_bloc_test.mocks.dart';

@GenerateMocks([
  SignupUseCase,
])
void main() {
  late SignupBloc bloc;
  late MockSignupUseCase mockSignupUseCase;

  setUp(() {
    mockSignupUseCase = MockSignupUseCase();
    bloc = SignupBloc(mockSignupUseCase);
  });

  group("TrySignupEvent", () {
    test(
        "should call signup usecase to signup and log the user and emit Logged state when return a User",
        () async {
      const username = "username";
      const password = "password";
      when(mockSignupUseCase.call(any, any))
          .thenAnswer((_) => Stream.value(const User(mail: "")));

      expectLater(
          bloc.stream,
          emitsInOrder([
            Loading(),
            Logged(),
          ]));

      bloc.add(TrySignupEvent(username, password));
      await untilCalled(mockSignupUseCase.call(any, any));
      verify(mockSignupUseCase.call(username, password));
    });

    test("should emit [Error] the signup case return an error", () async {
      when(mockSignupUseCase.call(any, any))
          .thenAnswer((_) => Stream.error(EmailAlreadyUsed));

      expectLater(
          bloc.stream,
          emitsInOrder([
            Loading(),
            Error(message: COULD_NOT_SIGNUP_MESSAGE),
          ]));

      bloc.add(TrySignupEvent("username", "password"));
    });
  });
}
