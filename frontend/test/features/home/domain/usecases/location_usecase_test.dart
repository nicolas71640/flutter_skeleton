import 'package:avecpaulette/features/home/domain/entities/location_entity.dart';
import 'package:avecpaulette/features/home/domain/repositories/location_repository.dart';
import 'package:avecpaulette/features/home/domain/usecases/location_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'location_usecase_test.mocks.dart';

@GenerateMocks([LocationRepository])
void main() {
  late MockLocationRepository mockLocationRepository;
  late LocationUseCase locationUseCase;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    locationUseCase = LocationUseCase(mockLocationRepository);
  });

  group('getCurrentLocation', () {
    test(
        'should call getCurrentLocation method of Location repository and return its stream',
        () async {
      const locationEntity = LocationEntity(1, 2);
      when(mockLocationRepository.getCurrentLocation())
          .thenAnswer((realInvocation) => Stream.value(locationEntity));

      expect(await locationUseCase().first, locationEntity);
    });
  });
}
