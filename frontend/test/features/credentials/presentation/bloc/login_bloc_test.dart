import 'package:departments/features/credentials/data/repositories/credentials_repository_impl.dart';
import 'package:departments/features/credentials/domain/entities/user.dart';
import 'package:departments/features/credentials/domain/usecases/login_usecase.dart';
import 'package:departments/features/credentials/presentation/bloc/bloc/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_bloc_test.mocks.dart';

@GenerateMocks([
  LoginUseCase,
])
void main() {
  late LoginBloc bloc;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    bloc = LoginBloc(mockLoginUseCase);
  });

  group("TryLoginEvent", () {
    test(
        "should call login usecase to log the user and emit Logged state when return a User",
        () async {
      const username = "username";
      const password = "password";
      when(mockLoginUseCase.call(any, any))
          .thenAnswer((_) => Stream.value(const User(mail: "")));

      expectLater(
          bloc.stream,
          emitsInOrder([
            Loading(),
            Logged(),
          ]));

      bloc.add(TryLoginEvent(username, password));
      await untilCalled(mockLoginUseCase.call(any, any));
      verify(mockLoginUseCase.call(username, password));
    });

    test("should emit [Error] the login case return an error", () async {
      when(mockLoginUseCase.call(any, any))
          .thenAnswer((_) => Stream.error(WrongIds));

      expectLater(
          bloc.stream,
          emitsInOrder([
            Loading(),
            Error(message: WRONG_ID_MESSAGE),
          ]));

      bloc.add(TryLoginEvent("username", "password"));
    });
  });
}
