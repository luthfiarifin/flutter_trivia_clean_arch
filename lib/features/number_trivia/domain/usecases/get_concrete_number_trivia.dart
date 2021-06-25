import 'package:dartz/dartz.dart';
import 'package:flutter_trivia_clean_arch/core/error/failure.dart';
import 'package:flutter_trivia_clean_arch/core/usecases/usecases.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) {
    return repository.getConcreteNumberTrivia(params.number);
  }
}

class Params {
  final int number;

  Params({required this.number});
}
