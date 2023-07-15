import 'package:avecpaulette/core/error/failures.dart';
import 'package:avecpaulette/features/home/data/datasources/suggestion_service.dart';
import 'package:avecpaulette/features/home/data/models/api/get_place_details_request.dart';
import 'package:avecpaulette/features/home/domain/entities/suggestion_entity.dart';
import '../../domain/repositories/suggestion_repository.dart';
import '../models/api/find_place_request.dart';
import '../models/api/suggestion_request.dart';

class WrongIds extends ServerFailure {}

class SuggestionRepositoryImpl implements SuggestionRepository {
  final SuggestionService suggestionService;

  SuggestionRepositoryImpl(this.suggestionService);

  @override
  Stream<List<SuggestionEntity>> getSuggestions(
      String country, String input, String lang) {
    return suggestionService.getSuggestions(SuggestionRequest(country, input, lang));
  }

  @override
  Stream<List<SuggestionEntity>> findPlace(String input, String lang) {
    return suggestionService.findPlace(FindPlaceRequest(input, lang));
  }

  @override
  Stream<SuggestionEntity> getPlaceDetails(String placeId, String lang) {
    return suggestionService.getPlaceDetails(GetPlaceDetailsRequest(placeId, lang));
  }
}
