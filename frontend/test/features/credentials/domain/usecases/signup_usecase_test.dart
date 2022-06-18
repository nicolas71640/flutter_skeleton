import 'package:departments/features/credentials/domain/entities/user.dart';
import 'package:departments/features/credentials/domain/repositories/credentials_repository.dart';
import 'package:departments/features/credentials/domain/usecases/signup_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_usecase_test.mocks.dart';

@GenerateMocks([CredentialsRepository])
void main() {
  late MockCredentialsRepository mockCredentialsRepository;
  late SignupUseCase signupUseCase;

  setUp(() {
    mockCredentialsRepository = MockCredentialsRepository();
    signupUseCase = SignupUseCase(mockCredentialsRepository);
  });

  group('signup', () {
    test(
        'should call singup method of credential repository and return its stream',
        () async {
      User user = const User(mail: "mail");
      when(mockCredentialsRepository.signup(any, any))
          .thenAnswer((realInvocation) => Stream.value(user));

      expect(await signupUseCase("username", "password").first, user);
    });
  });
}
