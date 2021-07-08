import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_clean_arch/core/util/input_converter.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomConcreteNumber extends Mock
    implements GetRandomConcreteNumber {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomConcreteNumber mockGetRandomConcreteNumber;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomConcreteNumber = MockGetRandomConcreteNumber();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomConcreteNumber: mockGetRandomConcreteNumber,
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

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
            () async {
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Right(tNumberParsed));

          bloc.add(GetTriviaConcreteNumber(tNumberString));
          await untilCalled(
                  () => mockInputConverter.stringToUnsignedInteger(any()));

          verify(() =>
              mockInputConverter.stringToUnsignedInteger(tNumberString));
        });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Error] when the input is invalid',
      build: () => bloc,
      act: (bloc) {
        // arrange
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));

        bloc.add(GetTriviaConcreteNumber('asd'));
      },
      expect: () =>
      <NumberTriviaState>[
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );
  });
}
