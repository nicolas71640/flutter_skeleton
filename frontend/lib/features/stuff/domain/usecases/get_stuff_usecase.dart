import 'package:departments/features/stuff/domain/entities/stuff.dart';
import '../repositories/stuff_repository.dart';

class GetStuffUseCase {
  final StuffRepository repository;

  GetStuffUseCase(this.repository);

  Stream<List<Stuff>> call() {
    return repository.getStuff();
  }
}
