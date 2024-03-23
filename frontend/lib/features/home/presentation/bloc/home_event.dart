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

class PlaceSelected extends HomeEvent {
  final SuggestionEntity suggestion;
  final String lang;

  const PlaceSelected(this.suggestion, this.lang);
}

class ClearSearch extends HomeEvent {}
