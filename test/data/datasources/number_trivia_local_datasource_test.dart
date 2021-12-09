import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tddflutter/core/constants/number_trivia_local.dart';
import 'package:tddflutter/core/error/exceptions.dart';
import 'package:tddflutter/data/datasources/number_trivia_local_datasource.dart';
import 'package:tddflutter/data/models/number_trivia_model.dart';

import '../../fixtures/fixture_reader.dart';
import 'number_trivia_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDatasourceImpl localDatasourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDatasourceImpl = NumberTriviaLocalDatasourceImpl(storage: mockSharedPreferences);
  });

  group("get last cached number trivia", () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia_cached.json")));

    test("should return NumberTrivia from SharedPreferences when there is one in the cache", () async {
      when(mockSharedPreferences.getString(any)).thenReturn(fixture("trivia_cached.json"));
      final result = await localDatasourceImpl.getLastNumberTrivia();
      verify(mockSharedPreferences.getString(LocalNumberTriviaNames.cachedNumberTrivia));
      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw CacheException when there is not a cachedValue", () {
      when(mockSharedPreferences.getString(LocalNumberTriviaNames.cachedNumberTrivia)).thenThrow(CacheException());
      final result = localDatasourceImpl.getLastNumberTrivia;
      expect(() => result(), throwsA(isA<CacheException>()));
    });
  });

  group("cache number trivia", () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test trivia");

    test("should call SharedPreferences to cache the data", () {
      when(mockSharedPreferences.setString(LocalNumberTriviaNames.cachedNumberTrivia, any))
          .thenAnswer((_) async => true);
      localDatasourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(LocalNumberTriviaNames.cachedNumberTrivia, expectedJsonString));
    });

    test("should throw a CacheException when the return of setString method is false", () {
      when(mockSharedPreferences.setString(LocalNumberTriviaNames.cachedNumberTrivia, any))
          .thenAnswer((_) async => false);
      final result = localDatasourceImpl.cacheNumberTrivia;
      expect(() => result(tNumberTriviaModel), throwsA(isA<CacheException>()));
    });
  });
}
