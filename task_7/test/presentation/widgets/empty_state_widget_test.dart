import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/presentation/widgets/empty_state_widget.dart';

void main() {
  group('EmptyStateWidget', () {
    testWidgets('should display default message', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(),
          ),
        ),
      );

      // Assert
      expect(find.text('No products available'), findsOneWidget);
      expect(find.text('Tap the + button to add your first product'),
          findsOneWidget);
      expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
    });

    testWidgets('should display custom message when provided', (tester) async {
      // Arrange
      const message = 'Custom empty message';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(message: message),
          ),
        ),
      );

      // Assert
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('should display action widget when provided', (tester) async {
      // Arrange
      final actionButton = ElevatedButton(
        onPressed: () {},
        child: const Text('Add Product'),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(action: actionButton),
          ),
        ),
      );

      // Assert
      expect(find.text('Add Product'), findsOneWidget);
    });
  });
}
