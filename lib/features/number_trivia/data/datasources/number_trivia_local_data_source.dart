import 'dart:convert';

import 'package:flutter_trivia_clean_arch/core/error/exceptions.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const NUMBER_TRIVIA_CACHED_PREFERENCE_KEY =
    'NUMBER_TRIVIA_CACHED_PREFERENCE_KEY';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    var jsonString =
        sharedPreferences.getString(NUMBER_TRIVIA_CACHED_PREFERENCE_KEY);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
      NUMBER_TRIVIA_CACHED_PREFERENCE_KEY,
      json.encode(
        triviaToCache.toJson(),
      ),
    );
  }
}
