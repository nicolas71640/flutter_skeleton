part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetLocation extends HomeEvent {}

class GetCottages extends HomeEvent {}

class GetSuggestions extends HomeEvent {
  final String country;
  final String input;
  final String lang;

  const GetSuggestions(this.country, this.input, this.lang);
}

class FindPlace extends HomeEvent {
  final String input;
  final String lang;

  const FindPlace(this.input, this.lang);
}

class GetPlaceDetails extends HomeEvent {
  final String placeId;
  final String lang;

  const GetPlaceDetails(this.placeId, this.lang);
}
