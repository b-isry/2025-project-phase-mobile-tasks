// This is a basic Flutter widget test for the Product Manager app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/main.dart';

void main() {
  testWidgets('App smoke test - app loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the app loads with the Products title
    expect(find.text('Products'), findsOneWidget);

    // Verify that the FAB is present
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
