import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tddflutter/core/error/exceptions.dart';
import 'package:tddflutter/data/datasources/number_trivia_remote_datasource.dart';
import 'package:tddflutter/data/models/number_trivia_model.dart';

import '../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDatasourceImpl remoteDatasource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    remoteDatasource = NumberTriviaRemoteDatasourceImpl(client: mockHttpClient);
  });

  group("get concrete number trivia", () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

    test("should preform a GET request on a URL with number being the endpoint and with application/json header", () {
      when(mockHttpClient.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));
      remoteDatasource.getConcreteNumberTrivia(tNumber);
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {"Content-Type": "application/json"},
      ));
    });

    test("should return NumberTrivia when the response code is 200 (sucess)", () async {
      when(mockHttpClient.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));
      final result = await remoteDatasource.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw a ServerException when the response code is 404 or other", () {
      when(mockHttpClient.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response("Something went wrong", 404));
      final call = remoteDatasource.getConcreteNumberTrivia;
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group("get random number trivia", () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

    test("should preform a GET request on a URL with number being the endpoint and with application/json header", () {
      when(mockHttpClient.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));
      remoteDatasource.getRandomNumberTrivia();
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/random'),
        headers: {"Content-Type": "application/json"},
      ));
    });

    test("should return NumberTrivia when the response code is 200 (sucess)", () async {
      when(mockHttpClient.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));
      final result = await remoteDatasource.getRandomNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw a ServerException when the response code is 404 or other", () {
      when(mockHttpClient.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response("Something went wrong", 404));
      final call = remoteDatasource.getRandomNumberTrivia;
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
