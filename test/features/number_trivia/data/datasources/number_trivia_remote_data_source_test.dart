import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_clean_arch/core/error/exceptions.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSource =
        NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
  });

  void setUpMockClientSuccess200(Uri url) {
    when(() => mockHttpClient.get(url, headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockClientFailure404(Uri url) {
    when(() => mockHttpClient.get(url, headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Text', number: tNumber);

    final tUrl = Uri.parse('http://numbersapi.com/$tNumber');

    test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () {
      setUpMockClientSuccess200(tUrl);

      remoteDataSource.getConcreteNumberTrivia(tNumber);

      verify(() => mockHttpClient.get(
            tUrl,
            headers: {'Content-Type': 'application/json'},
          ));
    });

    test('should return NumberTriviaModel when the response code is 200',
        () async {
      setUpMockClientSuccess200(tUrl);

      final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test('should return ServerException when the response code is 404',
        () async {
      setUpMockClientFailure404(tUrl);

      final call = remoteDataSource.getConcreteNumberTrivia;

      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(text: 'Test Text', number: 1);

    final tUrl = Uri.parse('http://numbersapi.com/random');

    test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () {
      setUpMockClientSuccess200(tUrl);

      remoteDataSource.getRandomNumberTrivia();

      verify(() => mockHttpClient.get(
            tUrl,
            headers: {'Content-Type': 'application/json'},
          ));
    });

    test('should return NumberTriviaModel when the response code is 200',
        () async {
      setUpMockClientSuccess200(tUrl);

      final result = await remoteDataSource.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test('should return ServerException when the response code is 404',
        () async {
      setUpMockClientFailure404(tUrl);

      final call = remoteDataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
