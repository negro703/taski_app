import 'package:dartz/dartz.dart' as dartz;
import 'package:taski/core/errors/failures.dart';
import 'package:taski/core/usecases/usecase.dart';
import 'package:taski/features/quotes/domain/entities/quote.dart';
import 'package:taski/features/quotes/domain/repositories/quotes_repository.dart';

class GetDailyQuote extends UseCase<Quote, NoParams> {
  final QuotesRepository repository;

  GetDailyQuote({required this.repository});

  @override
  Future<dartz.Either<Failure, Quote>> call(NoParams params) {
    return repository.getDailyQuote();
  }
}