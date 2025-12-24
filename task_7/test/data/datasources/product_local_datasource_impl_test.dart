import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_manager/core/error/exceptions.dart';
import 'package:product_manager/core/constants/cache_constants.dart';
import 'package:product_manager/data/datasources/local/product_local_datasource_impl.dart';
import 'package:product_manager/domain/entities/product.dart';

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    // Initialize SharedPreferences with empty mock values
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    dataSource = ProductLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  });

  tearDown(() async {
    // Clear SharedPreferences after each test
    await sharedPreferences.clear();
  });

  final testProducts = [
    Product(
      id: '1',
      name: 'Product 1',
      description: 'Description 1',
      price: 50.0,
      imageUrl: 'https://example.com/image1.jpg',
    ),
    Product(
      id: '2',
      name: 'Product 2',
      description: 'Description 2',
      price: 75.0,
      imageUrl: 'https://example.com/image2.jpg',
    ),
    Product(
      id: '3',
      name: 'Product 3',
      description: 'Description 3',
      price: 100.0,
      imageUrl: 'https://example.com/image3.jpg',
    ),
  ];

  group('ProductLocalDataSourceImpl', () {
    group('cacheProducts', () {
      test('should save products to SharedPreferences', () async {
        // Act
        await dataSource.cacheProducts(testProducts);

        // Assert
        final cachedList = sharedPreferences.getStringList(CacheConstants.cachedProductsKey);
        expect(cachedList, isNotNull);
        expect(cachedList!.length, equals(3));
        
        // Verify data is stored correctly
        final decodedProducts = cachedList
            .map((jsonString) => Product.fromJson(json.decode(jsonString) as Map<String, dynamic>))
            .toList();
        expect(decodedProducts, equals(testProducts));
      });

      test('should verify data is stored under correct key', () async {
        // Act
        await dataSource.cacheProducts(testProducts);

        // Assert
        expect(
          sharedPreferences.containsKey(CacheConstants.cachedProductsKey),
          isTrue,
        );
      });
    });

    group('getCachedProducts', () {
      test('should return products from SharedPreferences when cache exists', () async {
        // Arrange - Preload SharedPreferences
        final jsonStringList = testProducts
            .map((product) => json.encode(product.toJson()))
            .toList();
        await sharedPreferences.setStringList(
          CacheConstants.cachedProductsKey,
          jsonStringList,
        );

        // Act
        final result = await dataSource.getCachedProducts();

        // Assert
        expect(result, equals(testProducts));
        expect(result.length, equals(3));
      });

      test('should throw CacheException when cache is empty', () async {
        // Act & Assert
        expect(
          () => dataSource.getCachedProducts(),
          throwsA(isA<CacheException>()),
        );
      });

      test('should throw CacheException when key does not exist', () async {
        // Ensure key doesn't exist
        await sharedPreferences.remove(CacheConstants.cachedProductsKey);

        // Act & Assert
        expect(
          () => dataSource.getCachedProducts(),
          throwsA(isA<CacheException>()),
        );
      });
    });

    group('cacheProduct', () {
      test('should cache a single product', () async {
        // Arrange
        final singleProduct = testProducts[0];

        // Act
        await dataSource.cacheProduct(singleProduct);

        // Assert
        final result = await dataSource.getCachedProducts();
        expect(result.length, equals(1));
        expect(result[0], equals(singleProduct));
      });

      test('should update existing product when caching with same ID', () async {
        // Arrange
        await dataSource.cacheProducts(testProducts);
        final updatedProduct = Product(
          id: '1',
          name: 'Updated Product 1',
          description: 'Updated Description 1',
          price: 60.0,
          imageUrl: 'https://example.com/updated_image1.jpg',
        );

        // Act
        await dataSource.cacheProduct(updatedProduct);

        // Assert
        final result = await dataSource.getCachedProducts();
        expect(result.length, equals(3)); // Still 3 products
        final cachedProduct = result.firstWhere((p) => p.id == '1');
        expect(cachedProduct.name, equals('Updated Product 1'));
      });
    });

    group('getCachedProductById', () {
      test('should return product when found', () async {
        // Arrange
        await dataSource.cacheProducts(testProducts);

        // Act
        final result = await dataSource.getCachedProductById('2');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, equals('2'));
        expect(result.name, equals('Product 2'));
      });

      test('should return null when product not found', () async {
        // Arrange
        await dataSource.cacheProducts(testProducts);

        // Act
        final result = await dataSource.getCachedProductById('999');

        // Assert
        expect(result, isNull);
      });
    });

    group('updateCachedProduct', () {
      test('should update existing product in cache', () async {
        // Arrange
        await dataSource.cacheProducts(testProducts);
        final updatedProduct = Product(
          id: '2',
          name: 'Updated Product 2',
          description: 'Updated Description 2',
          price: 80.0,
          imageUrl: 'https://example.com/updated_image2.jpg',
        );

        // Act
        await dataSource.updateCachedProduct(updatedProduct);

        // Assert
        final result = await dataSource.getCachedProducts();
        final updated = result.firstWhere((p) => p.id == '2');
        expect(updated.name, equals('Updated Product 2'));
        expect(updated.price, equals(80.0));
      });

      test('should throw CacheException when product does not exist', () async {
        // Arrange
        await dataSource.cacheProducts(testProducts);
        final nonExistentProduct = Product(
          id: '999',
          name: 'Non-existent Product',
          description: 'Description',
          price: 100.0,
        );

        // Act & Assert
        expect(
          () => dataSource.updateCachedProduct(nonExistentProduct),
          throwsA(isA<CacheException>()),
        );
      });
    });

    group('deleteCachedProduct', () {
      test('should remove product from cache', () async {
        // Arrange
        await dataSource.cacheProducts(testProducts);

        // Act
        await dataSource.deleteCachedProduct('2');

        // Assert
        final result = await dataSource.getCachedProducts();
        expect(result.length, equals(2));
        expect(result.any((p) => p.id == '2'), isFalse);
      });

      test('should remove key when last product is deleted', () async {
        // Arrange
        await dataSource.cacheProduct(testProducts[0]);

        // Act
        await dataSource.deleteCachedProduct('1');

        // Assert
        expect(
          sharedPreferences.containsKey(CacheConstants.cachedProductsKey),
          isFalse,
        );
      });
    });

    group('clearCache', () {
      test('should remove all cached products', () async {
        // Arrange
        await dataSource.cacheProducts(testProducts);

        // Act
        await dataSource.clearCache();

        // Assert
        expect(
          sharedPreferences.containsKey(CacheConstants.cachedProductsKey),
          isFalse,
        );
        expect(
          () => dataSource.getCachedProducts(),
          throwsA(isA<CacheException>()),
        );
      });
    });
  });
}

