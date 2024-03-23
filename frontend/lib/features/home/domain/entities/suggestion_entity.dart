import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SuggestionEntity extends Equatable {
  final String placeId;
  final String description;
  final LatLng? latLng;

  const SuggestionEntity(this.placeId, this.description, this.latLng);

  @override
  List<Object?> get props => [placeId, description, latLng];

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}
