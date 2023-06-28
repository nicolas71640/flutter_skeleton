import 'package:avecpaulette/features/home/domain/entities/suggestion_entity.dart';
import '../repositories/suggestion_repository.dart';

class SuggestionUseCase {
  final SuggestionRepository repository;

  SuggestionUseCase(this.repository);

  Stream<List<SuggestionEntity>> getSuggestions(
      String country, String input, String lang) {
    return repository.getSuggestions(country, input, lang);
  }

  Stream<List<SuggestionEntity>> findPlace(String input, String lang) {
    return repository.findPlace(input, lang);
  }

  Stream<SuggestionEntity> getPlaceDetails(String placeId, String lang) {
    return repository.getPlaceDetails(placeId, lang);
  }
}
