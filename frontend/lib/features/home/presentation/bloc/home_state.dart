part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class LocationReceived extends HomeState {
  final LocationEntity locationEntity;

  const LocationReceived({required this.locationEntity});

  @override
  List<Object> get props => [locationEntity];
}

class LocationError extends HomeState {
  final String message;

  const LocationError({required this.message});

  @override
  List<Object> get props => [message];
}

class CottagesUpdate extends HomeState {
  final List<Cottage> cottages;

  const CottagesUpdate({required this.cottages});

  @override
  List<Object> get props => [cottages];
}

class CottagesUpdateError extends HomeState {
  final String message;

  const CottagesUpdateError({required this.message});

  @override
  List<Object> get props => [message];
}
