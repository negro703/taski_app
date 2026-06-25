import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taski/core/common_widgets/custom_button.dart';

void main() {
  testWidgets('CustomPrimaryButton renders label and handles taps', (
    tester,
  ) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomPrimaryButton(
            label: 'Continue',
            onPressed: () => tapCount++,
          ),
        ),
      ),
    );

    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(tapCount, 1);
  });
}
