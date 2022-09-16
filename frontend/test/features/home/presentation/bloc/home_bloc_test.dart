import 'package:avecpaulette/features/home/domain/entities/cottage.dart';
import 'package:avecpaulette/features/home/domain/entities/location_entity.dart';
import 'package:avecpaulette/features/home/domain/usecases/cottage_usecase.dart';
import 'package:avecpaulette/features/home/domain/usecases/location_usecase.dart';
import 'package:avecpaulette/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([CottageUseCase, LocationUseCase])
void main() {
  late HomeBloc bloc;
  late MockCottageUseCase mockcottageUseCase;
  late MockLocationUseCase mockLocationUseCase;

  setUp(() {
    mockcottageUseCase = MockCottageUseCase();
    mockLocationUseCase = MockLocationUseCase();
    bloc = HomeBloc(mockLocationUseCase, mockcottageUseCase);
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

    group("GetCottages", () {
    test(
        "should call cottage usecase to get cottages and emit a CottagesUpdate state",
        () async {
            final List<Cottage> cottages = {
        const Cottage(
            title: "First",
            description: "",
            imageUrl: "",
            price: 1,
            latitude: 0,
            longitude: 0),
        const Cottage(
            title: "Second",
            description: "",
            imageUrl: "",
            price: 1,
            latitude: 0,
            longitude: 0),
      }.toList();
      when(mockcottageUseCase.call())
          .thenAnswer((_) => Stream.value(cottages));

      expectLater(
          bloc.stream,
          emitsInOrder(
              [CottagesUpdate(cottages: cottages)]));

      bloc.add(GetCottages());
      await untilCalled(mockcottageUseCase.call());
      verify(mockcottageUseCase.call());
    });

    test("should emit an error if couldn't get cottages", () async {
      when(mockcottageUseCase.call()).thenAnswer((_) => Stream.error("Error"));

      expectLater(
          bloc.stream,
          emitsInOrder(
              [const CottagesUpdateError(message: COULD_NOT_GET_COTTAGES)]));

      bloc.add(GetCottages());
    });
  });
}
