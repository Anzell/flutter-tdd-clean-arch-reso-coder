import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tddflutter/core/error/exceptions.dart';
import 'package:tddflutter/core/error/failures.dart';
import 'package:tddflutter/core/network/network_info.dart';
import 'package:tddflutter/data/datasources/number_trivia_local_datasource.dart';
import 'package:tddflutter/data/datasources/number_trivia_remote_datasource.dart';
import 'package:tddflutter/data/models/number_trivia_model.dart';
import 'package:tddflutter/data/repositories/number_trivia_repository_impl.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([NumberTriviaRemoteDatasource, NumberTriviaLocalDatasource, NetworkInfo])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaLocalDatasource mockLocalDatasource;
  late MockNumberTriviaRemoteDatasource mockRemoteDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDatasource = MockNumberTriviaRemoteDatasource();
    mockLocalDatasource = MockNumberTriviaLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDatasource: mockRemoteDatasource,
      localDatasource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  group("get concrete number trivia", () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: "test trivia", number: tNumber);
    final tNumberTrivia = tNumberTriviaModel;
    test("should check if the device is online", () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);
      repository.getConcreteNumberTrivia(tNumber);
      verify(mockNetworkInfo.isConnected);
    });

    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test("should return remote data when the call to remote datasource is sucessful", () async {
        when(mockRemoteDatasource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should cache the data locally when the call to remote datasource is sucessful", () async {
        when(mockRemoteDatasource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);
        await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test("should return server failure when the call to remote datasource is insucessful", () async {
        when(mockRemoteDatasource.getConcreteNumberTrivia(any)).thenThrow(ServerException());
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test("should return last locally cached data when the cached data is present", () async {
        when(mockLocalDatasource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDatasource);
        verify(mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should return CacheFailure when there is no cached data present", () async {
        when(mockLocalDatasource.getLastNumberTrivia()).thenThrow(CacheException());
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDatasource);
        verify(mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group("get random number trivia", () {
    final tNumberTriviaModel = NumberTriviaModel(text: "test trivia", number: 123);
    final tNumberTrivia = tNumberTriviaModel;
    test("should check if the device is online", () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
      await repository.getRandomNumberTrivia();
      verify(mockNetworkInfo.isConnected);
    });

    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test("should return remote data when the call to remote datasource is sucessful", () async {
        when(mockRemoteDatasource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getRandomNumberTrivia();
        verify(mockRemoteDatasource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should cache the data locally when the call to remote datasource is sucessful", () async {
        when(mockRemoteDatasource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        await repository.getRandomNumberTrivia();
        verify(mockRemoteDatasource.getRandomNumberTrivia());
        verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test("should return server failure when the call to remote datasource is insucessful", () async {
        when(mockRemoteDatasource.getRandomNumberTrivia()).thenThrow(ServerException());
        final result = await repository.getRandomNumberTrivia();
        verify(mockRemoteDatasource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test("should return last locally cached data when the cached data is present", () async {
        when(mockLocalDatasource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getRandomNumberTrivia();
        verifyZeroInteractions(mockRemoteDatasource);
        verify(mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should return CacheFailure when there is no cached data present", () async {
        when(mockLocalDatasource.getLastNumberTrivia()).thenThrow(CacheException());
        final result = await repository.getRandomNumberTrivia();
        verifyZeroInteractions(mockRemoteDatasource);
        verify(mockLocalDatasource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
