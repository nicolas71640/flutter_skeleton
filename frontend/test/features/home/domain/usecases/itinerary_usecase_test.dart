import 'package:avecpaulette/features/home/domain/repositories/itinerary_repository.dart';
import 'package:avecpaulette/features/home/domain/usecases/itinerary_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'itinerary_usecase_test.mocks.dart';

//TODO
@GenerateMocks([ItineraryRepository])
void main() {
  late MockItineraryRepository mockItineraryRepository;
  late ItineraryUseCase itineraryUseCase;

  setUp(() {
    mockItineraryRepository = MockItineraryRepository();
    itineraryUseCase = ItineraryUseCase(mockItineraryRepository);
  });

  group('getItinerary', () {
    test(
        'should call getInterary method of Itinerary repository and return its stream',
        () async {});
  });
}
