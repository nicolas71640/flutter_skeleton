import '../entities/suggestion_entity.dart';

abstract class SuggestionRepository {
  Stream<List<SuggestionEntity>> getSuggestions(
      String country, String input, String lang);
  Stream<List<SuggestionEntity>> findPlace(String input, String lang);
  Stream<SuggestionEntity> getPlaceDetails(String placeId, String lang);
}
