import '../entities/stuff.dart';

abstract class StuffRepository {
  Stream<List<Stuff>> getStuff();
}
