import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_clean_arch/core/platform/network_info.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
        numberTriviaRemoteDataSource: mockNumberTriviaRemoteDataSource,
        numberTriviaLocalDataSource: mockNumberTriviaLocalDataSource,
        networkInfo: mockNetworkInfo);
  });
}
