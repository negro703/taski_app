import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:taski/core/errors/failures.dart';
import 'package:taski/features/quotes/data/datasources/quotes_remote_data_source.dart';
import 'package:taski/features/quotes/domain/entities/quote.dart';
import 'package:taski/features/quotes/domain/repositories/quotes_repository.dart';

class QuotesRepositoryImpl implements QuotesRepository {
  final QuotesRemoteDataSource remoteDataSource;

  QuotesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<dartz.Either<Failure, Quote>> getDailyQuote() async {
    try {
      final quote = await remoteDataSource.getDailyQuote();
      return dartz.Right(quote);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return dartz.Left(ServerFailure(message: 'Connection timeout'));
      }
      return dartz.Left(ServerFailure(message: e.message ?? 'Unknown error'));
    } catch (e) {
      return dartz.Left(ServerFailure(message: e.toString()));
    }
  }
}