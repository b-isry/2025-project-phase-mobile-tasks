import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/entities/product.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import 'product_remote_datasource.dart';

/// Implementation of ProductRemoteDataSource using HTTP client
/// 
/// This class handles all remote data operations for products by making
/// HTTP requests to the backend API. It follows Clean Architecture principles
/// by keeping business logic out and focusing solely on data fetching and
/// serialization/deserialization.
/// 
/// Error handling:
/// - Non-200 responses throw ServerException
/// - Network errors throw NetworkException
/// - JSON parsing errors throw ServerException
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  /// HTTP client for making network requests
  /// 
  /// Injected via constructor to allow for dependency injection and testing
  final http.Client client;

  /// Base URL for API requests
  /// 
  /// Can be overridden for testing or different environments
  final String baseUrl;

  /// Creates a new instance of ProductRemoteDataSourceImpl
  /// 
  /// Parameters:
  ///   - [client]: HTTP client instance (defaults to http.Client())
  ///   - [baseUrl]: Base URL for API (defaults to ApiConstants.baseUrl)
  ProductRemoteDataSourceImpl({
    http.Client? client,
    String? baseUrl,
  })  : client = client ?? http.Client(),
        baseUrl = baseUrl ?? ApiConstants.baseUrl;

  @override
  Future<List<Product>> fetchAllProducts() async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.productsEndpoint}');
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
        return jsonList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException();
      }
    } on ServerException {
      rethrow;
    } on FormatException {
      throw ServerException();
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  @override
  Future<Product?> fetchProductById(String id) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.productsEndpoint}/$id');
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
        return Product.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw ServerException();
      }
    } on ServerException {
      rethrow;
    } on FormatException {
      throw ServerException();
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.productsEndpoint}');
      final body = json.encode(product.toJson());
      final headers = {'Content-Type': 'application/json'};
      
      final response = await client.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        throw ServerException();
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  @override
  Future<void> editProduct(Product product) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.productsEndpoint}/${product.id}');
      final body = json.encode(product.toJson());
      final headers = {'Content-Type': 'application/json'};
      
      final response = await client.put(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else if (response.statusCode == 404) {
        throw ServerException();
      } else {
        throw ServerException();
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  @override
  Future<void> removeProduct(String id) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.productsEndpoint}/$id');
      final response = await client.delete(uri);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else if (response.statusCode == 404) {
        throw ServerException();
      } else {
        throw ServerException();
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }
}
