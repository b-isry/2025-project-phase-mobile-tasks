import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/domain/entities/product.dart';
import 'package:product_manager/presentation/bloc/product_event.dart';

void main() {
  group('ProductEvent', () {
    group('LoadAllProductsEvent', () {
      test('should be instantiable', () {
        // Act
        const event = LoadAllProductsEvent();

        // Assert
        expect(event, isA<ProductEvent>());
        expect(event, isA<LoadAllProductsEvent>());
      });

      test('should have correct equality', () {
        // Arrange
        const event1 = LoadAllProductsEvent();
        const event2 = LoadAllProductsEvent();

        // Assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should have correct props', () {
        // Arrange
        const event = LoadAllProductsEvent();

        // Assert
        expect(event.props, isEmpty);
      });
    });

    group('GetSingleProductEvent', () {
      test('should be instantiable with productId', () {
        // Arrange
        const productId = 'test-id-123';

        // Act
        final event = GetSingleProductEvent(productId);

        // Assert
        expect(event, isA<ProductEvent>());
        expect(event, isA<GetSingleProductEvent>());
        expect(event.productId, equals(productId));
      });

      test('should have correct equality', () {
        // Arrange
        const productId = 'test-id-123';
        final event1 = GetSingleProductEvent(productId);
        final event2 = GetSingleProductEvent(productId);
        final event3 = GetSingleProductEvent('different-id');

        // Assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
        expect(event1, isNot(equals(event3)));
      });

      test('should have correct props', () {
        // Arrange
        const productId = 'test-id-123';
        final event = GetSingleProductEvent(productId);

        // Assert
        expect(event.props, equals([productId]));
      });
    });

    group('CreateProductEvent', () {
      test('should be instantiable with product', () {
        // Arrange
        final product = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
        );

        // Act
        final event = CreateProductEvent(product);

        // Assert
        expect(event, isA<ProductEvent>());
        expect(event, isA<CreateProductEvent>());
        expect(event.product, equals(product));
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

        final event1 = CreateProductEvent(product1);
        final event2 = CreateProductEvent(product2);
        final event3 = CreateProductEvent(product3);

        // Assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
        expect(event1, isNot(equals(event3)));
      });

      test('should have correct props', () {
        // Arrange
        final product = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
        );
        final event = CreateProductEvent(product);

        // Assert
        expect(event.props, equals([product]));
      });
    });

    group('UpdateProductEvent', () {
      test('should be instantiable with product', () {
        // Arrange
        final product = Product(
          id: '1',
          name: 'Updated Product',
          description: 'Updated Description',
          price: 150.0,
        );

        // Act
        final event = UpdateProductEvent(product);

        // Assert
        expect(event, isA<ProductEvent>());
        expect(event, isA<UpdateProductEvent>());
        expect(event.product, equals(product));
      });

      test('should have correct equality', () {
        // Arrange
        final product1 = Product(
          id: '1',
          name: 'Updated Product',
          description: 'Updated Description',
          price: 150.0,
        );
        final product2 = Product(
          id: '1',
          name: 'Updated Product',
          description: 'Updated Description',
          price: 150.0,
        );

        final event1 = UpdateProductEvent(product1);
        final event2 = UpdateProductEvent(product2);

        // Assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should have correct props', () {
        // Arrange
        final product = Product(
          id: '1',
          name: 'Updated Product',
          description: 'Updated Description',
          price: 150.0,
        );
        final event = UpdateProductEvent(product);

        // Assert
        expect(event.props, equals([product]));
      });
    });

    group('DeleteProductEvent', () {
      test('should be instantiable with productId', () {
        // Arrange
        const productId = 'product-to-delete';

        // Act
        final event = DeleteProductEvent(productId);

        // Assert
        expect(event, isA<ProductEvent>());
        expect(event, isA<DeleteProductEvent>());
        expect(event.productId, equals(productId));
      });

      test('should have correct equality', () {
        // Arrange
        const productId = 'product-to-delete';
        final event1 = DeleteProductEvent(productId);
        final event2 = DeleteProductEvent(productId);
        final event3 = DeleteProductEvent('different-id');

        // Assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
        expect(event1, isNot(equals(event3)));
      });

      test('should have correct props', () {
        // Arrange
        const productId = 'product-to-delete';
        final event = DeleteProductEvent(productId);

        // Assert
        expect(event.props, equals([productId]));
      });
    });
  });
}
