import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/domain/entities/product.dart';
import 'package:product_manager/data/repositories/product_repository.dart';

void main() {
  late ProductRepository repository;

  setUp(() {
    // Create a fresh repository before each test
    repository = ProductRepository(initialProducts: {});
  });

  group('ProductRepository - Insert Operations', () {
    test('should insert a product successfully', () async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        imageUrl: 'https://example.com/img.jpg',
      );

      // Act
      await repository.insertProduct(product);

      // Assert
      final retrieved = await repository.getProduct('1');
      expect(retrieved, equals(product));
    });

    test('should insert multiple products', () async {
      // Arrange
      final product1 = Product(
        id: '1',
        name: 'Product 1',
        description: 'Description 1',
        price: 50.0,
      );
      final product2 = Product(
        id: '2',
        name: 'Product 2',
        description: 'Description 2',
        price: 75.0,
      );

      // Act
      await repository.insertProduct(product1);
      await repository.insertProduct(product2);

      // Assert
      expect(repository.productCount, 2);
      final retrieved1 = await repository.getProduct('1');
      final retrieved2 = await repository.getProduct('2');
      expect(retrieved1, equals(product1));
      expect(retrieved2, equals(product2));
    });

    test('should replace product when inserting with same ID', () async {
      // Arrange
      final product1 = Product(
        id: '1',
        name: 'Original Product',
        description: 'Original Description',
        price: 50.0,
      );
      final product2 = Product(
        id: '1',
        name: 'Replacement Product',
        description: 'Replacement Description',
        price: 75.0,
      );

      // Act
      await repository.insertProduct(product1);
      await repository.insertProduct(product2);

      // Assert
      final retrieved = await repository.getProduct('1');
      expect(retrieved?.name, 'Replacement Product');
      expect(repository.productCount, 1);
    });

    test('should throw ArgumentError when inserting product with empty ID', () async {
      // Arrange
      final product = Product(
        id: '',
        name: 'Invalid Product',
        description: 'Description',
        price: 50.0,
      );

      // Act & Assert
      expect(
        () => repository.insertProduct(product),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('ProductRepository - Update Operations', () {
    test('should update an existing product successfully', () async {
      // Arrange
      final originalProduct = Product(
        id: '1',
        name: 'Original Name',
        description: 'Original Description',
        price: 50.0,
      );
      await repository.insertProduct(originalProduct);

      final updatedProduct = originalProduct.copyWith(
        name: 'Updated Name',
        price: 75.0,
      );

      // Act
      await repository.updateProduct(updatedProduct);

      // Assert
      final retrieved = await repository.getProduct('1');
      expect(retrieved?.name, 'Updated Name');
      expect(retrieved?.price, 75.0);
      expect(retrieved?.description, 'Original Description');
    });

    test('should throw StateError when updating non-existent product', () async {
      // Arrange
      final product = Product(
        id: '999',
        name: 'Non-existent Product',
        description: 'Description',
        price: 50.0,
      );

      // Act & Assert
      expect(
        () => repository.updateProduct(product),
        throwsA(isA<StateError>()),
      );
    });

    test('should throw ArgumentError when updating product with empty ID', () async {
      // Arrange
      final product = Product(
        id: '',
        name: 'Invalid Product',
        description: 'Description',
        price: 50.0,
      );

      // Act & Assert
      expect(
        () => repository.updateProduct(product),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should update all fields of a product', () async {
      // Arrange
      final originalProduct = Product(
        id: '1',
        name: 'Original Name',
        description: 'Original Description',
        price: 50.0,
        imageUrl: 'https://original.com/img.jpg',
      );
      await repository.insertProduct(originalProduct);

      final updatedProduct = Product(
        id: '1',
        name: 'New Name',
        description: 'New Description',
        price: 100.0,
        imageUrl: 'https://new.com/img.jpg',
      );

      // Act
      await repository.updateProduct(updatedProduct);

      // Assert
      final retrieved = await repository.getProduct('1');
      expect(retrieved, equals(updatedProduct));
    });
  });

  group('ProductRepository - Delete Operations', () {
    test('should delete an existing product successfully', () async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Product to Delete',
        description: 'Description',
        price: 50.0,
      );
      await repository.insertProduct(product);

      // Act
      await repository.deleteProduct('1');

      // Assert
      final retrieved = await repository.getProduct('1');
      expect(retrieved, isNull);
      expect(repository.productCount, 0);
    });

    test('should throw StateError when deleting non-existent product', () async {
      // Act & Assert
      expect(
        () => repository.deleteProduct('999'),
        throwsA(isA<StateError>()),
      );
    });

    test('should throw ArgumentError when deleting with empty ID', () async {
      // Act & Assert
      expect(
        () => repository.deleteProduct(''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should only delete specified product', () async {
      // Arrange
      final product1 = Product(
        id: '1',
        name: 'Product 1',
        description: 'Description 1',
        price: 50.0,
      );
      final product2 = Product(
        id: '2',
        name: 'Product 2',
        description: 'Description 2',
        price: 75.0,
      );
      await repository.insertProduct(product1);
      await repository.insertProduct(product2);

      // Act
      await repository.deleteProduct('1');

      // Assert
      final deleted = await repository.getProduct('1');
      final remaining = await repository.getProduct('2');
      expect(deleted, isNull);
      expect(remaining, equals(product2));
      expect(repository.productCount, 1);
    });
  });

  group('ProductRepository - Get Operations', () {
    test('should retrieve an existing product by ID', () async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
      );
      await repository.insertProduct(product);

      // Act
      final retrieved = await repository.getProduct('1');

      // Assert
      expect(retrieved, equals(product));
    });

    test('should return null when product does not exist', () async {
      // Act
      final retrieved = await repository.getProduct('999');

      // Assert
      expect(retrieved, isNull);
    });

    test('should throw ArgumentError when getting with empty ID', () async {
      // Act & Assert
      expect(
        () => repository.getProduct(''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should retrieve correct product from multiple products', () async {
      // Arrange
      final products = List.generate(
        5,
        (index) => Product(
          id: '${index + 1}',
          name: 'Product ${index + 1}',
          description: 'Description ${index + 1}',
          price: (index + 1) * 25.0,
        ),
      );

      for (final product in products) {
        await repository.insertProduct(product);
      }

      // Act
      final retrieved = await repository.getProduct('3');

      // Assert
      expect(retrieved, equals(products[2]));
    });
  });

  group('ProductRepository - GetAll Operations', () {
    test('should return empty list when no products exist', () async {
      // Act
      final products = await repository.getAllProducts();

      // Assert
      expect(products, isEmpty);
    });

    test('should return all products', () async {
      // Arrange
      final product1 = Product(
        id: '1',
        name: 'Product 1',
        description: 'Description 1',
        price: 50.0,
      );
      final product2 = Product(
        id: '2',
        name: 'Product 2',
        description: 'Description 2',
        price: 75.0,
      );
      await repository.insertProduct(product1);
      await repository.insertProduct(product2);

      // Act
      final products = await repository.getAllProducts();

      // Assert
      expect(products.length, 2);
      expect(products, contains(product1));
      expect(products, contains(product2));
    });
  });

  group('ProductRepository - Initialization', () {
    test('should initialize with default products when none provided', () {
      // Arrange & Act
      final repo = ProductRepository();

      // Assert
      expect(repo.productCount, 3); // Default products: Laptop, Smartphone, Headphones
    });

    test('should initialize with provided initial products', () {
      // Arrange
      final initialProducts = {
        '1': Product(
          id: '1',
          name: 'Initial Product',
          description: 'Description',
          price: 50.0,
        ),
      };

      // Act
      final repo = ProductRepository(initialProducts: initialProducts);

      // Assert
      expect(repo.productCount, 1);
    });

    test('should initialize with empty products map', () {
      // Arrange & Act
      final repo = ProductRepository(initialProducts: {});

      // Assert
      expect(repo.productCount, 0);
    });
  });

  group('ProductRepository - Clear Operation', () {
    test('should clear all products', () async {
      // Arrange
      final product1 = Product(
        id: '1',
        name: 'Product 1',
        description: 'Description 1',
        price: 50.0,
      );
      final product2 = Product(
        id: '2',
        name: 'Product 2',
        description: 'Description 2',
        price: 75.0,
      );
      await repository.insertProduct(product1);
      await repository.insertProduct(product2);

      // Act
      await repository.clear();

      // Assert
      expect(repository.productCount, 0);
      final products = await repository.getAllProducts();
      expect(products, isEmpty);
    });
  });

  group('ProductRepository - Full CRUD Integration', () {
    test('should complete full CRUD cycle successfully', () async {
      // Create
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
        imageUrl: 'https://example.com/img.jpg',
      );
      await repository.insertProduct(product);
      expect(repository.productCount, 1);

      // Read
      var retrieved = await repository.getProduct('1');
      expect(retrieved, equals(product));

      // Update
      final updatedProduct = product.copyWith(
        name: 'Updated Product',
        price: 149.99,
      );
      await repository.updateProduct(updatedProduct);
      retrieved = await repository.getProduct('1');
      expect(retrieved?.name, 'Updated Product');
      expect(retrieved?.price, 149.99);
      expect(repository.productCount, 1);

      // Delete
      await repository.deleteProduct('1');
      retrieved = await repository.getProduct('1');
      expect(retrieved, isNull);
      expect(repository.productCount, 0);
    });

    test('should handle complex multi-product scenario', () async {
      // Insert multiple products
      final products = List.generate(
        5,
        (index) => Product(
          id: '${index + 1}',
          name: 'Product ${index + 1}',
          description: 'Description ${index + 1}',
          price: (index + 1) * 25.0,
        ),
      );

      for (final product in products) {
        await repository.insertProduct(product);
      }
      expect(repository.productCount, 5);

      // Update some products
      await repository.updateProduct(products[1].copyWith(name: 'Updated Product 2'));
      await repository.updateProduct(products[3].copyWith(price: 200.0));

      // Delete some products
      await repository.deleteProduct('1');
      await repository.deleteProduct('5');
      expect(repository.productCount, 3);

      // Verify remaining products
      final allProducts = await repository.getAllProducts();
      expect(allProducts.length, 3);
      
      final product2 = await repository.getProduct('2');
      expect(product2?.name, 'Updated Product 2');
      
      final product4 = await repository.getProduct('4');
      expect(product4?.price, 200.0);
    });
  });

  group('ProductRepository - Edge Cases', () {
    test('should handle rapid sequential operations', () async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Description',
        price: 50.0,
      );

      // Act - Rapid operations
      await repository.insertProduct(product);
      await repository.updateProduct(product.copyWith(name: 'Update 1'));
      await repository.updateProduct(product.copyWith(name: 'Update 2'));
      await repository.updateProduct(product.copyWith(name: 'Update 3'));

      // Assert
      final retrieved = await repository.getProduct('1');
      expect(retrieved?.name, 'Update 3');
    });

    test('should maintain data integrity across operations', () async {
      // Arrange
      final products = List.generate(
        10,
        (index) => Product(
          id: '${index + 1}',
          name: 'Product ${index + 1}',
          description: 'Description ${index + 1}',
          price: (index + 1) * 10.0,
        ),
      );

      // Act - Insert all
      for (final product in products) {
        await repository.insertProduct(product);
      }

      // Delete odd-numbered products
      for (int i = 1; i <= 10; i += 2) {
        await repository.deleteProduct('$i');
      }

      // Assert
      expect(repository.productCount, 5);
      
      // Verify even-numbered products still exist
      for (int i = 2; i <= 10; i += 2) {
        final product = await repository.getProduct('$i');
        expect(product, isNotNull);
        expect(product?.name, 'Product $i');
      }
      
      // Verify odd-numbered products are deleted
      for (int i = 1; i <= 10; i += 2) {
        final product = await repository.getProduct('$i');
        expect(product, isNull);
      }
    });
  });
}

