import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/core/network/network_info.dart';
import 'package:product_manager/data/datasources/local/product_local_datasource.dart';
import 'package:product_manager/data/datasources/remote/product_remote_datasource.dart';
import 'package:product_manager/data/repositories/product_repository_impl.dart';
import 'package:product_manager/domain/entities/product.dart';

/// Mock implementation of NetworkInfo for testing
class MockNetworkInfo implements NetworkInfo {
  bool _isConnected = true;

  void setConnected(bool connected) {
    _isConnected = connected;
  }

  @override
  Future<bool> get isConnected async => _isConnected;
}

/// Mock implementation of ProductRemoteDataSource for testing
class MockProductRemoteDataSource implements ProductRemoteDataSource {
  final Map<String, Product> _remoteProducts = {};
  bool _shouldThrowError = false;

  void setThrowError(bool shouldThrow) {
    _shouldThrowError = shouldThrow;
  }

  void reset() {
    _remoteProducts.clear();
    _shouldThrowError = false;
  }

  @override
  Future<List<Product>> fetchAllProducts() async {
    if (_shouldThrowError) {
      throw Exception('Remote server error');
    }
    return _remoteProducts.values.toList();
  }

  @override
  Future<Product?> fetchProductById(String id) async {
    if (_shouldThrowError) {
      throw Exception('Remote server error');
    }
    return _remoteProducts[id];
  }

  @override
  Future<void> addProduct(Product product) async {
    if (_shouldThrowError) {
      throw Exception('Remote server error');
    }
    _remoteProducts[product.id] = product;
  }

  @override
  Future<void> editProduct(Product product) async {
    if (_shouldThrowError) {
      throw Exception('Remote server error');
    }
    if (!_remoteProducts.containsKey(product.id)) {
      throw Exception('Product not found on server');
    }
    _remoteProducts[product.id] = product;
  }

  @override
  Future<void> removeProduct(String id) async {
    if (_shouldThrowError) {
      throw Exception('Remote server error');
    }
    if (!_remoteProducts.containsKey(id)) {
      throw Exception('Product not found on server');
    }
    _remoteProducts.remove(id);
  }
}

/// Mock implementation of ProductLocalDataSource for testing
class MockProductLocalDataSource implements ProductLocalDataSource {
  final Map<String, Product> _cachedProducts = {};

  void reset() {
    _cachedProducts.clear();
  }

  @override
  Future<List<Product>> getCachedProducts() async {
    return _cachedProducts.values.toList();
  }

  @override
  Future<Product?> getCachedProductById(String id) async {
    return _cachedProducts[id];
  }

  @override
  Future<void> cacheProduct(Product product) async {
    _cachedProducts[product.id] = product;
  }

  @override
  Future<void> cacheProducts(List<Product> products) async {
    for (final product in products) {
      _cachedProducts[product.id] = product;
    }
  }

  @override
  Future<void> updateCachedProduct(Product product) async {
    if (!_cachedProducts.containsKey(product.id)) {
      throw Exception('Product not found in cache');
    }
    _cachedProducts[product.id] = product;
  }

  @override
  Future<void> deleteCachedProduct(String id) async {
    if (!_cachedProducts.containsKey(id)) {
      throw Exception('Product not found in cache');
    }
    _cachedProducts.remove(id);
  }

  @override
  Future<void> clearCache() async {
    _cachedProducts.clear();
  }
}

void main() {
  late ProductRepositoryImpl repository;
  late MockNetworkInfo mockNetworkInfo;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('ProductRepositoryImpl - getAllProducts', () {
    final testProducts = [
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

    test('should return remote data when network is available', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      await mockRemoteDataSource.addProduct(testProducts[0]);
      await mockRemoteDataSource.addProduct(testProducts[1]);

      // Act
      final result = await repository.getAllProducts();

      // Assert
      expect(result, testProducts);
    });

    test('should cache remote data when network is available', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      await mockRemoteDataSource.addProduct(testProducts[0]);
      await mockRemoteDataSource.addProduct(testProducts[1]);

      // Act
      await repository.getAllProducts();

      // Assert - verify data was cached
      final cached = await mockLocalDataSource.getCachedProducts();
      expect(cached, testProducts);
    });

    test('should return cached data when network is unavailable', () async {
      // Arrange
      mockNetworkInfo.setConnected(false);
      await mockLocalDataSource.cacheProducts(testProducts);

      // Act
      final result = await repository.getAllProducts();

      // Assert
      expect(result, testProducts);
    });

    test('should return cached data when remote fails', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      mockRemoteDataSource.setThrowError(true);
      await mockLocalDataSource.cacheProducts(testProducts);

      // Act
      final result = await repository.getAllProducts();

      // Assert - should fallback to cache
      expect(result, testProducts);
    });

    test('should return empty list when offline and cache is empty', () async {
      // Arrange
      mockNetworkInfo.setConnected(false);

      // Act
        final result = await repository.getAllProducts();

      // Assert
      expect(result, isEmpty);
    });
  });

  group('ProductRepositoryImpl - getProductById', () {
    final testProduct = Product(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      price: 99.99,
    );

    test('should return remote product and cache it when online', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      await mockRemoteDataSource.addProduct(testProduct);

      // Act
      final result = await repository.getProductById('1');

      // Assert
      expect(result, testProduct);
      
      // Verify it was cached
      final cached = await mockLocalDataSource.getCachedProductById('1');
      expect(cached, testProduct);
    });

    test('should return cached product when offline', () async {
      // Arrange
      mockNetworkInfo.setConnected(false);
      await mockLocalDataSource.cacheProduct(testProduct);

      // Act
      final result = await repository.getProductById('1');

      // Assert
      expect(result, testProduct);
    });

    test('should return cached product when remote fails', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      mockRemoteDataSource.setThrowError(true);
      await mockLocalDataSource.cacheProduct(testProduct);

      // Act
      final result = await repository.getProductById('1');

      // Assert
      expect(result, testProduct);
    });

    test('should return null when product not found anywhere', () async {
      // Arrange
      mockNetworkInfo.setConnected(false);

      // Act
      final result = await repository.getProductById('999');

      // Assert
      expect(result, isNull);
    });
  });

  group('ProductRepositoryImpl - createProduct', () {
    final testProduct = Product(
      id: '1',
      name: 'New Product',
      description: 'New Description',
      price: 150.0,
    );

    test('should create product remotely and cache it when online', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);

      // Act
      await repository.createProduct(testProduct);

      // Assert - verify it was created remotely
      final remote = await mockRemoteDataSource.fetchProductById('1');
      expect(remote, testProduct);

      // Assert - verify it was cached
      final cached = await mockLocalDataSource.getCachedProductById('1');
      expect(cached, testProduct);
    });

    test('should cache product and throw exception when offline', () async {
      // Arrange
      mockNetworkInfo.setConnected(false);

      // Act & Assert
      await expectLater(
        () => repository.createProduct(testProduct),
        throwsA(isA<Exception>()),
      );

      // Verify it was still cached locally
      final cached = await mockLocalDataSource.getCachedProductById('1');
      expect(cached, testProduct);
    });

    test('should cache product and rethrow when remote fails', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      mockRemoteDataSource.setThrowError(true);

      // Act & Assert
      await expectLater(
        () => repository.createProduct(testProduct),
        throwsA(isA<Exception>()),
      );

      // Verify it was cached despite remote failure
      final cached = await mockLocalDataSource.getCachedProductById('1');
      expect(cached, testProduct);
    });
  });

  group('ProductRepositoryImpl - updateProduct', () {
    final originalProduct = Product(
      id: '1',
      name: 'Original Product',
      description: 'Original Description',
      price: 50.0,
    );

    final updatedProduct = Product(
      id: '1',
      name: 'Updated Product',
      description: 'Updated Description',
      price: 75.0,
    );

    test('should update product remotely and in cache when online', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      await mockRemoteDataSource.addProduct(originalProduct);
      await mockLocalDataSource.cacheProduct(originalProduct);

      // Act
      await repository.updateProduct(updatedProduct);

      // Assert - verify remote was updated
      final remote = await mockRemoteDataSource.fetchProductById('1');
      expect(remote, updatedProduct);

      // Assert - verify cache was updated
      final cached = await mockLocalDataSource.getCachedProductById('1');
      expect(cached, updatedProduct);
    });

    test('should update cache and throw exception when offline', () async {
      // Arrange
      mockNetworkInfo.setConnected(false);
      await mockLocalDataSource.cacheProduct(originalProduct);

      // Act & Assert
      await expectLater(
        () => repository.updateProduct(updatedProduct),
        throwsA(isA<Exception>()),
      );

      // Verify cache was updated
      final cached = await mockLocalDataSource.getCachedProductById('1');
      expect(cached, updatedProduct);
    });

    test('should update cache and rethrow when remote fails', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      await mockRemoteDataSource.addProduct(originalProduct);
      await mockLocalDataSource.cacheProduct(originalProduct);
      mockRemoteDataSource.setThrowError(true);

      // Act & Assert
      await expectLater(
        () => repository.updateProduct(updatedProduct),
        throwsA(isA<Exception>()),
      );

      // Verify cache was updated despite remote failure
      final cached = await mockLocalDataSource.getCachedProductById('1');
      expect(cached, updatedProduct);
    });
  });

  group('ProductRepositoryImpl - deleteProduct', () {
    final testProduct = Product(
      id: '1',
      name: 'Product to Delete',
      description: 'Description',
      price: 50.0,
    );

    test('should delete product remotely and from cache when online', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      await mockRemoteDataSource.addProduct(testProduct);
      await mockLocalDataSource.cacheProduct(testProduct);

      // Act
      await repository.deleteProduct('1');

      // Assert - verify remote deletion
      final remote = await mockRemoteDataSource.fetchProductById('1');
      expect(remote, isNull);

      // Assert - verify cache deletion
      final cached = await mockLocalDataSource.getCachedProductById('1');
      expect(cached, isNull);
    });

    test('should delete from cache and throw exception when offline', () async {
      // Arrange
      mockNetworkInfo.setConnected(false);
      await mockLocalDataSource.cacheProduct(testProduct);

      // Act & Assert
      await expectLater(
        () => repository.deleteProduct('1'),
        throwsA(isA<Exception>()),
      );

      // Verify cache deletion
      final cached = await mockLocalDataSource.getCachedProductById('1');
      expect(cached, isNull);
    });

    test('should delete from cache and rethrow when remote fails', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      await mockRemoteDataSource.addProduct(testProduct);
      await mockLocalDataSource.cacheProduct(testProduct);
      mockRemoteDataSource.setThrowError(true);

      // Act & Assert
      await expectLater(
        () => repository.deleteProduct('1'),
        throwsA(isA<Exception>()),
      );

      // Verify cache deletion despite remote failure
      final cached = await mockLocalDataSource.getCachedProductById('1');
      expect(cached, isNull);
    });
  });

  group('ProductRepositoryImpl - Integration Scenarios', () {
    test('should handle full CRUD cycle when online', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);

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

      // Act & Assert - Create
      await repository.createProduct(product1);
      await repository.createProduct(product2);

      var allProducts = await repository.getAllProducts();
      expect(allProducts.length, 2);

      // Act & Assert - Read
      final retrieved = await repository.getProductById('1');
      expect(retrieved, product1);

      // Act & Assert - Update
      final updated = product1.copyWith(name: 'Updated Product 1');
      await repository.updateProduct(updated);
      
      final retrievedUpdated = await repository.getProductById('1');
      expect(retrievedUpdated?.name, 'Updated Product 1');

      // Act & Assert - Delete
      await repository.deleteProduct('1');
      
      allProducts = await repository.getAllProducts();
      expect(allProducts.length, 1);
      expect(allProducts[0].id, '2');
    });

    test('should handle network switching mid-operation', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      
      final product = Product(
        id: '1',
        name: 'Product',
        description: 'Description',
        price: 50.0,
      );

      // Act - Create while online
      await repository.createProduct(product);

      // Switch to offline
      mockNetworkInfo.setConnected(false);

      // Act - Read while offline (should get from cache)
      final retrieved = await repository.getProductById('1');

      // Assert
      expect(retrieved, product);
    });

    test('should maintain cache consistency across operations', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);

      final products = [
        Product(id: '1', name: 'P1', description: 'D1', price: 10.0),
        Product(id: '2', name: 'P2', description: 'D2', price: 20.0),
        Product(id: '3', name: 'P3', description: 'D3', price: 30.0),
      ];

      // Add products
      for (final product in products) {
        await repository.createProduct(product);
      }

      // Get all (caches them)
      await repository.getAllProducts();

      // Switch to offline
      mockNetworkInfo.setConnected(false);

      // Should still be able to get all from cache
      final cachedProducts = await repository.getAllProducts();
      expect(cachedProducts.length, 3);

      // Should be able to get individual from cache
      for (final product in products) {
        final cached = await repository.getProductById(product.id);
        expect(cached, product);
      }
    });
  });

  group('ProductRepositoryImpl - Backward Compatibility', () {
    final testProduct = Product(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      price: 99.99,
    );

    test('insertProduct should delegate to createProduct', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);

      // Act
      await repository.insertProduct(testProduct);

      // Assert
      final remote = await mockRemoteDataSource.fetchProductById('1');
      expect(remote, testProduct);
    });

    test('getProduct should delegate to getProductById', () async {
      // Arrange
      mockNetworkInfo.setConnected(true);
      await mockRemoteDataSource.addProduct(testProduct);

      // Act
      final result = await repository.getProduct('1');

      // Assert
      expect(result, testProduct);
    });
  });
}
