import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_manager/domain/entities/product.dart';
import 'package:product_manager/presentation/bloc/product_bloc.dart';
import 'package:product_manager/presentation/bloc/product_event.dart';
import 'package:product_manager/presentation/bloc/product_state.dart';
import 'package:product_manager/presentation/pages/product_form_page.dart';
import 'package:product_manager/presentation/widgets/loading_widget.dart';

/// Mock ProductBloc for testing
class MockProductBloc extends Mock implements ProductBloc {}

void main() {
  late MockProductBloc mockBloc;

  setUp(() {
    mockBloc = MockProductBloc();
  });

  group('ProductFormPage - Create Mode', () {
    testWidgets('should display form fields for creating product',
        (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const InitialState()),
        initialState: const InitialState(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductFormPage(),
          ),
        ),
      );

      // Assert
      expect(find.text('Add Product'), findsOneWidget);
      expect(find.text('Product Name'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Image URL (Optional)'), findsOneWidget);
      expect(find.text('Create Product'), findsOneWidget);
    });

    testWidgets('should validate required fields', (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const InitialState()),
        initialState: const InitialState(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductFormPage(),
          ),
        ),
      );

      // Try to submit empty form
      await tester.tap(find.text('Create Product'));
      await tester.pump();

      // Assert - validation errors should appear
      expect(find.text('Please enter a product name'), findsOneWidget);
    });

    testWidgets('should dispatch CreateProductEvent on valid form submission',
        (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const InitialState()),
        initialState: const InitialState(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductFormPage(),
          ),
        ),
      );

      // Fill form
      await tester.enterText(find.byType(TextFormField).first, 'Test Product');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'Test Description');
      await tester.enterText(find.byType(TextFormField).at(2), '99.99');
      await tester.enterText(find.byType(TextFormField).at(3), 'https://example.com/image.jpg');

      // Submit
      await tester.tap(find.text('Create Product'));
      await tester.pump();

      // Assert
      verify(() => mockBloc.add(any(that: isA<CreateProductEvent>()))).called(1);
    });

    testWidgets('should show loading widget when submitting', (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const LoadingState()),
        initialState: const InitialState(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductFormPage(),
          ),
        ),
      );

      // Fill and submit form
      await tester.enterText(find.byType(TextFormField).first, 'Test Product');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'Test Description');
      await tester.enterText(find.byType(TextFormField).at(2), '99.99');
      await tester.tap(find.text('Create Product'));
      await tester.pump();

      // Manually trigger loading state
      whenListen(
        mockBloc,
        Stream.value(const LoadingState()),
        initialState: const LoadingState(),
      );
      await tester.pump();

      // Assert
      expect(find.byType(LoadingWidget), findsOneWidget);
    });
  });

  group('ProductFormPage - Edit Mode', () {
    final testProduct = Product(
      id: '1',
      name: 'Original Product',
      description: 'Original Description',
      price: 50.0,
      imageUrl: 'https://example.com/original.jpg',
    );

    testWidgets('should display form fields pre-filled with product data',
        (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const InitialState()),
        initialState: const InitialState(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: ProductFormPage(product: testProduct),
          ),
        ),
      );

      // Assert
      expect(find.text('Edit Product'), findsOneWidget);
      expect(find.text('Update Product'), findsOneWidget);
      expect(find.text('Original Product'), findsOneWidget);
      expect(find.text('Original Description'), findsOneWidget);
      expect(find.text('50.00'), findsOneWidget);
    });

    testWidgets('should dispatch UpdateProductEvent on valid form submission',
        (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const InitialState()),
        initialState: const InitialState(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: ProductFormPage(product: testProduct),
          ),
        ),
      );

      // Update form
      await tester.enterText(find.byType(TextFormField).first, 'Updated Product');
      await tester.tap(find.text('Update Product'));
      await tester.pump();

      // Assert
      verify(() => mockBloc.add(any(that: isA<UpdateProductEvent>()))).called(1);
    });
  });

  group('ProductFormPage - State Handling', () {
    testWidgets('should show error snackbar on ErrorState', (tester) async {
      // Arrange
      const errorMessage = 'Failed to create product';
      whenListen(
        mockBloc,
        Stream.value(const ErrorState(errorMessage)),
        initialState: const InitialState(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductFormPage(),
          ),
        ),
      );

      // Fill and submit form
      await tester.enterText(find.byType(TextFormField).first, 'Test Product');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'Test Description');
      await tester.enterText(find.byType(TextFormField).at(2), '99.99');
      await tester.tap(find.text('Create Product'));
      await tester.pump();

      // Trigger error state
      whenListen(
        mockBloc,
        Stream.value(const ErrorState(errorMessage)),
        initialState: const ErrorState(errorMessage),
      );
      await tester.pump();

      // Assert
      expect(find.text('Error: $errorMessage'), findsOneWidget);
    });

    testWidgets('should navigate back on success', (tester) async {
      // Arrange
      final products = [
        Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
        ),
      ];
      whenListen(
        mockBloc,
        Stream.value(LoadedAllProductsState(products)),
        initialState: const InitialState(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductFormPage(),
          ),
        ),
      );

      // Fill and submit form
      await tester.enterText(find.byType(TextFormField).first, 'Test Product');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'Test Description');
      await tester.enterText(find.byType(TextFormField).at(2), '99.99');
      await tester.tap(find.text('Create Product'));
      await tester.pump();

      // Trigger success state
      whenListen(
        mockBloc,
        Stream.value(LoadedAllProductsState(products)),
        initialState: LoadedAllProductsState(products),
      );
      await tester.pump();

      // Assert - should show success message
      expect(find.text('Product created successfully!'), findsOneWidget);
    });
  });
}
