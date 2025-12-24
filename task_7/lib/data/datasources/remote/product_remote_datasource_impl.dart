import 'package:http/http.dart' as http;
import '../../../domain/entities/product.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/utils/http_client_helper.dart';
import '../../../core/utils/json_helper.dart';
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
    final uri = Uri.parse('$baseUrl${ApiConstants.productsEndpoint}');
    final response = await HttpClientHelper.get(client, uri);

    final jsonList = JsonHelper.decodeList(response.body);
    return JsonHelper.fromJsonList(jsonList, Product.fromJson);
  }

  @override
  Future<Product?> fetchProductById(String id) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConstants.productsEndpoint}/$id');
      final response = await client.get(uri);

      if (response.statusCode == 404) {
        return null;
      }

      if (!HttpClientHelper.isSuccessStatusCode(response.statusCode)) {
        throw ServerException();
      }

      final jsonData = JsonHelper.decodeMap(response.body);
      return Product.fromJson(jsonData);
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
  Future<void> addProduct(Product product) async {
    final uri = Uri.parse('$baseUrl${ApiConstants.productsEndpoint}');
    final body = product.toJson();
    
    await HttpClientHelper.post(client, uri, body: body);
  }

  @override
  Future<void> editProduct(Product product) async {
    final uri = Uri.parse('$baseUrl${ApiConstants.productsEndpoint}/${product.id}');
    final body = product.toJson();
    
    try {
      await HttpClientHelper.put(client, uri, body: body);
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
    final uri = Uri.parse('$baseUrl${ApiConstants.productsEndpoint}/$id');
    
    try {
      await HttpClientHelper.delete(client, uri);
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
