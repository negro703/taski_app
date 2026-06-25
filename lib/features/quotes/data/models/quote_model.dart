import 'package:taski/features/quotes/domain/entities/quote.dart';

class QuoteModel extends Quote {
  const QuoteModel({required super.text, required super.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      text: json['text'] as String? ?? json['content'] as String? ?? '',
      author: json['author'] as String? ?? 'Unknown',
    );
  }
}