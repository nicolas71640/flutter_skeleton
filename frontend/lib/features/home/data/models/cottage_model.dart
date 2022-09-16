import 'package:avecpaulette/features/home/domain/entities/cottage.dart';

import 'api/cottage_response.dart';

class CottageModel extends Cottage {
  const CottageModel({
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.price,
    required super.latitude,
    required super.longitude,
  });

  factory CottageModel.fromCottageResponse(CottageResponse cottageResponse) {
    return CottageModel(
      title: cottageResponse.title,
      description: cottageResponse.description,
      imageUrl: cottageResponse.imageUrl,
      price: cottageResponse.price,
      latitude: cottageResponse.latitude,
      longitude: cottageResponse.longitude,
    );
  }
}
