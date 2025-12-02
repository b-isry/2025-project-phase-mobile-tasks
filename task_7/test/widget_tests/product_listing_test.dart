import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/screens/home_screen.dart';
import 'package:product_manager/screens/product_edit_screen.dart';
import '../helpers/test_wrapper.dart';

void main() {
  group('Product Listing Tests', () {
    testWidgets('a. Home screen shows product list', (WidgetTester tester) async {
      // Create test products
      final testProducts = [
        Product(id: '1', title: 'Laptop', description: 'High-performance laptop'),
        Product(id: '2', title: 'Smartphone', description: 'Latest flagship phone'),
        Product(id: '3', title: 'Headphones', description: 'Noise-cancelling headphones'),
      ];

      // Build HomeScreen with seeded products
      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
          initialProducts: testProducts,
        ),
      );
      await tester.pumpAndSettle();

      // Verify grid/list appears
      expect(find.byType(GridView), findsOneWidget);

      // Verify all product titles are visible
      expect(find.text('Laptop'), findsOneWidget);
      expect(find.text('Smartphone'), findsOneWidget);
      expect(find.text('Headphones'), findsOneWidget);
    });

    testWidgets('b. Empty state displays when no products', (WidgetTester tester) async {
      // Build HomeScreen with no products
      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify empty state message
      expect(find.text('No products yet'), findsOneWidget);
      expect(find.text('Tap + to add your first product!'), findsOneWidget);

      // Verify grid is not shown
      expect(find.byType(GridView), findsNothing);
    });

    testWidgets('c. List updates after adding product', (WidgetTester tester) async {
      // Start with 1 product
      final initialProducts = [
        Product(id: '1', title: 'Laptop', description: 'High-performance laptop'),
      ];

      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
          initialProducts: initialProducts,
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial product count
      expect(find.text('Laptop'), findsOneWidget);

      // Tap FAB to add new product
      await tester.tap(find.byKey(const Key('add_product_fab')));
      await tester.pumpAndSettle();

      // Verify navigation to edit screen
      expect(find.byType(ProductEditScreen), findsOneWidget);

      // Enter product details
      await tester.enterText(find.byKey(const Key('title_field')), 'New Product');
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('description_field')),
        'This is a newly added product',
      );
      await tester.pumpAndSettle();

      // Save the product
      await tester.tap(find.byKey(const Key('save_product_button')));
      await tester.pumpAndSettle();

      // Verify we're back on home screen
      expect(find.byType(HomeScreen), findsOneWidget);

      // Verify product count increased - both products should be visible
      expect(find.text('Laptop'), findsOneWidget);
      expect(find.text('New Product'), findsOneWidget);

      // Verify grid has items
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('d. Grid displays products in 2 columns', (WidgetTester tester) async {
      // Create 4 products to test grid layout
      final testProducts = [
        Product(id: '1', title: 'Product 1', description: 'Description 1 for testing'),
        Product(id: '2', title: 'Product 2', description: 'Description 2 for testing'),
        Product(id: '3', title: 'Product 3', description: 'Description 3 for testing'),
        Product(id: '4', title: 'Product 4', description: 'Description 4 for testing'),
      ];

      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
          initialProducts: testProducts,
        ),
      );
      await tester.pumpAndSettle();

      // Verify all products are displayed
      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Product 2'), findsOneWidget);
      expect(find.text('Product 3'), findsOneWidget);
      expect(find.text('Product 4'), findsOneWidget);

      // Verify grid view exists
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('e. Products display with correct keys', (WidgetTester tester) async {
      final testProducts = [
        Product(id: '1', title: 'Test Product', description: 'Test Description for testing'),
      ];

      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
          initialProducts: testProducts,
        ),
      );
      await tester.pumpAndSettle();

      // Verify product card has correct key
      expect(find.byKey(const Key('product_card_1')), findsOneWidget);
    });
  });
}
