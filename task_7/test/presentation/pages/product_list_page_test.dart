import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_manager/domain/entities/product.dart';
import 'package:product_manager/presentation/bloc/product_bloc.dart';
import 'package:product_manager/presentation/bloc/product_event.dart';
import 'package:product_manager/presentation/bloc/product_state.dart';
import 'package:product_manager/presentation/pages/product_list_page.dart';
import 'package:product_manager/presentation/widgets/loading_widget.dart';
import 'package:product_manager/presentation/widgets/error_widget.dart' as error_widget;
import 'package:product_manager/presentation/widgets/empty_state_widget.dart';

/// Mock ProductBloc for testing
class MockProductBloc extends Mock implements ProductBloc {}

void main() {
  late MockProductBloc mockBloc;

  setUp(() {
    mockBloc = MockProductBloc();
  });

  group('ProductListPage', () {
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
            child: const ProductListPage(),
          ),
        ),
      );

      // Assert
      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.text('Loading products...'), findsOneWidget);
    });

    testWidgets('should display error widget when state is ErrorState',
        (tester) async {
      // Arrange
      const errorMessage = 'Failed to load products';
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
            child: const ProductListPage(),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.byType(error_widget.ProductErrorWidget), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display empty state when products list is empty',
        (tester) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const LoadedAllProductsState([])),
        initialState: const LoadedAllProductsState([]),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductListPage(),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    testWidgets('should display product list when products are loaded',
        (tester) async {
      // Arrange
      final products = [
        Product(
          id: '1',
          name: 'Product 1',
          description: 'Description 1',
          price: 50.0,
        ),
        Product(
          id: '2',
          name: 'Product 2',
          description: 'Description 2',
          price: 75.0,
        ),
      ];

      whenListen(
        mockBloc,
        Stream.value(LoadedAllProductsState(products)),
        initialState: LoadedAllProductsState(products),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const ProductListPage(),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Product 2'), findsOneWidget);
      expect(find.text('\$50.00'), findsOneWidget);
      expect(find.text('\$75.00'), findsOneWidget);
    });

    testWidgets('should display initial state widget when state is InitialState',
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
            child: const ProductListPage(),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text('Welcome! Tap + to add your first product.'),
          findsOneWidget);
    });

    testWidgets('should have floating action button', (tester) async {
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
            child: const ProductListPage(),
          ),
        ),
      );

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should have refresh button in app bar', (tester) async {
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
            child: const ProductListPage(),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });
}
