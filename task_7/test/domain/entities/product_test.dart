import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/domain/entities/product.dart';

void main() {
  group('Product Entity Tests', () {
    group('Constructor', () {
      test('should create a product with all required fields', () {
        // Arrange & Act
        final product = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
          imageUrl: 'https://example.com/image.jpg',
        );

        // Assert
        expect(product.id, '1');
        expect(product.name, 'Test Product');
        expect(product.description, 'Test Description');
        expect(product.price, 99.99);
        expect(product.imageUrl, 'https://example.com/image.jpg');
      });

      test('should create a product with default imageUrl when not provided', () {
        // Arrange & Act
        final product = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
        );

        // Assert
        expect(product.imageUrl, '');
      });

      test('should provide title getter for backward compatibility', () {
        // Arrange & Act
        final product = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
        );

        // Assert
        expect(product.title, 'Test Product');
        expect(product.title, product.name);
      });
    });

    group('copyWith', () {
      test('should create a copy with updated name', () {
        // Arrange
        final original = Product(
          id: '1',
          name: 'Original Name',
          description: 'Description',
          price: 50.0,
        );

        // Act
        final updated = original.copyWith(name: 'Updated Name');

        // Assert
        expect(updated.id, original.id);
        expect(updated.name, 'Updated Name');
        expect(updated.description, original.description);
        expect(updated.price, original.price);
      });

      test('should create a copy with updated price', () {
        // Arrange
        final original = Product(
          id: '1',
          name: 'Product',
          description: 'Description',
          price: 50.0,
        );

        // Act
        final updated = original.copyWith(price: 75.0);

        // Assert
        expect(updated.price, 75.0);
        expect(updated.name, original.name);
      });

      test('should create a copy with updated imageUrl', () {
        // Arrange
        final original = Product(
          id: '1',
          name: 'Product',
          description: 'Description',
          price: 50.0,
        );

        // Act
        final updated = original.copyWith(imageUrl: 'https://new-image.com/img.jpg');

        // Assert
        expect(updated.imageUrl, 'https://new-image.com/img.jpg');
      });

      test('should create a copy without changes when no parameters provided', () {
        // Arrange
        final original = Product(
          id: '1',
          name: 'Product',
          description: 'Description',
          price: 50.0,
          imageUrl: 'https://example.com/img.jpg',
        );

        // Act
        final copy = original.copyWith();

        // Assert
        expect(copy.id, original.id);
        expect(copy.name, original.name);
        expect(copy.description, original.description);
        expect(copy.price, original.price);
        expect(copy.imageUrl, original.imageUrl);
      });
    });

    group('toJson', () {
      test('should convert product to JSON map', () {
        // Arrange
        final product = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
          imageUrl: 'https://example.com/image.jpg',
        );

        // Act
        final json = product.toJson();

        // Assert
        expect(json, {
          'id': '1',
          'name': 'Test Product',
          'description': 'Test Description',
          'price': 99.99,
          'imageUrl': 'https://example.com/image.jpg',
        });
      });

      test('should convert product with empty imageUrl to JSON', () {
        // Arrange
        final product = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
        );

        // Act
        final json = product.toJson();

        // Assert
        expect(json['imageUrl'], '');
      });
    });

    group('fromJson', () {
      test('should create product from JSON map', () {
        // Arrange
        final json = {
          'id': '1',
          'name': 'Test Product',
          'description': 'Test Description',
          'price': 99.99,
          'imageUrl': 'https://example.com/image.jpg',
        };

        // Act
        final product = Product.fromJson(json);

        // Assert
        expect(product.id, '1');
        expect(product.name, 'Test Product');
        expect(product.description, 'Test Description');
        expect(product.price, 99.99);
        expect(product.imageUrl, 'https://example.com/image.jpg');
      });

      test('should create product from JSON with title field (backward compatibility)', () {
        // Arrange
        final json = {
          'id': '1',
          'title': 'Test Product',
          'description': 'Test Description',
          'price': 99.99,
          'imageUrl': 'https://example.com/image.jpg',
        };

        // Act
        final product = Product.fromJson(json);

        // Assert
        expect(product.name, 'Test Product');
      });

      test('should create product from JSON without imageUrl', () {
        // Arrange
        final json = {
          'id': '1',
          'name': 'Test Product',
          'description': 'Test Description',
          'price': 99.99,
        };

        // Act
        final product = Product.fromJson(json);

        // Assert
        expect(product.imageUrl, '');
      });

      test('should handle integer price in JSON', () {
        // Arrange
        final json = {
          'id': '1',
          'name': 'Test Product',
          'description': 'Test Description',
          'price': 100,
        };

        // Act
        final product = Product.fromJson(json);

        // Assert
        expect(product.price, 100.0);
      });
    });

    group('Equality', () {
      test('should be equal when all fields are equal', () {
        // Arrange
        final product1 = Product(
          id: '1',
          name: 'Product',
          description: 'Description',
          price: 99.99,
          imageUrl: 'https://example.com/img.jpg',
        );
        final product2 = Product(
          id: '1',
          name: 'Product',
          description: 'Description',
          price: 99.99,
          imageUrl: 'https://example.com/img.jpg',
        );

        // Act & Assert
        expect(product1, equals(product2));
        expect(product1.hashCode, equals(product2.hashCode));
      });

      test('should not be equal when names differ', () {
        // Arrange
        final product1 = Product(
          id: '1',
          name: 'Product A',
          description: 'Description',
          price: 99.99,
        );
        final product2 = Product(
          id: '1',
          name: 'Product B',
          description: 'Description',
          price: 99.99,
        );

        // Act & Assert
        expect(product1, isNot(equals(product2)));
      });

      test('should not be equal when prices differ', () {
        // Arrange
        final product1 = Product(
          id: '1',
          name: 'Product',
          description: 'Description',
          price: 99.99,
        );
        final product2 = Product(
          id: '1',
          name: 'Product',
          description: 'Description',
          price: 89.99,
        );

        // Act & Assert
        expect(product1, isNot(equals(product2)));
      });

      test('should be equal to itself', () {
        // Arrange
        final product = Product(
          id: '1',
          name: 'Product',
          description: 'Description',
          price: 99.99,
        );

        // Act & Assert
        expect(product, equals(product));
      });
    });

    group('toString', () {
      test('should return a string representation of the product', () {
        // Arrange
        final product = Product(
          id: '1',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
          imageUrl: 'https://example.com/img.jpg',
        );

        // Act
        final result = product.toString();

        // Assert
        expect(result, contains('Product'));
        expect(result, contains('id: 1'));
        expect(result, contains('name: Test Product'));
        expect(result, contains('price: 99.99'));
      });
    });
  });
}

