import '../../../domain/entities/product.dart';

/// Abstract interface for remote product data operations
/// 
/// This interface defines the contract for fetching and manipulating product
/// data from a remote source (e.g., REST API, GraphQL, Firebase).
/// 
/// The remote data source is responsible for:
/// - Making network requests to the backend API
/// - Handling HTTP responses and errors
/// - Serializing/deserializing data to/from JSON
/// - Managing authentication tokens if required
/// 
/// Following Clean Architecture, this interface belongs to the data layer
/// and is implemented by concrete classes that handle actual network calls.
/// 
/// Example implementation:
/// ```dart
/// class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
///   final http.Client client;
///   
///   ProductRemoteDataSourceImpl(this.client);
///   
///   @override
///   Future<List<Product>> fetchAllProducts() async {
///     final response = await client.get(Uri.parse('$baseUrl/products'));
///     // Parse and return products...
///   }
/// }
/// ```
abstract class ProductRemoteDataSource {
  /// Fetches all products from the remote API
  /// 
  /// Makes a network request to retrieve all available products from
  /// the backend server.
  /// 
  /// Returns a [Future] containing a list of [Product] objects.
  /// The list will be empty if no products are available on the server.
  /// 
  /// Throws:
  ///   - [NetworkException] if there's no internet connection
  ///   - [ServerException] if the server returns an error (4xx, 5xx)
  ///   - [ParseException] if the response cannot be parsed
  Future<List<Product>> fetchAllProducts();

  /// Fetches a specific product by ID from the remote API
  /// 
  /// Makes a network request to retrieve a single product using its
  /// unique identifier.
  /// 
  /// Parameters:
  ///   - [id]: The unique identifier of the product to fetch
  /// 
  /// Returns a [Future] that resolves to:
  ///   - The [Product] object if found on the server
  ///   - null if the product doesn't exist (404 response)
  /// 
  /// Throws:
  ///   - [NetworkException] if there's no internet connection
  ///   - [ServerException] if the server returns an error
  ///   - [ParseException] if the response cannot be parsed
  Future<Product?> fetchProductById(String id);

  /// Adds a new product to the remote API
  /// 
  /// Makes a POST request to create a new product on the backend server.
  /// The product data is typically sent as JSON in the request body.
  /// 
  /// Parameters:
  ///   - [product]: The product object to add to the server
  /// 
  /// Returns a [Future] that completes when the product is successfully
  /// created on the server.
  /// 
  /// Throws:
  ///   - [NetworkException] if there's no internet connection
  ///   - [ServerException] if the server returns an error
  ///   - [ValidationException] if the product data is invalid
  Future<void> addProduct(Product product);

  /// Updates an existing product on the remote API
  /// 
  /// Makes a PUT or PATCH request to modify an existing product on
  /// the backend server.
  /// 
  /// Parameters:
  ///   - [product]: The product object with updated data. Must have
  ///     a valid ID that exists on the server.
  /// 
  /// Returns a [Future] that completes when the product is successfully
  /// updated on the server.
  /// 
  /// Throws:
  ///   - [NetworkException] if there's no internet connection
  ///   - [ServerException] if the server returns an error
  ///   - [NotFoundException] if the product doesn't exist on the server
  ///   - [ValidationException] if the product data is invalid
  Future<void> editProduct(Product product);

  /// Removes a product from the remote API
  /// 
  /// Makes a DELETE request to permanently remove a product from the
  /// backend server.
  /// 
  /// Parameters:
  ///   - [id]: The unique identifier of the product to remove
  /// 
  /// Returns a [Future] that completes when the product is successfully
  /// deleted from the server.
  /// 
  /// Throws:
  ///   - [NetworkException] if there's no internet connection
  ///   - [ServerException] if the server returns an error
  ///   - [NotFoundException] if the product doesn't exist on the server
  Future<void> removeProduct(String id);
}

