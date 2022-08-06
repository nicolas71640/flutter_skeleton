import 'package:avecpaulette/features/home/domain/entities/itinerary.dart';

import 'api/itinerary_response.dart';

class ItineraryModel extends Itinerary {
  const ItineraryModel();

  factory ItineraryModel.fromItineraryResponse(
      ItineraryResponse itineraryResponse) {
    return const ItineraryModel();
  }
}
