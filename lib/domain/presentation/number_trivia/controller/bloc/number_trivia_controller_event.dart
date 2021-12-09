part of 'number_trivia_controller_bloc.dart';

abstract class NumberTriviaControllerEvent extends Equatable {
  const NumberTriviaControllerEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaControllerEvent {
  final String numberString;
  GetTriviaForConcreteNumber({required this.numberString});

  @override
  List<Object> get props => [numberString];
}

class GetTriviaForRandomNumber extends NumberTriviaControllerEvent {}
