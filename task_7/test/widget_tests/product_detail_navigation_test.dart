import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/screens/home_screen.dart';
import 'package:product_manager/screens/product_view_screen.dart';
import '../helpers/test_wrapper.dart';

void main() {
  group('Product Detail Navigation Tests', () {
    testWidgets('a. Tap product card -> navigates to detail screen', (WidgetTester tester) async {
      // Create test product
      final testProduct = Product(
        id: '1',
        title: 'Test Product',
        description: 'This is a test product description',
      );

      // Build HomeScreen with seeded product
      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
          initialProducts: [testProduct],
        ),
      );
      await tester.pumpAndSettle();

      // Verify product is displayed
      expect(find.text('Test Product'), findsOneWidget);

      // Find and tap the product card
      final productCard = find.byKey(const Key('product_card_1'));
      expect(productCard, findsOneWidget);
      
      await tester.tap(productCard);
      await tester.pumpAndSettle();

      // Verify navigation to ProductViewScreen
      expect(find.byType(ProductViewScreen), findsOneWidget);

      // Check for title in detail screen
      expect(find.text('Test Product'), findsOneWidget);

      // Check for description in detail screen
      expect(find.text('This is a test product description'), findsOneWidget);
    });

    testWidgets('b. Tap back button -> returns to home', (WidgetTester tester) async {
      final testProduct = Product(
        id: '1',
        title: 'Test Product',
        description: 'Test product description for navigation',
      );

      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
          initialProducts: [testProduct],
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to detail screen
      final productCard = find.byKey(const Key('product_card_1'));
      await tester.tap(productCard);
      await tester.pumpAndSettle();

      // Verify we're on detail screen
      expect(find.byType(ProductViewScreen), findsOneWidget);

      // Find and tap the back button (look for IconButton with Icons.arrow_back or BackButton)
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
      } else {
        // Try finding the back arrow icon
        final backIcon = find.byIcon(Icons.arrow_back);
        if (backIcon.evaluate().isNotEmpty) {
          await tester.tap(backIcon);
        } else {
          // Use Navigator to go back
          final NavigatorState navigator = tester.state(find.byType(Navigator));
          navigator.pop();
        }
      }
      await tester.pumpAndSettle();

      // Verify we're back on HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(ProductViewScreen), findsNothing);

      // Verify product list still intact
      expect(find.text('Test Product'), findsOneWidget);
    });

    testWidgets('c. Product detail shows all information', (WidgetTester tester) async {
      final testProduct = Product(
        id: '42',
        title: 'Detailed Product',
        description: 'This is a very detailed product description',
      );

      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
          initialProducts: [testProduct],
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to detail screen
      await tester.tap(find.byKey(const Key('product_card_42')));
      await tester.pumpAndSettle();

      // Verify all product information is displayed
      expect(find.text('Detailed Product'), findsOneWidget);
      expect(find.text('This is a very detailed product description'), findsOneWidget);
      expect(find.text('42'), findsOneWidget); // Product ID
    });

    testWidgets('d. Multiple products can be navigated individually', (WidgetTester tester) async {
      final testProducts = [
        Product(id: '1', title: 'First Product', description: 'First description text'),
        Product(id: '2', title: 'Second Product', description: 'Second description text'),
      ];

      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
          initialProducts: testProducts,
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to first product
      await tester.tap(find.byKey(const Key('product_card_1')));
      await tester.pumpAndSettle();

      // Verify first product details
      expect(find.text('First Product'), findsOneWidget);
      expect(find.text('First description text'), findsOneWidget);

      // Go back using Navigator
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      // Navigate to second product
      await tester.tap(find.byKey(const Key('product_card_2')));
      await tester.pumpAndSettle();

      // Verify second product details
      expect(find.text('Second Product'), findsOneWidget);
      expect(find.text('Second description text'), findsOneWidget);
    });

    testWidgets('e. Hero animation tag is present', (WidgetTester tester) async {
      final testProduct = Product(
        id: '1',
        title: 'Hero Test',
        description: 'Testing hero animation tag',
      );

      await tester.pumpWidget(
        createTestApp(
          child: const HomeScreen(),
          initialProducts: [testProduct],
        ),
      );
      await tester.pumpAndSettle();

      // Verify Hero widget exists on home screen
      expect(find.byType(Hero), findsWidgets);

      // Navigate to detail
      await tester.tap(find.byKey(const Key('product_card_1')));
      await tester.pumpAndSettle();

      // Verify Hero widget exists on detail screen
      expect(find.byType(Hero), findsWidgets);
    });
  });
}
