import 'package:dartz/dartz.dart';
import 'package:flutter_trivia_clean_arch/core/error/failure.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia_clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> execute({required int number}) {
    return repository.getConcreteNumberTrivia(number);
  }
}
