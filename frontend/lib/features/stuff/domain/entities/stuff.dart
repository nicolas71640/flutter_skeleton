import 'package:equatable/equatable.dart';

class Stuff extends Equatable {
  final String title;
  final String description;
  final String imageUrl;
  final int price;

  const Stuff(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.price});

  @override
  List<Object?> get props => [title, description, imageUrl, price];
}
