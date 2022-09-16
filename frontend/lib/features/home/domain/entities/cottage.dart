import 'package:equatable/equatable.dart';

class Cottage extends Equatable {
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final double latitude;
  final double longitude;

  const Cottage(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      required this.latitude,
      required this.longitude});

  @override
  List<Object?> get props =>
      [title, description, imageUrl, price, latitude, longitude];
}
