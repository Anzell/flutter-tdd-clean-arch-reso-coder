part of 'number_trivia_controller_bloc.dart';

abstract class NumberTriviaControllerState extends Equatable {
  const NumberTriviaControllerState();
  
  @override
  List<Object> get props => [];
}

class NumberTriviaControllerInitial extends NumberTriviaControllerState {}
