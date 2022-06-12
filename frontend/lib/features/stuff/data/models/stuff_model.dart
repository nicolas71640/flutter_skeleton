import '../../domain/entities/stuff.dart';
import 'api/get_stuff_response.dart';

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
