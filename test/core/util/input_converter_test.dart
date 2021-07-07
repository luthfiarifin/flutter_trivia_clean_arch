import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_clean_arch/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInteger', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () {
      final str = '123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Right(int.parse(str)));
    });

    test('should throw InvalidInputFailure when the string is not an integer',
        () {
      final str = 'abc';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('should throw InvalidInputFailure when the string is negative integer',
        () {
      final str = '-123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
