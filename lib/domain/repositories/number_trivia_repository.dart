import 'package:dartz/dartz.dart';
import 'package:tddflutter/core/error/failures.dart';
import 'package:tddflutter/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
