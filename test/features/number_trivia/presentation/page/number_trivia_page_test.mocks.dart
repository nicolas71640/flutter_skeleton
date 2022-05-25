// Mocks generated by Mockito 5.2.0 from annotations
// in departments/test/features/number_trivia/presentation/page/number_trivia_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:bloc/bloc.dart' as _i7;
import 'package:departments/core/util/input_converter.dart' as _i4;
import 'package:departments/features/departmentsViewer/domain/usecases/get_concrete_number_trivia_usecase.dart'
    as _i2;
import 'package:departments/features/departmentsViewer/domain/usecases/get_random_number_trivia_usecase.dart'
    as _i3;
import 'package:departments/features/departmentsViewer/presentation/bloc/number_trivia_bloc.dart'
    as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeGetConcreteNumberTriviaUseCase_0 extends _i1.Fake
    implements _i2.GetConcreteNumberTriviaUseCase {}

class _FakeGetRandomNumberTriviaUseCase_1 extends _i1.Fake
    implements _i3.GetRandomNumberTriviaUseCase {}

class _FakeInputConverter_2 extends _i1.Fake implements _i4.InputConverter {}

class _FakeNumberTriviaState_3 extends _i1.Fake
    implements _i5.NumberTriviaState {}

/// A class which mocks [NumberTriviaBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockNumberTriviaBloc extends _i1.Mock implements _i5.NumberTriviaBloc {
  MockNumberTriviaBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetConcreteNumberTriviaUseCase get getConcreteNumberTriviaUseCase =>
      (super.noSuchMethod(Invocation.getter(#getConcreteNumberTriviaUseCase),
              returnValue: _FakeGetConcreteNumberTriviaUseCase_0())
          as _i2.GetConcreteNumberTriviaUseCase);
  @override
  _i3.GetRandomNumberTriviaUseCase get getRandomNumberTriviaUseCase =>
      (super.noSuchMethod(Invocation.getter(#getRandomNumberTriviaUseCase),
              returnValue: _FakeGetRandomNumberTriviaUseCase_1())
          as _i3.GetRandomNumberTriviaUseCase);
  @override
  _i4.InputConverter get inputConverter =>
      (super.noSuchMethod(Invocation.getter(#inputConverter),
          returnValue: _FakeInputConverter_2()) as _i4.InputConverter);
  @override
  _i5.NumberTriviaState get state =>
      (super.noSuchMethod(Invocation.getter(#state),
          returnValue: _FakeNumberTriviaState_3()) as _i5.NumberTriviaState);
  @override
  _i6.Stream<_i5.NumberTriviaState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i5.NumberTriviaState>.empty())
          as _i6.Stream<_i5.NumberTriviaState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i5.NumberTriviaEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i5.NumberTriviaEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  void emit(_i5.NumberTriviaState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i5.NumberTriviaEvent>(
          _i7.EventHandler<E, _i5.NumberTriviaState>? handler,
          {_i7.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i7.Transition<_i5.NumberTriviaEvent, _i5.NumberTriviaState>?
              transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i6.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  void onChange(_i7.Change<_i5.NumberTriviaState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}
