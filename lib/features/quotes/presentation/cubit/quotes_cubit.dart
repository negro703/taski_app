import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taski/core/usecases/usecase.dart';
import 'package:taski/features/quotes/domain/usecases/get_daily_quote.dart';
import 'package:taski/features/quotes/presentation/cubit/quotes_state.dart';

class QuotesCubit extends Cubit<QuotesState> {
  final GetDailyQuote getDailyQuote;

  QuotesCubit({required this.getDailyQuote}) : super(const QuotesInitial());

  Future<void> fetchDailyQuote() async {
    emit(const QuotesLoading());
    final result = await getDailyQuote(NoParams());
    result.fold(
      (failure) => emit(QuotesError(message: failure.message)),
      (quote) => emit(QuotesLoaded(quote: quote)),
    );
  }
}