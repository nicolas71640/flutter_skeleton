import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  const LocationEntity(this.latitude, this.longitude);

  @override
  List<Object?> get props => [];
}
