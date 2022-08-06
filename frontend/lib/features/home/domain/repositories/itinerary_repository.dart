import '../entities/itinerary.dart';

abstract class ItineraryRepository {
  Stream<Itinerary> getItinerary(String form, String to);
}
