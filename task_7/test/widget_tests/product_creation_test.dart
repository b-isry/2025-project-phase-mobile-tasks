import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/screens/home_screen.dart';
import 'package:product_manager/screens/product_edit_screen.dart';
import '../helpers/test_wrapper.dart';

void main() {
  group('Product Creation Tests', () {
    testWidgets('a. Can render the Add Product screen', (WidgetTester tester) async {
      // Build HomeScreen wrapped with provider
      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the FAB
      final fabFinder = find.byKey(const Key('add_product_fab'));
      expect(fabFinder, findsOneWidget);

      await tester.tap(fabFinder);
      await tester.pumpAndSettle();

      // Verify navigation to Add/Edit screen
      expect(find.byType(ProductEditScreen), findsOneWidget);
      expect(find.text('Add Product'), findsWidgets);
    });

    testWidgets('b. Create a product with valid input', (WidgetTester tester) async {
      // Start with empty products
      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap FAB to navigate to add screen
      await tester.tap(find.byKey(const Key('add_product_fab')));
      await tester.pumpAndSettle();

      // Enter valid title
      final titleField = find.byKey(const Key('title_field'));
      expect(titleField, findsOneWidget);
      await tester.enterText(titleField, 'Test Product');
      await tester.pumpAndSettle();

      // Enter valid description
      final descriptionField = find.byKey(const Key('description_field'));
      expect(descriptionField, findsOneWidget);
      await tester.enterText(descriptionField, 'This is a test product description');
      await tester.pumpAndSettle();

      // Tap Save button
      final saveButton = find.byKey(const Key('save_product_button'));
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Should navigate back to home screen
      expect(find.byType(HomeScreen), findsOneWidget);

      // Verify product appears in the list
      expect(find.text('Test Product'), findsOneWidget);
    });

    testWidgets('c. Creating a product with empty name fails', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to add screen
      await tester.tap(find.byKey(const Key('add_product_fab')));
      await tester.pumpAndSettle();

      // Leave title empty, enter description
      final descriptionField = find.byKey(const Key('description_field'));
      await tester.enterText(descriptionField, 'This is a test description');
      await tester.pumpAndSettle();

      // Tap Save button
      final saveButton = find.byKey(const Key('save_product_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Should show validation error
      expect(find.text('Title is required'), findsOneWidget);

      // Should still be on edit screen (no navigation)
      expect(find.byType(ProductEditScreen), findsOneWidget);

      // Should not add product (verify we're not on home screen with product)
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('d. Creating a product with short title fails', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to add screen
      await tester.tap(find.byKey(const Key('add_product_fab')));
      await tester.pumpAndSettle();

      // Enter too short title
      final titleField = find.byKey(const Key('title_field'));
      await tester.enterText(titleField, 'AB');
      await tester.pumpAndSettle();

      // Enter valid description
      final descriptionField = find.byKey(const Key('description_field'));
      await tester.enterText(descriptionField, 'This is a test description');
      await tester.pumpAndSettle();

      // Tap Save button
      final saveButton = find.byKey(const Key('save_product_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Should show validation error
      expect(find.text('Title must be at least 3 characters'), findsOneWidget);

      // Should still be on edit screen
      expect(find.byType(ProductEditScreen), findsOneWidget);
    });

    testWidgets('e. Creating a product with short description fails', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to add screen
      await tester.tap(find.byKey(const Key('add_product_fab')));
      await tester.pumpAndSettle();

      // Enter valid title
      final titleField = find.byKey(const Key('title_field'));
      await tester.enterText(titleField, 'Test Product');
      await tester.pumpAndSettle();

      // Enter too short description
      final descriptionField = find.byKey(const Key('description_field'));
      await tester.enterText(descriptionField, 'Short');
      await tester.pumpAndSettle();

      // Tap Save button
      final saveButton = find.byKey(const Key('save_product_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Should show validation error
      expect(find.text('Description must be at least 10 characters'), findsOneWidget);

      // Should still be on edit screen
      expect(find.byType(ProductEditScreen), findsOneWidget);
    });
  });
}
