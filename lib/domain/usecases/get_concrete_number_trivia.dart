import 'package:dartz/dartz.dart';
import 'package:tddflutter/core/error/failures.dart';
import 'package:tddflutter/domain/entities/number_trivia.dart';
import 'package:tddflutter/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia({
    required this.repository,
  });

  Future<Either<Failure, NumberTrivia>> call({required int number}) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
