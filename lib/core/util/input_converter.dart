import 'package:dartz/dartz.dart';
import 'package:tddflutter/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String string) {
    final convertedInteger = int.tryParse(string);
    if (convertedInteger == null) {
      return Left(InvalidInputFailure());
    }
    if (convertedInteger < 0) {
      return Left(InvalidInputFailure());
    }
    return Right(convertedInteger);
  }
}

class InvalidInputFailure extends Failure {}
