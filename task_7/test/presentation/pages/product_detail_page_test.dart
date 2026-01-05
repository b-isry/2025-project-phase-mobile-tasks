import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_manager/domain/entities/product.dart';
import 'package:product_manager/presentation/bloc/product_bloc.dart';
import 'package:product_manager/presentation/bloc/product_event.dart';
import 'package:product_manager/presentation/bloc/product_state.dart';
import 'package:product_manager/presentation/pages/product_detail_page.dart';
import 'package:product_manager/presentation/widgets/loading_widget.dart';
import 'package:product_manager/presentation/widgets/error_widget.dart' as error_widget;

/// Mock ProductBloc for testing
class MockProductBloc extends Mock implements ProductBloc {}

void main() {
  late MockProductBloc mockBloc;

  setUp(() {
    mockBloc = MockProductBloc();
  });

  group('ProductDetailPage', () {
    final testProduct = Product(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      price: 99.99,
      imageUrl: 'https://example.com/image.jpg',
    );

    testWidgets('should dispatch GetSingleProductEvent on init',
        (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const LoadingState()),
        initialState: const LoadingState(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductDetailPage(productId: '1'),
          ),
        ),
      );

      // Assert
      verify(() => mockBloc.add(any(that: isA<GetSingleProductEvent>()))).called(1);
    });

    testWidgets('should display loading widget when state is LoadingState',
        (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const LoadingState()),
        initialState: const LoadingState(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductDetailPage(productId: '1'),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.text('Loading product...'), findsOneWidget);
    });

    testWidgets('should display error widget when state is ErrorState',
        (tester) async {
      // Arrange
      const errorMessage = 'Product not found';
      whenListen(
        mockBloc,
        Stream.value(const ErrorState(errorMessage)),
        initialState: const ErrorState(errorMessage),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductDetailPage(productId: '1'),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.byType(error_widget.ProductErrorWidget), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display product details when state is LoadedSingleProductState',
        (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(LoadedSingleProductState(testProduct)),
        initialState: LoadedSingleProductState(testProduct),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductDetailPage(productId: '1'),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('\$99.99'), findsOneWidget);
      expect(find.text('Delete Product'), findsOneWidget);
    });

    testWidgets('should show edit button when product is loaded', (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(LoadedSingleProductState(testProduct)),
        initialState: LoadedSingleProductState(testProduct),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductDetailPage(productId: '1'),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('should dispatch DeleteProductEvent on delete confirmation',
        (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(LoadedSingleProductState(testProduct)),
        initialState: LoadedSingleProductState(testProduct),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductDetailPage(productId: '1'),
          ),
        ),
      );

      await tester.pump();

      // Tap delete button
      await tester.tap(find.text('Delete Product'));
      await tester.pump();

      // Confirm delete
      await tester.tap(find.text('Delete'));
      await tester.pump();

      // Assert
      verify(() => mockBloc.add(any(that: isA<DeleteProductEvent>()))).called(1);
    });

    testWidgets('should show delete confirmation dialog', (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(LoadedSingleProductState(testProduct)),
        initialState: LoadedSingleProductState(testProduct),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductDetailPage(productId: '1'),
          ),
        ),
      );

      await tester.pump();

      // Tap delete button
      await tester.tap(find.text('Delete Product'));
      await tester.pump();

      // Assert
      expect(find.text('Delete Product'), findsNWidgets(2)); // Button and dialog title
      expect(find.text('Are you sure you want to delete "Test Product"?'),
          findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });
  });
}
