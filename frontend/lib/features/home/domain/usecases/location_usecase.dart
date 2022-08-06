import 'package:avecpaulette/features/home/domain/entities/location_entity.dart';
import 'package:avecpaulette/features/home/domain/repositories/location_repository.dart';

class LocationUseCase {
  final LocationRepository repository;

  LocationUseCase(this.repository);

  Stream<LocationEntity> call() {
    return repository.getCurrentLocation();
  }
}
