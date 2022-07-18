import 'package:dartz/dartz.dart';
import 'package:avecpaulette/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });
  group('stringToUnsignedInteger', () {
    test('should return a integer when a string can be converted', () {
      const tNumber = 1;
      final result = inputConverter.stringToUnsignedInteger(tNumber.toString());
      expect(result, const Right(tNumber));
    });

    test(
        'should return an InvalidInputFailure when a string cant be converte to int',
        () {
      final result = inputConverter.stringToUnsignedInteger("A random string");
      expect(result, Left(InvalidInputFailure()));
    });

    test(
        'should return an InvalidInputFailure when a string is converted to a number inferior to 0',
        () {
      const tNumber = -134;
      final result = inputConverter.stringToUnsignedInteger(tNumber.toString());
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
