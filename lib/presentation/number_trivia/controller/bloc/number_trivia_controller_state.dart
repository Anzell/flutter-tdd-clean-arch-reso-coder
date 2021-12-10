part of 'number_trivia_controller_bloc.dart';

abstract class NumberTriviaControllerState extends Equatable {
  const NumberTriviaControllerState();

  @override
  List<Object> get props => [];
}

class Empty extends NumberTriviaControllerState {}

class Loading extends NumberTriviaControllerState {}

class Loaded extends NumberTriviaControllerState {
  final NumberTrivia trivia;

  const Loaded({required this.trivia});

  @override
  List<Object> get props => [trivia];
}

class Error extends NumberTriviaControllerState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
