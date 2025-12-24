import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:product_manager/core/error/exceptions.dart';
import 'package:product_manager/data/datasources/remote/product_remote_datasource_impl.dart';
import 'package:product_manager/domain/entities/product.dart';

/// Mock HTTP client for testing
class MockHttpClient extends http.BaseClient {
  http.Response? _response;
  Exception? _exception;

  void setResponse(http.Response response) {
    _response = response;
    _exception = null;
  }

  void setException(Exception exception) {
    _exception = exception;
    _response = null;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (_exception != null) {
      throw _exception!;
    }
    if (_response != null) {
      return Future.value(http.StreamedResponse(
        Stream.value(utf8.encode(_response!.body)),
        _response!.statusCode,
        headers: _response!.headers,
        reasonPhrase: _response!.reasonPhrase,
      ));
    }
    throw Exception('Mock response not set');
  }
}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockClient);
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
  ];

  group('ProductRemoteDataSourceImpl', () {
    group('fetchAllProducts', () {
      test('should return list of products when API call is successful', () async {
        // Arrange
        final jsonList = testProducts.map((p) => p.toJson()).toList();
        final responseBody = json.encode(jsonList);
        mockClient.setResponse(
          http.Response(responseBody, 200),
        );

        // Act
        final result = await dataSource.fetchAllProducts();

        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, equals(2));
        expect(result[0].id, equals('1'));
        expect(result[0].name, equals('Product 1'));
        expect(result[1].id, equals('2'));
        expect(result[1].name, equals('Product 2'));
      });

      test('should return empty list when API returns empty array', () async {
        // Arrange
        mockClient.setResponse(
          http.Response(json.encode([]), 200),
        );

        // Act
        final result = await dataSource.fetchAllProducts();

        // Assert
        expect(result, isA<List<Product>>());
        expect(result, isEmpty);
      });

      test('should throw ServerException when API returns non-200 status', () async {
        // Arrange
        mockClient.setResponse(
          http.Response('Server Error', 500),
        );

        // Act & Assert
        expect(
          () => dataSource.fetchAllProducts(),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw ServerException when API returns 400 status', () async {
        // Arrange
        mockClient.setResponse(
          http.Response('Bad Request', 400),
        );

        // Act & Assert
        expect(
          () => dataSource.fetchAllProducts(),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw ServerException when response body is invalid JSON', () async {
        // Arrange
        mockClient.setResponse(
          http.Response('Invalid JSON', 200),
        );

        // Act & Assert
        expect(
          () => dataSource.fetchAllProducts(),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw NetworkException when network error occurs', () async {
        // Arrange
        mockClient.setException(Exception('Network error'));

        // Act & Assert
        expect(
          () => dataSource.fetchAllProducts(),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('fetchProductById', () {
      test('should return product when API call is successful', () async {
        // Arrange
        final productJson = testProducts[0].toJson();
        mockClient.setResponse(
          http.Response(json.encode(productJson), 200),
        );

        // Act
        final result = await dataSource.fetchProductById('1');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, equals('1'));
        expect(result.name, equals('Product 1'));
        expect(result.description, equals('Description 1'));
        expect(result.price, equals(50.0));
      });

      test('should return null when product not found (404)', () async {
        // Arrange
        mockClient.setResponse(
          http.Response('Not Found', 404),
        );

        // Act
        final result = await dataSource.fetchProductById('999');

        // Assert
        expect(result, isNull);
      });

      test('should throw ServerException when API returns non-200/404 status', () async {
        // Arrange
        mockClient.setResponse(
          http.Response('Server Error', 500),
        );

        // Act & Assert
        expect(
          () => dataSource.fetchProductById('1'),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw ServerException when response body is invalid JSON', () async {
        // Arrange
        mockClient.setResponse(
          http.Response('Invalid JSON', 200),
        );

        // Act & Assert
        expect(
          () => dataSource.fetchProductById('1'),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw NetworkException when network error occurs', () async {
        // Arrange
        mockClient.setException(Exception('Network error'));

        // Act & Assert
        expect(
          () => dataSource.fetchProductById('1'),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('addProduct', () {
      test('should successfully add product when API call is successful', () async {
        // Arrange
        final newProduct = testProducts[0];
        mockClient.setResponse(
          http.Response('Created', 201),
        );

        // Act
        await dataSource.addProduct(newProduct);

        // Assert - No exception should be thrown
        expect(() => dataSource.addProduct(newProduct), returnsNormally);
      });

      test('should successfully add product when API returns 200 status', () async {
        // Arrange
        final newProduct = testProducts[0];
        mockClient.setResponse(
          http.Response('OK', 200),
        );

        // Act
        await dataSource.addProduct(newProduct);

        // Assert - No exception should be thrown
        expect(() => dataSource.addProduct(newProduct), returnsNormally);
      });

      test('should throw ServerException when API returns non-2xx status', () async {
        // Arrange
        final newProduct = testProducts[0];
        mockClient.setResponse(
          http.Response('Bad Request', 400),
        );

        // Act & Assert
        expect(
          () => dataSource.addProduct(newProduct),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw ServerException when API returns 500 status', () async {
        // Arrange
        final newProduct = testProducts[0];
        mockClient.setResponse(
          http.Response('Server Error', 500),
        );

        // Act & Assert
        expect(
          () => dataSource.addProduct(newProduct),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw NetworkException when network error occurs', () async {
        // Arrange
        final newProduct = testProducts[0];
        mockClient.setException(Exception('Network error'));

        // Act & Assert
        expect(
          () => dataSource.addProduct(newProduct),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('editProduct', () {
      test('should successfully update product when API call is successful', () async {
        // Arrange
        final updatedProduct = testProducts[0].copyWith(name: 'Updated Product 1');
        mockClient.setResponse(
          http.Response('OK', 200),
        );

        // Act
        await dataSource.editProduct(updatedProduct);

        // Assert - No exception should be thrown
        expect(() => dataSource.editProduct(updatedProduct), returnsNormally);
      });

      test('should successfully update product when API returns 204 status', () async {
        // Arrange
        final updatedProduct = testProducts[0];
        mockClient.setResponse(
          http.Response('', 204),
        );

        // Act
        await dataSource.editProduct(updatedProduct);

        // Assert - No exception should be thrown
        expect(() => dataSource.editProduct(updatedProduct), returnsNormally);
      });

      test('should throw ServerException when product not found (404)', () async {
        // Arrange
        final updatedProduct = testProducts[0];
        mockClient.setResponse(
          http.Response('Not Found', 404),
        );

        // Act & Assert
        expect(
          () => dataSource.editProduct(updatedProduct),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw ServerException when API returns non-2xx status', () async {
        // Arrange
        final updatedProduct = testProducts[0];
        mockClient.setResponse(
          http.Response('Bad Request', 400),
        );

        // Act & Assert
        expect(
          () => dataSource.editProduct(updatedProduct),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw NetworkException when network error occurs', () async {
        // Arrange
        final updatedProduct = testProducts[0];
        mockClient.setException(Exception('Network error'));

        // Act & Assert
        expect(
          () => dataSource.editProduct(updatedProduct),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('removeProduct', () {
      test('should successfully delete product when API call is successful', () async {
        // Arrange
        mockClient.setResponse(
          http.Response('OK', 200),
        );

        // Act
        await dataSource.removeProduct('1');

        // Assert - No exception should be thrown
        expect(() => dataSource.removeProduct('1'), returnsNormally);
      });

      test('should successfully delete product when API returns 204 status', () async {
        // Arrange
        mockClient.setResponse(
          http.Response('', 204),
        );

        // Act
        await dataSource.removeProduct('1');

        // Assert - No exception should be thrown
        expect(() => dataSource.removeProduct('1'), returnsNormally);
      });

      test('should throw ServerException when product not found (404)', () async {
        // Arrange
        mockClient.setResponse(
          http.Response('Not Found', 404),
        );

        // Act & Assert
        expect(
          () => dataSource.removeProduct('999'),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw ServerException when API returns non-2xx status', () async {
        // Arrange
        mockClient.setResponse(
          http.Response('Server Error', 500),
        );

        // Act & Assert
        expect(
          () => dataSource.removeProduct('1'),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw NetworkException when network error occurs', () async {
        // Arrange
        mockClient.setException(Exception('Network error'));

        // Act & Assert
        expect(
          () => dataSource.removeProduct('1'),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('JSON Serialization', () {
      test('should correctly serialize and deserialize products', () async {
        // Arrange
        final product = Product(
          id: '123',
          name: 'Test Product',
          description: 'Test Description',
          price: 99.99,
          imageUrl: 'https://example.com/image.jpg',
        );
        final productJson = product.toJson();
        mockClient.setResponse(
          http.Response(json.encode(productJson), 200),
        );

        // Act
        final result = await dataSource.fetchProductById('123');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, equals('123'));
        expect(result.name, equals('Test Product'));
        expect(result.description, equals('Test Description'));
        expect(result.price, equals(99.99));
        expect(result.imageUrl, equals('https://example.com/image.jpg'));
      });

      test('should handle products with missing optional fields', () async {
        // Arrange
        final productJson = {
          'id': '1',
          'name': 'Product',
          'description': 'Description',
          'price': 50.0,
          // imageUrl is optional
        };
        mockClient.setResponse(
          http.Response(json.encode(productJson), 200),
        );

        // Act
        final result = await dataSource.fetchProductById('1');

        // Assert
        expect(result, isNotNull);
        expect(result!.imageUrl, equals('')); // Default value
      });
    });
  });
}

