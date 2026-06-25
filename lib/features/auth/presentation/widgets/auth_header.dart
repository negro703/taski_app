import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Taskify', style: textTheme.titleMedium),
        const SizedBox(height: 28),
        Text(title, style: textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(subtitle, style: textTheme.bodyLarge),
      ],
    );
  }
}
