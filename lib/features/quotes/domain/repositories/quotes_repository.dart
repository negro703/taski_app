import 'package:dartz/dartz.dart' as dartz;
import 'package:taski/core/errors/failures.dart';
import 'package:taski/features/quotes/domain/entities/quote.dart';

abstract class QuotesRepository {
  Future<dartz.Either<Failure, Quote>> getDailyQuote();
}