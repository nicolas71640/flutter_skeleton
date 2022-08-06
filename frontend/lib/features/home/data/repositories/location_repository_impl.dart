import 'package:avecpaulette/core/error/failures.dart';
import 'package:avecpaulette/features/home/data/datasources/location_service.dart';
import 'package:avecpaulette/features/home/domain/entities/location_entity.dart';
import 'package:avecpaulette/features/home/domain/repositories/location_repository.dart';

class WrongIds extends ServerFailure {}

class LocationRepositoryImpl implements LocationRepository {
  final LocationService locationService;

  LocationRepositoryImpl(this.locationService);

  @override
  Stream<LocationEntity> getCurrentLocation() {
    return locationService.getCurrentLocation();
  }
}
