import 'package:avecpaulette/features/home/data/datasources/location_service.dart';
import 'package:avecpaulette/features/home/data/repositories/location_repository_impl.dart';
import 'package:avecpaulette/features/home/domain/entities/location_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'location_repository_impl_test.mocks.dart';

@GenerateMocks([
  LocationService,
])
void main() {
  late MockLocationService mockLocationService;
  late LocationRepositoryImpl locationRepository;

  setUp(() {
    mockLocationService = MockLocationService();
    locationRepository = LocationRepositoryImpl(mockLocationService);
  });

  group("getCurrentLocation", () {
    test(
        'should call getCurrentLocation method of Location service and return its stream',
        () async {
      const locationEntity = LocationEntity(1, 2);
      when(mockLocationService.getCurrentLocation())
          .thenAnswer((realInvocation) => Stream.value(locationEntity));

      expect(
          await locationRepository.getCurrentLocation().first, locationEntity);
    });
  });
}
