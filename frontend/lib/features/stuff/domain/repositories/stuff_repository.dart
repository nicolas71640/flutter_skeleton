import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/stuff.dart';

abstract class StuffRepository {
  Stream<List<Stuff>> getStuff();
}
