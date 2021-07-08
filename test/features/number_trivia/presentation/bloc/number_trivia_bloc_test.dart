import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_clean_arch/core/error/failures.dart';
import 'package:flutter_trivia_clean_arch/core/usecases/usecases.dart';
import 'package:flutter_trivia_clean_arch/core/util/input_converter.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomConcreteNumber: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initial state should be empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('getConcreteNumberTrivia', () {
    final tNumberString = '1';
    final tNumberParsed = int.parse(tNumberString);
    final tNumberTrivia =
        NumberTrivia(text: 'test trivia', number: tNumberParsed);

    void setUpMockInputConverterSuccess() =>
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Right(tNumberParsed));

    void setUpMockGetTriviaSuccess() =>
        when(() => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Right(tNumberTrivia));

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      setUpMockInputConverterSuccess();
      setUpMockGetTriviaSuccess();

      bloc.add(GetTriviaConcreteNumber(tNumberString));
      await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(any()));

      verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when the input is invalid',
      build: () => bloc,
      act: (bloc) {
        // arrange
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));

        bloc.add(GetTriviaConcreteNumber('asd'));
      },
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get date from the random use case',
      build: () => bloc,
      act: (bloc) {
        setUpMockInputConverterSuccess();
        setUpMockGetTriviaSuccess();

        bloc.add(GetTriviaConcreteNumber(tNumberString));
      },
      verify: (bloc) {
        verify(
            () => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () => bloc,
      act: (bloc) {
        setUpMockInputConverterSuccess();
        setUpMockGetTriviaSuccess();

        bloc.add(GetTriviaConcreteNumber(tNumberString));
      },
      expect: () => [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails from server failure',
      build: () => bloc,
      act: (bloc) {
        setUpMockInputConverterSuccess();
        when(() => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(ServerFailure()));

        bloc.add(GetTriviaConcreteNumber(tNumberString));
      },
      expect: () => [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails from cache failure',
      build: () => bloc,
      act: (bloc) {
        setUpMockInputConverterSuccess();
        when(() => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Left(CacheFailure()));

        bloc.add(GetTriviaConcreteNumber(tNumberString));
      },
      expect: () => [
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockGetTriviaSuccess() =>
        when(() => mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get date from the concrete use case',
      build: () => bloc,
      act: (bloc) {
        setUpMockGetTriviaSuccess();

        bloc.add(GetRandomConcreteNumber());
      },
      verify: (bloc) {
        verify(() => mockGetRandomNumberTrivia(NoParams()));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () => bloc,
      act: (bloc) {
        setUpMockGetTriviaSuccess();

        bloc.add(GetRandomConcreteNumber());
      },
      expect: () => [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails from server failure',
      build: () => bloc,
      act: (bloc) {
        when(() => mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));

        bloc.add(GetRandomConcreteNumber());
      },
      expect: () => [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails from cache failure',
      build: () => bloc,
      act: (bloc) {
        when(() => mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));

        bloc.add(GetRandomConcreteNumber());
      },
      expect: () => [
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
