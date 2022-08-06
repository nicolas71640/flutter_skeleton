import '../entities/location_entity.dart';

abstract class LocationRepository {
  Stream<LocationEntity> getCurrentLocation();
}
