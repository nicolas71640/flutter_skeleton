import 'package:avecpaulette/features/home/domain/entities/location_entity.dart';
import 'package:location/location.dart';

class LocationModel extends LocationEntity {
  const LocationModel(super.latitude, super.longitude);

  factory LocationModel.fromLocationData(LocationData locationData) {
    return LocationModel(locationData.latitude!, locationData.longitude!);
  }
}
