import 'package:departments/features/credentials/domain/entities/user.dart';
import 'package:departments/features/credentials/domain/repositories/credentials_repository.dart';
import 'package:departments/features/credentials/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_usecase_test.mocks.dart';

@GenerateMocks([CredentialsRepository])
void main() {
  late MockCredentialsRepository mockCredentialsRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockCredentialsRepository = MockCredentialsRepository();
    loginUseCase = LoginUseCase(mockCredentialsRepository);
  });

  group('login', () {
    test(
        'should call login method of credential repository and return its stream',
        () async {
      User user = const User(mail: "mail");
      when(mockCredentialsRepository.login(any, any))
          .thenAnswer((realInvocation) => Stream.value(user));

      expect(await loginUseCase("username", "password").first, user);
    });
  });
}
