import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tddflutter/domain/entities/number_trivia.dart';
import 'package:tddflutter/domain/repositories/number_trivia_repository.dart';
import 'package:tddflutter/domain/usecases/get_concrete_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: "test");

  test("should get trivia for the number from the repository", () async {
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
    final result = await usecase(number: tNumber);
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber)).called(1);
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
