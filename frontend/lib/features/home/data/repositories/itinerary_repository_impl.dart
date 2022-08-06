import 'package:avecpaulette/core/error/failures.dart';
import 'package:avecpaulette/features/home/data/datasources/itinerary_api_service.dart';
import 'package:avecpaulette/features/home/data/models/api/itinerary_request.dart';
import 'package:avecpaulette/features/home/domain/entities/itinerary.dart';
import 'package:avecpaulette/features/home/domain/repositories/itinerary_repository.dart';

class WrongIds extends ServerFailure {}

class ItineraryRepositoryImpl implements ItineraryRepository {
  final ItineraryApiService itineraryApiService;

  ItineraryRepositoryImpl(this.itineraryApiService);

  @override
  Stream<Itinerary> getItinerary(String from, String to) {
    return itineraryApiService.getItinerary(ItineraryRequest(from, to));
  }
}
