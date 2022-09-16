import 'package:avecpaulette/features/home/domain/repositories/cottage_repository.dart';
import 'package:avecpaulette/features/home/domain/usecases/cottage_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'cottage_usecase_test.mocks.dart';

//TODO
@GenerateMocks([CottageRepository])
void main() {
  late MockCottageRepository mockCottageRepository;
  late CottageUseCase cottageUseCase;

  setUp(() {
    mockCottageRepository = MockCottageRepository();
    cottageUseCase = CottageUseCase(mockCottageRepository);
  });

  group('getCottage', () {
    test(
        'should call getInterary method of Itinerary repository and return its stream',
        () async {});
  });
}
