import 'package:avecpaulette/features/credentials/domain/repositories/credentials_repository.dart';
import 'package:avecpaulette/features/credentials/domain/usecases/forget_password_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forget_password_usecase_test.mocks.dart';

@GenerateMocks([CredentialsRepository])
void main() {
  late MockCredentialsRepository mockCredentialsRepository;
  late ForgetPasswordUseCase forgetPasswordUseCase;

  setUp(() {
    mockCredentialsRepository = MockCredentialsRepository();
    forgetPasswordUseCase = ForgetPasswordUseCase(mockCredentialsRepository);
  });

  group('forgetPassword', () {
    test(
        'should call forgetPassword method of credential repository and return its stream',
        () async {
      when(mockCredentialsRepository.forgetPassword(any))
          .thenAnswer((realInvocation) => Stream.value(null));

      expectLater(
          forgetPasswordUseCase("username"), emitsInOrder([null, emitsDone]));
    });
  });
}
