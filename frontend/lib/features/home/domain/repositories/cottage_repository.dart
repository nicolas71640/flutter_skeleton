import '../entities/cottage.dart';

abstract class CottageRepository {
  Stream<List<Cottage>> getCottages();
}
