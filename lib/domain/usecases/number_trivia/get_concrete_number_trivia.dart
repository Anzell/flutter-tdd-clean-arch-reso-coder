import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:tddflutter/core/error/failures.dart';
import 'package:tddflutter/core/usecases/usecase.dart';
import 'package:tddflutter/domain/entities/number_trivia.dart';
import 'package:tddflutter/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia({
    required this.repository,
  });

  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({required this.number});

  @override
  List<Object> get props => [number];
}
