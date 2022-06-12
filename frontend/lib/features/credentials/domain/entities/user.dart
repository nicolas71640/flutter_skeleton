import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String mail;

  const User({required this.mail});

  @override
  List<Object?> get props => [mail];
}
