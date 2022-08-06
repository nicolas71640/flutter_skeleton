import 'package:avecpaulette/features/credentials/data/repositories/credentials_repository_impl.dart';
import 'package:avecpaulette/features/credentials/domain/usecases/forgotten_password_usecase.dart';
import 'package:avecpaulette/features/credentials/presentation/bloc/forgotten_password_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forgotten_password_bloc_test.mocks.dart';

@GenerateMocks([
  ForgottenPasswordUseCase,
])
void main() {
  late ForgottenPasswordBloc bloc;
  late MockForgottenPasswordUseCase forgottenPasswordUseCase;

  setUp(() {
    forgottenPasswordUseCase = MockForgottenPasswordUseCase();
    bloc = ForgottenPasswordBloc(forgottenPasswordUseCase);
  });

  group("TrySendForgottenPasswordEmail", () {
    test(
        "should call login usecase to log the user and emit Logged state when return a User",
        () async {
      const mail = "test@mail.com";
      when(forgottenPasswordUseCase.call(any))
          .thenAnswer((_) => Stream.value(null));

      expectLater(
          bloc.stream,
          emitsInOrder([
            Loading(),
            Success(),
          ]));

      bloc.add(TrySendForgottenPasswordEmail(mail));
      await untilCalled(forgottenPasswordUseCase.call(any));
      verify(forgottenPasswordUseCase.call(mail));
    });

    test("should emit [Error] when the forgotten use case return an error",
        () async {
      when(forgottenPasswordUseCase.call(any))
          .thenAnswer((_) => Stream.error(EmailNotFound));

      expectLater(
          bloc.stream,
          emitsInOrder([
            Loading(),
            Error(message: EMAIL_NOT_FOUND_MESSAGE),
          ]));

      bloc.add(TrySendForgottenPasswordEmail("test@mail.com"));
    });
  });
}
