import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/stuff.dart';

abstract class StuffRepository {
  Future<Either<Failure, List<Stuff>>> getStuff();
}
