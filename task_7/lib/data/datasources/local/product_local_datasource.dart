import '../../../domain/entities/product.dart';

/// Abstract interface for local product data operations
/// 
/// This interface defines the contract for managing product data in local
/// storage (e.g., SQLite, Hive, SharedPreferences, Isar).
/// 
/// The local data source is responsible for:
/// - Caching products for offline access
/// - Providing fast data retrieval without network calls
/// - Maintaining data consistency with remote source
/// - Managing storage lifecycle (insertion, updates, deletion)
/// 
/// Following Clean Architecture, this interface belongs to the data layer
/// and is implemented by concrete classes that handle actual storage operations.
/// 
/// Example implementation:
/// ```dart
/// class ProductLocalDataSourceImpl implements ProductLocalDataSource {
///   final Database database;
///   
///   ProductLocalDataSourceImpl(this.database);
///   
///   @override
///   Future<List<Product>> getCachedProducts() async {
///     final maps = await database.query('products');
///     return maps.map((map) => Product.fromJson(map)).toList();
///   }
/// }
/// ```
abstract class ProductLocalDataSource {
  /// Retrieves all cached products from local storage
  /// 
  /// Fetches all products that have been previously cached in the local
  /// database. This method provides instant access to product data without
  /// requiring a network connection.
  /// 
  /// Returns a [Future] containing a list of [Product] objects from cache.
  /// The list will be empty if no products have been cached yet.
  /// 
  /// Throws:
  ///   - [CacheException] if there's an error reading from local storage
  ///   - [DatabaseException] if the database is corrupted or inaccessible
  Future<List<Product>> getCachedProducts();

  /// Retrieves a specific cached product by ID from local storage
  /// 
  /// Fetches a single product from the local cache using its unique identifier.
  /// This provides fast access to frequently accessed products.
  /// 
  /// Parameters:
  ///   - [id]: The unique identifier of the product to retrieve from cache
  /// 
  /// Returns a [Future] that resolves to:
  ///   - The cached [Product] object if found
  ///   - null if the product is not in the cache
  /// 
  /// Throws:
  ///   - [CacheException] if there's an error reading from local storage
  Future<Product?> getCachedProductById(String id);

  /// Caches a product in local storage
  /// 
  /// Stores a product in the local database for offline access. If a product
  /// with the same ID already exists, it should be replaced (upsert behavior).
  /// 
  /// Parameters:
  ///   - [product]: The product object to cache locally
  /// 
  /// Returns a [Future] that completes when the product is successfully cached.
  /// 
  /// Throws:
  ///   - [CacheException] if there's an error writing to local storage
  ///   - [DatabaseException] if the database operation fails
  Future<void> cacheProduct(Product product);

  /// Caches multiple products in local storage
  /// 
  /// Stores a list of products in the local database efficiently. This is
  /// typically used after fetching products from the remote API.
  /// 
  /// Parameters:
  ///   - [products]: The list of products to cache locally
  /// 
  /// Returns a [Future] that completes when all products are successfully cached.
  /// 
  /// Throws:
  ///   - [CacheException] if there's an error writing to local storage
  Future<void> cacheProducts(List<Product> products);

  /// Updates a cached product in local storage
  /// 
  /// Modifies an existing product in the local cache. This should be called
  /// after successfully updating a product on the remote server.
  /// 
  /// Parameters:
  ///   - [product]: The product object with updated data
  /// 
  /// Returns a [Future] that completes when the cache is successfully updated.
  /// 
  /// Throws:
  ///   - [CacheException] if there's an error updating local storage
  ///   - [NotFoundException] if the product doesn't exist in cache
  Future<void> updateCachedProduct(Product product);

  /// Deletes a cached product from local storage
  /// 
  /// Removes a product from the local cache. This should be called after
  /// successfully deleting a product from the remote server.
  /// 
  /// Parameters:
  ///   - [id]: The unique identifier of the product to remove from cache
  /// 
  /// Returns a [Future] that completes when the product is successfully
  /// removed from cache.
  /// 
  /// Throws:
  ///   - [CacheException] if there's an error deleting from local storage
  Future<void> deleteCachedProduct(String id);

  /// Clears all cached products from local storage
  /// 
  /// Removes all products from the local cache. This is useful for:
  /// - Logging out users
  /// - Clearing stale data
  /// - Resetting the app state
  /// 
  /// Returns a [Future] that completes when the cache is successfully cleared.
  /// 
  /// Throws:
  ///   - [CacheException] if there's an error clearing local storage
  Future<void> clearCache();
}

