import 'package:avecpaulette/features/home/domain/entities/location_entity.dart';
import 'package:avecpaulette/features/home/domain/usecases/itinerary_usecase.dart';
import 'package:avecpaulette/features/home/domain/usecases/location_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/itinerary_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

// ignore: constant_identifier_names
const String COULD_NOT_GET_CURRENT_LOCATION = "Couldn't get current location";

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LocationUseCase locationUseCase;
  final ItineraryUseCase itineraryUseCase;

  HomeBloc(this.locationUseCase, this.itineraryUseCase) : super(HomeInitial()) {
    on<GetLocation>((event, emit) async {
      locationUseCase();
      await emit.forEach<LocationEntity>(
        locationUseCase(),
        onData: (locationEntity) =>
            LocationReceived(locationEntity: locationEntity),
        onError: (_, __) =>
            const LocationError(message: COULD_NOT_GET_CURRENT_LOCATION),
      );
    });
  }
}
