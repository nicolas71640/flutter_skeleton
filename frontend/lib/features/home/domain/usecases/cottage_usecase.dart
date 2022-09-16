import 'package:avecpaulette/features/home/domain/entities/cottage.dart';
import 'package:avecpaulette/features/home/domain/repositories/cottage_repository.dart';

class CottageUseCase {
  final CottageRepository repository;

  CottageUseCase(this.repository);

  Stream<List<Cottage>> call() {
    return repository.getCottages();
  }
}
