import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tddflutter/core/constants/error_messages.dart';
import 'package:tddflutter/core/error/failures.dart';
import 'package:tddflutter/core/usecases/usecase.dart';
import 'package:tddflutter/core/util/input_converter.dart';
import 'package:tddflutter/domain/entities/number_trivia.dart';
import 'package:tddflutter/domain/usecases/number_trivia/get_concrete_number_trivia.dart';
import 'package:tddflutter/domain/usecases/number_trivia/get_random_number_trivia.dart';

part 'number_trivia_controller_event.dart';
part 'number_trivia_controller_state.dart';

class NumberTriviaControllerBloc extends Bloc<NumberTriviaControllerEvent, NumberTriviaControllerState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaControllerBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<NumberTriviaControllerEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final response = inputConverter.stringToUnsignedInteger(event.numberString);
        response.fold((failure) => emit(Error(message: _mapFailureToMessage(failure))), (integer) async {
          emit(Loading());
          final concreteNumberTriviaResult = await getConcreteNumberTrivia(Params(number: integer));
          _emitLoadedOrFailureState(concreteNumberTriviaResult);
        });
      }

      if (event is GetTriviaForRandomNumber) {
        emit(Loading());
        final randomNumberTriviaResult = await getRandomNumberTrivia(NoParams());
        _emitLoadedOrFailureState(randomNumberTriviaResult);
      }
    });
  }

  void _emitLoadedOrFailureState(Either<Failure, NumberTrivia> either) {
    either.fold(
      (failure) => emit(Error(message: _mapFailureToMessage(failure))),
      (numberTrivia) => emit(Loaded(trivia: numberTrivia)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case InvalidInputFailure:
        return ErrorMessages.invalidInputFailureMessage;
      case ServerFailure:
        return ErrorMessages.serverFailureMessage;
      case CacheFailure:
        return ErrorMessages.cacheFailureMessage;
      default:
        return ErrorMessages.unkownErrorMessage;
    }
  }
}
