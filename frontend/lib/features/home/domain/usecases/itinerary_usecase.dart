import 'package:avecpaulette/features/home/domain/entities/itinerary.dart';
import 'package:avecpaulette/features/home/domain/repositories/itinerary_repository.dart';

class ItineraryUseCase {
  final ItineraryRepository repository;

  ItineraryUseCase(this.repository);

  Stream<Itinerary> call(String from, String to) {
    return repository.getItinerary(from, to);
  }
}
