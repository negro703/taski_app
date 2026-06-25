import 'package:equatable/equatable.dart';
import 'package:taski/features/quotes/domain/entities/quote.dart';

abstract class QuotesState extends Equatable {
  const QuotesState();

  @override
  List<Object?> get props => [];
}

class QuotesInitial extends QuotesState {
  const QuotesInitial();
}

class QuotesLoading extends QuotesState {
  const QuotesLoading();
}

class QuotesLoaded extends QuotesState {
  final Quote quote;

  const QuotesLoaded({required this.quote});

  @override
  List<Object?> get props => [quote];
}

class QuotesError extends QuotesState {
  final String message;

  const QuotesError({required this.message});

  @override
  List<Object?> get props => [message];
}