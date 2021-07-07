part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTriviaConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  GetTriviaConcreteNumber(this.numberString);

  @override
  List<Object?> get props => [numberString];
}

class GetRandomConcreteNumber extends NumberTriviaEvent {}
