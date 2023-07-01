// ignore_for_file: constant_identifier_names

import 'package:avecpaulette/features/home/domain/entities/location_entity.dart';
import 'package:avecpaulette/features/home/domain/usecases/cottage_usecase.dart';
import 'package:avecpaulette/features/home/domain/usecases/location_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/cottage.dart';
import '../../domain/entities/suggestion_entity.dart';
import '../../domain/usecases/suggestion_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

const String COULD_NOT_GET_CURRENT_LOCATION = "Couldn't get current location";
const String COULD_NOT_GET_COTTAGES = "Couldn't get cottages";
const String COULD_NOT_GET_SUGGESTIONS = "Couldn't get suggestions";

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LocationUseCase locationUseCase;
  final CottageUseCase cottageUseCase;
  final SuggestionUseCase suggestionUseCase;

  HomeBloc(this.locationUseCase, this.cottageUseCase, this.suggestionUseCase)
      : super(HomeInitial()) {
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
        onData: (cottages) => CottagesUpdate(cottages: cottages),
        onError: (_, __) =>
            const CottagesUpdateError(message: COULD_NOT_GET_COTTAGES),
      );
    });

    on<GetSuggestions>((event, emit) async {
      await emit.forEach<List<SuggestionEntity>>(
          suggestionUseCase.getSuggestions(
              event.country, event.input, event.lang),
          onData: (suggestions) => SuggestionsUpdate(suggestions: suggestions),
          onError: (_, __) =>
              const CottagesUpdateError(message: COULD_NOT_GET_SUGGESTIONS));
    });

    on<FindPlace>((event, emit) async {
      await emit.forEach<List<SuggestionEntity>>(
          suggestionUseCase.findPlace(event.input, event.lang),
          onData: (suggestions) => SuggestionsUpdate(suggestions: suggestions),
          onError: (_, __) =>
              const CottagesUpdateError(message: COULD_NOT_GET_SUGGESTIONS));
    });

    on<PlaceSelected>((event, emit) async {
      await emit.forEach<SuggestionEntity>(
          _onPlaceSelected(event),
          onData: (suggestion) => PlaceDetails(suggestion: suggestion),
          onError: (_, __) =>
              const CottagesUpdateError(message: COULD_NOT_GET_SUGGESTIONS));
    });

    on<ClearSearch>((event, emit) => emit(const SuggestionsUpdate(suggestions: [])));
  }


  Stream<SuggestionEntity> _onPlaceSelected(PlaceSelected event)
  {
    if(event.suggestion.latLng == null)
    {
      return suggestionUseCase.getPlaceDetails(event.suggestion.placeId, event.lang);
    }
    return Stream<SuggestionEntity>.value(event.suggestion);
  }
}
