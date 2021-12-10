import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tddflutter/core/constants/error_messages.dart';
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
    on<NumberTriviaControllerEvent>((event, emit) {
      if (event is GetTriviaForConcreteNumber) {
        final response = inputConverter.stringToUnsignedInteger(event.numberString);
        emit(response.fold((failure) => Error(message: ErrorMessages.invalidInputFailureMessage),
            (integer) => throw UnimplementedError()));
      }
    });
  }
}
