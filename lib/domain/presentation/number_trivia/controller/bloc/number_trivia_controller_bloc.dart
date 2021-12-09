import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_controller_event.dart';
part 'number_trivia_controller_state.dart';

class NumberTriviaControllerBloc extends Bloc<NumberTriviaControllerEvent, NumberTriviaControllerState> {
  NumberTriviaControllerBloc() : super(NumberTriviaControllerInitial()) {
    on<NumberTriviaControllerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
