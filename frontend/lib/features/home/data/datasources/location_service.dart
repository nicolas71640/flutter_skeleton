import 'package:avecpaulette/features/home/data/models/location_model.dart';
import 'package:avecpaulette/features/home/domain/entities/location_entity.dart';
import 'package:location/location.dart';

class LocationService {
  final Location location;

  LocationService(this.location);

  Stream<LocationEntity> getCurrentLocation() {
    return Stream.fromFuture(location.getLocation())
        .map((locationData) => LocationModel.fromLocationData(locationData));
  }
}
