import 'package:dio/dio.dart';
import 'package:taski/core/utils/constants/app_constants.dart';
import 'package:taski/features/quotes/data/models/quote_model.dart';

class QuotesRemoteDataSource {
  final Dio dio;

  QuotesRemoteDataSource({required this.dio});

  Future<QuoteModel> getDailyQuote() async {
    final response = await dio.get('${AppConstants.externalApiBaseUrl}${AppConstants.quotesEndpoint}');
    if (response.statusCode == 200 && response.data != null) {
      if (response.data is List && (response.data as List).isNotEmpty) {
        return QuoteModel.fromJson(response.data[0] as Map<String, dynamic>);
      }
      return QuoteModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'Failed to fetch quote',
    );
  }
}