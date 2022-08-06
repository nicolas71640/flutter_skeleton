import 'package:avecpaulette/features/home/data/datasources/location_service.dart';
import 'package:avecpaulette/features/home/data/models/location_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'location_service_test.mocks.dart';

@GenerateMocks([
  Location
], customMocks: [
  MockSpec<LocationData>(returnNullOnMissingStub: true),
])
void main() {
  late MockLocation mockLocation;
  late LocationService locationService;

  setUp(() {
    mockLocation = MockLocation();
    locationService = LocationService(mockLocation);
  });

  group("getCurrentLocation", () {
    test("should get the current location from the Location plugin ", () async {
      final locationData = MockLocationData();

      when(mockLocation.getLocation())
          .thenAnswer((_) => Future.value(locationData));
      when(locationData.latitude).thenReturn(0.0);
      when(locationData.longitude).thenReturn(0.0);

      final result = locationService.getCurrentLocation();
      verify(mockLocation.getLocation());
      final locationModel = await result.first;
      expect(locationModel, const TypeMatcher<LocationModel>());
      expect((locationModel as LocationModel).latitude,
          equals(locationData.latitude));
    });
  });
}
