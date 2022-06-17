import 'package:bloc/bloc.dart';
import 'package:departments/features/stuff/domain/usecases/get_stuff_usecase.dart';

import '../../../domain/entities/stuff.dart';

part 'stuff_event.dart';
part 'stuff_state.dart';

class StuffBloc extends Bloc<StuffEvent, StuffState> {
  final GetStuffUseCase useCase;

  StuffBloc(this.useCase) : super(StuffInitial()) {
    on<GetStuffEvent>((event, emit) async {
      await emit.forEach<List<Stuff>>(
        useCase.call(),
        onData: (users) => StuffInitial(),
        onError: (_, __) => StuffInitial(),
      );
    });
  }
}
