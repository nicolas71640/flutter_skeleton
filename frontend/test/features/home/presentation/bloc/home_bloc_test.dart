import 'package:avecpaulette/features/home/domain/entities/location_entity.dart';
import 'package:avecpaulette/features/home/domain/usecases/itinerary_usecase.dart';
import 'package:avecpaulette/features/home/domain/usecases/location_usecase.dart';
import 'package:avecpaulette/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([ItineraryUseCase, LocationUseCase])
void main() {
  late HomeBloc bloc;
  late MockItineraryUseCase mockItineraryUseCase;
  late MockLocationUseCase mockLocationUseCase;

  setUp(() {
    mockItineraryUseCase = MockItineraryUseCase();
    mockLocationUseCase = MockLocationUseCase();
    bloc = HomeBloc(mockLocationUseCase, mockItineraryUseCase);
  });

  group("GetLocationEvent", () {
    test(
        "should call location usecase to get current location and emit a GetLocation state",
        () async {
      const LocationEntity locationEntity = LocationEntity(1, 2);
      when(mockLocationUseCase.call())
          .thenAnswer((_) => Stream.value(locationEntity));

      expectLater(
          bloc.stream,
          emitsInOrder(
              [const LocationReceived(locationEntity: locationEntity)]));

      bloc.add(GetLocation());
      await untilCalled(mockLocationUseCase.call());
      verify(mockLocationUseCase.call());
    });

    test("should emit an error if couldn't get current location", () async {
      when(mockLocationUseCase.call()).thenAnswer((_) => Stream.error("Error"));

      expectLater(
          bloc.stream,
          emitsInOrder(
              [const LocationError(message: COULD_NOT_GET_CURRENT_LOCATION)]));

      bloc.add(GetLocation());
    });
  });
}
