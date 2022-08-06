import 'package:avecpaulette/features/home/data/datasources/itinerary_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'itinerary_repository_impl_test.mocks.dart';

//TODO
@GenerateMocks([
  ItineraryApiService,
])
void main() {
  late MockItineraryApiService mockItineraryApiService;

  setUp(() {
    mockItineraryApiService = MockItineraryApiService();
  });

  group("getItinerary", () {
    test("should ?????? ", () async {});
  });
}
