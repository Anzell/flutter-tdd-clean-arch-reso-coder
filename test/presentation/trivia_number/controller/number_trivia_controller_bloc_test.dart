import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tddflutter/core/constants/error_messages.dart';
import 'package:tddflutter/core/util/input_converter.dart';
import 'package:tddflutter/domain/entities/number_trivia.dart';
import 'package:tddflutter/domain/usecases/number_trivia/get_concrete_number_trivia.dart';
import 'package:tddflutter/domain/usecases/number_trivia/get_random_number_trivia.dart';
import 'package:tddflutter/presentation/number_trivia/controller/bloc/number_trivia_controller_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'number_trivia_controller_bloc_test.mocks.dart';

@GenerateMocks([GetRandomNumberTrivia, GetConcreteNumberTrivia, InputConverter])
void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaControllerBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaControllerBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test("initial state should be empty", () {
    expect(bloc.state, equals(Empty()));
  });

  group("get trivia for concrete number", () {
    final tNumberString = "1";
    final tNumberParsed = int.parse(tNumberString);
    final tNumberTrivia = NumberTrivia(number: 1, text: "test trivia");

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberParsed));

    void setUpMockInputConverterFailure() =>
        when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure()));

    test("should call the InputConverter to validate and converter the string to a unsigned integer", () async {
      setUpMockInputConverterSuccess();
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    blocTest(
      "should emit Error when the input is invalid",
      build: () {
        setUpMockInputConverterFailure();
        return bloc;
      },
      act: (NumberTriviaControllerBloc bloc) => bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString)),
      expect: () => [Error(message: ErrorMessages.invalidInputFailureMessage)],
    );
  });
}
