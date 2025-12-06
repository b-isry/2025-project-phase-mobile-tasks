import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/domain/entities/product.dart';
import 'package:product_manager/domain/usecases/insert_product_usecase.dart';
import 'package:product_manager/domain/usecases/update_product_usecase.dart';
import 'package:product_manager/domain/usecases/delete_product_usecase.dart';
import 'package:product_manager/domain/usecases/get_product_usecase.dart';

/// Mock repository for testing use cases
class MockProductRepository implements ProductRepositoryInterface {
  final Map<String, Product> _products = {};
  
  bool insertCalled = false;
  bool updateCalled = false;
  bool deleteCalled = false;
  bool getCalled = false;
  
  Product? lastInsertedProduct;
  Product? lastUpdatedProduct;
  String? lastDeletedId;
  String? lastRetrievedId;

  @override
  Future<void> insertProduct(Product product) async {
    insertCalled = true;
    lastInsertedProduct = product;
    _products[product.id] = product;
  }

  @override
  Future<void> updateProduct(Product product) async {
    updateCalled = true;
    lastUpdatedProduct = product;
    if (!_products.containsKey(product.id)) {
      throw StateError('Product not found');
    }
    _products[product.id] = product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    deleteCalled = true;
    lastDeletedId = id;
    if (!_products.containsKey(id)) {
      throw StateError('Product not found');
    }
    _products.remove(id);
  }

  @override
  Future<Product?> getProduct(String id) async {
    getCalled = true;
    lastRetrievedId = id;
    return _products[id];
  }

  void reset() {
    insertCalled = false;
    updateCalled = false;
    deleteCalled = false;
    getCalled = false;
    lastInsertedProduct = null;
    lastUpdatedProduct = null;
    lastDeletedId = null;
    lastRetrievedId = null;
    _products.clear();
  }
}

void main() {
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
  });

  group('InsertProductUsecase Tests', () {
    late InsertProductUsecase usecase;

    setUp(() {
      usecase = InsertProductUsecase(mockRepository);
    });

    test('should insert a product through repository', () async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
      );
      final params = InsertProductParams(product);

      // Act
      await usecase(params);

      // Assert
      expect(mockRepository.insertCalled, true);
      expect(mockRepository.lastInsertedProduct, product);
    });

    test('should handle multiple product insertions', () async {
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
      await usecase(InsertProductParams(product1));
      await usecase(InsertProductParams(product2));

      // Assert
      final retrieved1 = await mockRepository.getProduct('1');
      final retrieved2 = await mockRepository.getProduct('2');
      expect(retrieved1, product1);
      expect(retrieved2, product2);
    });

    test('InsertProductParams should be equal when products are equal', () {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Product',
        description: 'Description',
        price: 50.0,
      );
      final params1 = InsertProductParams(product);
      final params2 = InsertProductParams(product);

      // Act & Assert
      expect(params1, equals(params2));
      expect(params1.hashCode, equals(params2.hashCode));
    });
  });

  group('UpdateProductUsecase Tests', () {
    late UpdateProductUsecase usecase;

    setUp(() {
      usecase = UpdateProductUsecase(mockRepository);
    });

    test('should update an existing product through repository', () async {
      // Arrange
      final originalProduct = Product(
        id: '1',
        name: 'Original Product',
        description: 'Original Description',
        price: 50.0,
      );
      await mockRepository.insertProduct(originalProduct);

      final updatedProduct = originalProduct.copyWith(
        name: 'Updated Product',
        price: 75.0,
      );
      final params = UpdateProductParams(updatedProduct);

      // Act
      await usecase(params);

      // Assert
      expect(mockRepository.updateCalled, true);
      expect(mockRepository.lastUpdatedProduct, updatedProduct);
    });

    test('should throw error when updating non-existent product', () async {
      // Arrange
      final product = Product(
        id: '999',
        name: 'Non-existent Product',
        description: 'Description',
        price: 50.0,
      );
      final params = UpdateProductParams(product);

      // Act & Assert
      expect(
        () => usecase(params),
        throwsA(isA<StateError>()),
      );
    });

    test('UpdateProductParams should be equal when products are equal', () {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Product',
        description: 'Description',
        price: 50.0,
      );
      final params1 = UpdateProductParams(product);
      final params2 = UpdateProductParams(product);

      // Act & Assert
      expect(params1, equals(params2));
      expect(params1.hashCode, equals(params2.hashCode));
    });
  });

  group('DeleteProductUsecase Tests', () {
    late DeleteProductUsecase usecase;

    setUp(() {
      usecase = DeleteProductUsecase(mockRepository);
    });

    test('should delete a product through repository', () async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Product to Delete',
        description: 'Description',
        price: 50.0,
      );
      await mockRepository.insertProduct(product);

      final params = DeleteProductParams('1');

      // Act
      await usecase(params);

      // Assert
      expect(mockRepository.deleteCalled, true);
      expect(mockRepository.lastDeletedId, '1');
    });

    test('should throw error when deleting non-existent product', () async {
      // Arrange
      final params = DeleteProductParams('999');

      // Act & Assert
      expect(
        () => usecase(params),
        throwsA(isA<StateError>()),
      );
    });

    test('should verify product is removed after deletion', () async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Product',
        description: 'Description',
        price: 50.0,
      );
      await mockRepository.insertProduct(product);

      // Act
      await usecase(DeleteProductParams('1'));

      // Assert
      final retrieved = await mockRepository.getProduct('1');
      expect(retrieved, isNull);
    });

    test('DeleteProductParams should be equal when IDs are equal', () {
      // Arrange
      final params1 = DeleteProductParams('1');
      final params2 = DeleteProductParams('1');

      // Act & Assert
      expect(params1, equals(params2));
      expect(params1.hashCode, equals(params2.hashCode));
    });
  });

  group('GetProductUsecase Tests', () {
    late GetProductUsecase usecase;

    setUp(() {
      usecase = GetProductUsecase(mockRepository);
    });

    test('should retrieve an existing product through repository', () async {
      // Arrange
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
      );
      await mockRepository.insertProduct(product);

      final params = GetProductParams('1');

      // Act
      final result = await usecase(params);

      // Assert
      expect(mockRepository.getCalled, true);
      expect(mockRepository.lastRetrievedId, '1');
      expect(result, product);
    });

    test('should return null when product does not exist', () async {
      // Arrange
      final params = GetProductParams('999');

      // Act
      final result = await usecase(params);

      // Assert
      expect(result, isNull);
    });

    test('should retrieve correct product from multiple products', () async {
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
      await mockRepository.insertProduct(product1);
      await mockRepository.insertProduct(product2);

      // Act
      final result = await usecase(GetProductParams('2'));

      // Assert
      expect(result, product2);
    });

    test('GetProductParams should be equal when IDs are equal', () {
      // Arrange
      final params1 = GetProductParams('1');
      final params2 = GetProductParams('1');

      // Act & Assert
      expect(params1, equals(params2));
      expect(params1.hashCode, equals(params2.hashCode));
    });
  });

  group('Integration Tests - Use Cases Together', () {
    late InsertProductUsecase insertUsecase;
    late UpdateProductUsecase updateUsecase;
    late DeleteProductUsecase deleteUsecase;
    late GetProductUsecase getUsecase;

    setUp(() {
      insertUsecase = InsertProductUsecase(mockRepository);
      updateUsecase = UpdateProductUsecase(mockRepository);
      deleteUsecase = DeleteProductUsecase(mockRepository);
      getUsecase = GetProductUsecase(mockRepository);
    });

    test('should complete full CRUD cycle', () async {
      // Insert
      final product = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
      );
      await insertUsecase(InsertProductParams(product));

      // Read
      var retrieved = await getUsecase(GetProductParams('1'));
      expect(retrieved, product);

      // Update
      final updatedProduct = product.copyWith(name: 'Updated Product');
      await updateUsecase(UpdateProductParams(updatedProduct));
      retrieved = await getUsecase(GetProductParams('1'));
      expect(retrieved?.name, 'Updated Product');

      // Delete
      await deleteUsecase(DeleteProductParams('1'));
      retrieved = await getUsecase(GetProductParams('1'));
      expect(retrieved, isNull);
    });

    test('should handle multiple products in sequence', () async {
      // Insert multiple products
      for (int i = 1; i <= 3; i++) {
        final product = Product(
          id: '$i',
          name: 'Product $i',
          description: 'Description $i',
          price: i * 25.0,
        );
        await insertUsecase(InsertProductParams(product));
      }

      // Verify all products exist
      for (int i = 1; i <= 3; i++) {
        final product = await getUsecase(GetProductParams('$i'));
        expect(product, isNotNull);
        expect(product?.name, 'Product $i');
      }

      // Update middle product
      final updatedProduct = Product(
        id: '2',
        name: 'Updated Product 2',
        description: 'Updated Description 2',
        price: 100.0,
      );
      await updateUsecase(UpdateProductParams(updatedProduct));

      // Verify update
      final retrieved = await getUsecase(GetProductParams('2'));
      expect(retrieved?.name, 'Updated Product 2');
      expect(retrieved?.price, 100.0);

      // Delete first product
      await deleteUsecase(DeleteProductParams('1'));

      // Verify deletion
      final deleted = await getUsecase(GetProductParams('1'));
      expect(deleted, isNull);

      // Verify others still exist
      final product2 = await getUsecase(GetProductParams('2'));
      final product3 = await getUsecase(GetProductParams('3'));
      expect(product2, isNotNull);
      expect(product3, isNotNull);
    });
  });
}

