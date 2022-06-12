import 'package:departments/features/stuff/data/models/get_stuff_response.dart';

import '../../domain/entities/stuff.dart';

class StuffModel extends Stuff {
  const StuffModel({
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.price,
  });

  factory StuffModel.fromGetStuffResponse(GetStuffResponse getStuffResponse) {
    return StuffModel(
      title: getStuffResponse.title,
      description: getStuffResponse.description,
      imageUrl: getStuffResponse.imageUrl,
      price: getStuffResponse.price,
    );
  }
}
