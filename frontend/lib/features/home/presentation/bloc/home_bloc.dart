// ignore_for_file: constant_identifier_names

import 'package:avecpaulette/features/home/domain/entities/location_entity.dart';
import 'package:avecpaulette/features/home/domain/usecases/cottage_usecase.dart';
import 'package:avecpaulette/features/home/domain/usecases/location_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/cottage.dart';
import '../../domain/usecases/cottage_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

const String COULD_NOT_GET_CURRENT_LOCATION = "Couldn't get current location";
const String COULD_NOT_GET_COTTAGES = "Couldn't get cottages";

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LocationUseCase locationUseCase;
  final CottageUseCase cottageUseCase;

  HomeBloc(this.locationUseCase, this.cottageUseCase) : super(HomeInitial()) {
    on<GetLocation>((event, emit) async {
      await emit.forEach<LocationEntity>(
        locationUseCase(),
        onData: (locationEntity) =>
            LocationReceived(locationEntity: locationEntity),
        onError: (_, __) =>
            const LocationError(message: COULD_NOT_GET_CURRENT_LOCATION),
      );
    });
    on<GetCottages>((event, emit) async {
      await emit.forEach<List<Cottage>>(
        cottageUseCase(),
        onData: (cottages) {
          return CottagesUpdate(cottages: cottages);
        },
        onError: (_, __) =>
            const CottagesUpdateError(message: COULD_NOT_GET_COTTAGES),
      );
    });
  }
}
