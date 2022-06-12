import 'package:bloc/bloc.dart';
import 'package:departments/features/stuff/domain/repositories/stuff_repository.dart';

part 'stuff_event.dart';
part 'stuff_state.dart';

class StuffBloc extends Bloc<StuffEvent, StuffState> {
  final StuffRepository stuffRepository;

  StuffBloc(this.stuffRepository) : super(StuffInitial()) {
    on<GetStuffEvent>((event, emit) async {
      await stuffRepository.getStuff();
    });
  }
}
