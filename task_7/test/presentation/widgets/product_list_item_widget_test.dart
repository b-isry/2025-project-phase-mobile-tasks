import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/domain/entities/product.dart';
import 'package:product_manager/presentation/widgets/product_list_item_widget.dart';

void main() {
  group('ProductListItemWidget', () {
    final testProduct = Product(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      price: 99.99,
    );

    testWidgets('should display product information', (tester) async {
      // Arrange
      var tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductListItemWidget(
              product: testProduct,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('\$99.99'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      // Arrange
      var tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductListItemWidget(
              product: testProduct,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should display delete button when onDelete is provided',
        (tester) async {
      // Arrange
      var deleteCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductListItemWidget(
              product: testProduct,
              onTap: () {},
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);

      // Test delete button
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();
      expect(deleteCalled, isTrue);
    });

    testWidgets('should not display delete button when onDelete is null',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductListItemWidget(
              product: testProduct,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });
  });
}
