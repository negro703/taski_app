import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taski/core/errors/failures.dart';
import 'package:taski/core/usecases/usecase.dart';
import 'package:taski/features/quotes/domain/entities/quote.dart';
import 'package:taski/features/quotes/domain/usecases/get_daily_quote.dart';
import 'package:taski/features/quotes/presentation/cubit/quotes_cubit.dart';
import 'package:taski/features/quotes/presentation/cubit/quotes_state.dart';

class MockGetDailyQuote extends Mock implements GetDailyQuote {}

void main() {
  late MockGetDailyQuote mockGetDailyQuote;
  late QuotesCubit quotesCubit;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetDailyQuote = MockGetDailyQuote();
    quotesCubit = QuotesCubit(getDailyQuote: mockGetDailyQuote);
  });

  tearDown(() {
    quotesCubit.close();
  });

  group('QuotesCubit', () {
    const testQuote = Quote(text: 'Test quote', author: 'Test author');

    test(
        'should emit [QuotesLoading, QuotesLoaded] when data is fetched successfully',
        () async {
      // Arrange
      when(() => mockGetDailyQuote(any()))
          .thenAnswer((_) async => dartz.Right(testQuote));

      // Assert initial state
      expect(quotesCubit.state, const QuotesInitial());

      // Act
      final future = quotesCubit.fetchDailyQuote();

      // Assert intermediate loading state
      expect(quotesCubit.state, const QuotesLoading());

      await future;

      // Assert final loaded state
      expect(quotesCubit.state, QuotesLoaded(quote: testQuote));
    });

    test(
        'should emit [QuotesLoading, QuotesError] when the network or parsing fails',
        () async {
      // Arrange
      const failureMessage = 'Network error';
      when(() => mockGetDailyQuote(any())).thenAnswer(
          (_) async => dartz.Left(ServerFailure(message: failureMessage)));

      // Assert initial state
      expect(quotesCubit.state, const QuotesInitial());

      // Act
      final future = quotesCubit.fetchDailyQuote();

      // Assert intermediate loading state
      expect(quotesCubit.state, const QuotesLoading());

      await future;

      // Assert final error state
      expect(quotesCubit.state, const QuotesError(message: failureMessage));
    });
  });
}