import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/domain/entities/product.dart';
import 'package:product_manager/presentation/bloc/product_state.dart';

void main() {
  group('ProductState', () {
    group('InitialState', () {
      test('should be instantiable', () {
        // Act
        const state = InitialState();

        // Assert
        expect(state, isA<ProductState>());
        expect(state, isA<InitialState>());
      });

      test('should have correct equality', () {
        // Arrange
        const state1 = InitialState();
        const state2 = InitialState();

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should have correct props', () {
        // Arrange
        const state = InitialState();

        // Assert
        expect(state.props, isEmpty);
      });
    });

    group('LoadingState', () {
      test('should be instantiable', () {
        // Act
        const state = LoadingState();

        // Assert
        expect(state, isA<ProductState>());
        expect(state, isA<LoadingState>());
      });

      test('should have correct equality', () {
        // Arrange
        const state1 = LoadingState();
        const state2 = LoadingState();

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should have correct props', () {
        // Arrange
        const state = LoadingState();

        // Assert
        expect(state.props, isEmpty);
      });
    });

    group('LoadedAllProductsState', () {
      test('should be instantiable with products list', () {
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

        // Act
        final state = LoadedAllProductsState(products);

        // Assert
        expect(state, isA<ProductState>());
        expect(state, isA<LoadedAllProductsState>());
        expect(state.products, equals(products));
        expect(state.products.length, equals(2));
      });

      test('should handle empty products list', () {
        // Arrange
        final products = <Product>[];

        // Act
        final state = LoadedAllProductsState(products);

        // Assert
        expect(state.products, isEmpty);
      });

      test('should have correct equality', () {
        // Arrange
        final products1 = [
          Product(
            id: '1',
            name: 'Product 1',
            description: 'Description 1',
            price: 50.0,
          ),
        ];
        final products2 = [
          Product(
            id: '1',
            name: 'Product 1',
            description: 'Description 1',
            price: 50.0,
          ),
        ];
        final products3 = [
          Product(
            id: '2',
            name: 'Product 2',
            description: 'Description 2',
            price: 75.0,
          ),
        ];

        final state1 = LoadedAllProductsState(products1);
        final state2 = LoadedAllProductsState(products2);
        final state3 = LoadedAllProductsState(products3);

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
        expect(state1, isNot(equals(state3)));
      });

      test('should have correct props', () {
        // Arrange
        final products = [
          Product(
            id: '1',
            name: 'Product 1',
            description: 'Description 1',
            price: 50.0,
          ),
        ];
        final state = LoadedAllProductsState(products);

        // Assert
        expect(state.props, equals([products]));
      });
    });

    group('LoadedSingleProductState', () {
      test('should be instantiable with product', () {
        // Arrange
        final product = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
        );

        // Act
        final state = LoadedSingleProductState(product);

        // Assert
        expect(state, isA<ProductState>());
        expect(state, isA<LoadedSingleProductState>());
        expect(state.product, equals(product));
      });

      test('should have correct equality', () {
        // Arrange
        final product1 = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
        );
        final product2 = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
        );
        final product3 = Product(
          id: '2',
          name: 'Different Product',
          description: 'Different Description',
          price: 50.0,
        );

        final state1 = LoadedSingleProductState(product1);
        final state2 = LoadedSingleProductState(product2);
        final state3 = LoadedSingleProductState(product3);

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
        expect(state1, isNot(equals(state3)));
      });

      test('should have correct props', () {
        // Arrange
        final product = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
        );
        final state = LoadedSingleProductState(product);

        // Assert
        expect(state.props, equals([product]));
      });
    });

    group('ErrorState', () {
      test('should be instantiable with error message', () {
        // Arrange
        const errorMessage = 'An error occurred';

        // Act
        final state = ErrorState(errorMessage);

        // Assert
        expect(state, isA<ProductState>());
        expect(state, isA<ErrorState>());
        expect(state.message, equals(errorMessage));
      });

      test('should handle empty error message', () {
        // Arrange
        const errorMessage = '';

        // Act
        final state = ErrorState(errorMessage);

        // Assert
        expect(state.message, isEmpty);
      });

      test('should have correct equality', () {
        // Arrange
        const errorMessage = 'An error occurred';
        final state1 = ErrorState(errorMessage);
        final state2 = ErrorState(errorMessage);
        final state3 = ErrorState('Different error');

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
        expect(state1, isNot(equals(state3)));
      });

      test('should have correct props', () {
        // Arrange
        const errorMessage = 'An error occurred';
        final state = ErrorState(errorMessage);

        // Assert
        expect(state.props, equals([errorMessage]));
      });
    });
  });
}
