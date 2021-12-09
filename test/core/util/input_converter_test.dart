import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tddflutter/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("string to unsigned int", () {
    test("should return an integer when the string represents an unsigned integer", () async {
      const String strExample = "123";
      final result = inputConverter.stringToUnsignedInteger(strExample);
      expect(result, const Right(123));
    });

    test("should return a InvalidInputFailure when the string not represents a valid integer", () async {
      const String strExample = "bad_integer";
      final result = inputConverter.stringToUnsignedInteger(strExample);
      expect(result, equals(Left(InvalidInputFailure())));
    });

    test("should return a InvalidInputFailure when the number is a negative number", () async {
      const String strExample = "-10";
      final result = inputConverter.stringToUnsignedInteger(strExample);
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
