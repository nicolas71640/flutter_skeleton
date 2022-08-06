import 'dart:async';
import 'package:avecpaulette/features/home/data/models/api/itinerary_request.dart';
import 'package:dio/dio.dart';

import 'dart:developer' as developer;

import '../../domain/entities/itinerary.dart';

class ItineraryApiService {
  final Dio dio;

  ItineraryApiService(this.dio);

  Stream<Itinerary> getItinerary(ItineraryRequest itineraryRequest) {
    developer.log("getItinerary");
    return Stream.value(const Itinerary());
  }
}
