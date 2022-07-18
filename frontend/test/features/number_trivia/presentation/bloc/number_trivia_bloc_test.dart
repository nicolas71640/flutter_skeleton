import 'package:dartz/dartz.dart';
import 'package:avecpaulette/core/error/failures.dart';
import 'package:avecpaulette/core/util/input_converter.dart';
import 'package:avecpaulette/features/departmentsViewer/domain/entities/number_trivia.dart';
import 'package:avecpaulette/features/departmentsViewer/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:avecpaulette/features/departmentsViewer/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:avecpaulette/features/departmentsViewer/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetRandomNumberTriviaUseCase,
  GetConcreteNumberTriviaUseCase,
  InputConverter
])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTriviaUseCase getConcreteNumberTriviaUseCase;
  late MockGetRandomNumberTriviaUseCase getRandomNumberTriviaUseCase;
  late MockInputConverter inputConverter;

  setUp(() {
    getConcreteNumberTriviaUseCase = MockGetConcreteNumberTriviaUseCase();
    getRandomNumberTriviaUseCase = MockGetRandomNumberTriviaUseCase();
    inputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTriviaUseCase: getConcreteNumberTriviaUseCase,
      getRandomNumberTriviaUseCase: getRandomNumberTriviaUseCase,
      inputConverter: inputConverter,
    );
  });

  group("GetTriviaForConcreteNumberEvent", () {
    const tNumberString = "1";
    const tNumberParsed = 1;
    const tNumberTrivia =
        NumberTrivia(text: tNumberString, number: tNumberParsed);

    test(
        "should call the InputConverter to validate and convert the string to an unsigned integer",
        () async {
      when(getConcreteNumberTriviaUseCase.call(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(inputConverter.stringToUnsignedInteger(any));
      verify(inputConverter.stringToUnsignedInteger(tNumberString));
    });

    test("should emit [Error] when the input is invalid", () async {
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      expectLater(
          bloc.stream,
          emitsInOrder([
            const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
          ]));

      bloc.add(const GetTriviaForConcreteNumberEvent("abc"));
    });

    test("should get data from usecase", () async {
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
      when(getConcreteNumberTriviaUseCase.call(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(getConcreteNumberTriviaUseCase.call(any));

      verify(getConcreteNumberTriviaUseCase(tNumberParsed));
    });

    test(
        "should emit [Loading, Loaded] state when a number trivia is return from the usecase",
        () async {
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
      when(getConcreteNumberTriviaUseCase.call(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      expectLater(
          bloc.stream,
          emitsInOrder([
            Loading(),
            const Loaded(numberTrivia: tNumberTrivia),
          ]));

      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test("should emit [Loading, Error] when there is a ServerFailure",
        () async {
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
      when(getConcreteNumberTriviaUseCase.call(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      expectLater(
          bloc.stream,
          emitsInOrder([
            Loading(),
            const Error(message: SERVER_FAILURE_MESSAGE),
          ]));

      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test("should emit [Loading, Error] when there is a CacheFailure", () async {
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
      when(getConcreteNumberTriviaUseCase.call(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      expectLater(
          bloc.stream,
          emitsInOrder([
            Loading(),
            const Error(message: CACHE_FAILURE_MESSAGE),
          ]));

      bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });
  });

  group("GetRandomTriviaNumberEvent", () {
    const tNumberTrivia = NumberTrivia(text: "Test text", number: 123);

    test("should get data from usecase", () async {
      when(getRandomNumberTriviaUseCase(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      bloc.add(GetTriviaForRandomNumberEvent());
      await untilCalled(getRandomNumberTriviaUseCase(any));

      verify(getRandomNumberTriviaUseCase(any));
    });

    test(
        "should emit [Loading, Loaded] state when a number trivia is return from the usecase",
        () async {
      when(getRandomNumberTriviaUseCase(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      expectLater(
          bloc.stream,
          emitsInOrder([
            Loading(),
            const Loaded(numberTrivia: tNumberTrivia),
          ]));

      bloc.add(GetTriviaForRandomNumberEvent());
    });

    test("should emit [Loading, Error] when there is a ServerFailure",
        () async {
      when(getRandomNumberTriviaUseCase.call(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      expectLater(
          bloc.stream,
          emitsInOrder([
            Loading(),
            const Error(message: SERVER_FAILURE_MESSAGE),
          ]));

      bloc.add(GetTriviaForRandomNumberEvent());
    });

    test("should emit [Loading, Error] when there is a CacheFailure", () async {
      when(getRandomNumberTriviaUseCase.call(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      expectLater(
          bloc.stream,
          emitsInOrder([
            Loading(),
            const Error(message: CACHE_FAILURE_MESSAGE),
          ]));

      bloc.add(GetTriviaForRandomNumberEvent());
    });
  });
}
