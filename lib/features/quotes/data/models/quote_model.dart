import 'package:taski/features/quotes/domain/entities/quote.dart';

class QuoteModel extends Quote {
  const QuoteModel({required super.text, required super.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      text: json['slip']['advice'] as String? ?? '',
      author: 'Productivity Tips',
    );
  }
}