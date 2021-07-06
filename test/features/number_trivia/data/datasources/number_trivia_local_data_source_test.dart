import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_clean_arch/core/error/exceptions.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl localDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test('should return cached number trivia when there is cached value',
        () async {
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await localDataSource.getLastNumberTrivia();

      verify(() =>
          mockSharedPreferences.getString(NUMBER_TRIVIA_CACHED_PREFERENCE_KEY));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is no cached value', () {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      final call = localDataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);

    test('should call SharedPreference to cache the data', () async {
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      localDataSource.cacheNumberTrivia(tNumberTriviaModel);

      verify(() => mockSharedPreferences.setString(
            NUMBER_TRIVIA_CACHED_PREFERENCE_KEY,
            json.encode(
              tNumberTriviaModel.toJson(),
            ),
          ));
    });
  });
}
