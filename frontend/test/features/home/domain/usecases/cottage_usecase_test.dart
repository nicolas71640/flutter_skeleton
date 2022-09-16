import 'package:avecpaulette/features/home/domain/entities/cottage.dart';
import 'package:avecpaulette/features/home/domain/repositories/cottage_repository.dart';
import 'package:avecpaulette/features/home/domain/usecases/cottage_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cottage_usecase_test.mocks.dart';

@GenerateMocks([CottageRepository])
void main() {
  late MockCottageRepository mockCottageRepository;
  late CottageUseCase cottageUseCase;

  setUp(() {
    mockCottageRepository = MockCottageRepository();
    cottageUseCase = CottageUseCase(mockCottageRepository);
  });

  group('getCottages', () {
    test(
        'should call getCottages method of Cottage repository and return its stream',
        () async {
      final List<Cottage> cottages = {
        const Cottage(
            title: "First",
            description: "",
            imageUrl: "",
            price: 1,
            latitude: 0,
            longitude: 0),
        const Cottage(
            title: "Second",
            description: "",
            imageUrl: "",
            price: 1,
            latitude: 0,
            longitude: 0),
      }.toList();
      when(mockCottageRepository.getCottages())
          .thenAnswer((realInvocation) => Stream.value(cottages));

      expect(await cottageUseCase().first, cottages);
    });
  });
}
