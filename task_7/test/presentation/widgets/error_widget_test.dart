import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/presentation/widgets/error_widget.dart' as error_widget;

void main() {
  group('ProductErrorWidget', () {
    testWidgets('should display error message', (tester) async {
      // Arrange
      const message = 'An error occurred';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: error_widget.ProductErrorWidget(message: message),
          ),
        ),
      );

      // Assert
      expect(find.text('Error'), findsOneWidget);
      expect(find.text(message), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display retry button when onRetry is provided',
        (tester) async {
      // Arrange
      const message = 'An error occurred';
      var retryCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: error_widget.ProductErrorWidget(
              message: message,
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Test retry button
      await tester.tap(find.text('Retry'));
      await tester.pump();
      expect(retryCalled, isTrue);
    });

    testWidgets('should not display retry button when onRetry is null',
        (tester) async {
      // Arrange
      const message = 'An error occurred';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: error_widget.ProductErrorWidget(message: message),
          ),
        ),
      );

      // Assert
      expect(find.text('Retry'), findsNothing);
    });
  });
}
