import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tddflutter/core/constants/number_trivia_local.dart';
import 'package:tddflutter/core/error/exceptions.dart';
import 'package:tddflutter/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDatasourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences storage;

  NumberTriviaLocalDatasourceImpl({required this.storage});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    final result =
        await storage.setString(LocalNumberTriviaNames.cachedNumberTrivia, json.encode(triviaToCache.toJson()));
    if (!result) {
      throw CacheException();
    }
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = storage.getString(LocalNumberTriviaNames.cachedNumberTrivia);
    if (jsonString == null) {
      throw CacheException();
    }
    return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
  }
}
