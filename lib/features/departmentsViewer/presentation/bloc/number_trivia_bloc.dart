// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:departments/core/error/failures.dart';
import 'package:departments/core/usecases/usecase.dart';
import 'package:departments/core/util/input_converter.dart';
import 'package:departments/features/departmentsViewer/domain/entities/number_trivia.dart';
import 'package:departments/features/departmentsViewer/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:departments/features/departmentsViewer/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Input Failure - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUseCase getConcreteNumberTriviaUseCase;
  final GetRandomNumberTriviaUseCase getRandomNumberTriviaUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTriviaUseCase,
    required this.getRandomNumberTriviaUseCase,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumberEvent>((event, emit) async {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      await inputEither.fold((failure) async {
        emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      }, (integer) async {
        emit(Loading());
        final failureOrTrivia = await getConcreteNumberTriviaUseCase(integer);
        failureOrTrivia.fold(
            (failure) => emit(Error(message: _mapFailureToMessage(failure))),
            (trivia) => emit(Loaded(numberTrivia: trivia)));
      });
    });

    on<GetTriviaForRandomNumberEvent>((event, emit) async {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTriviaUseCase(NoParams());
        failureOrTrivia.fold(
            (failure) => emit(Error(message: _mapFailureToMessage(failure))),
            (trivia) => emit(Loaded(numberTrivia: trivia)));
      });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
