import '../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/product_repository_contract.dart';
import '../datasources/local/product_local_datasource.dart';
import '../datasources/remote/product_remote_datasource.dart';

/// Production-ready implementation of ProductRepository following Clean Architecture
/// 
/// This repository implements a network-aware caching strategy:
/// - When online: Fetches from remote API and updates local cache
/// - When offline: Serves data from local cache
/// - Always keeps cache synchronized with remote when possible
/// 
/// The repository handles:
/// - Network connectivity detection
/// - Automatic fallback to cache on network errors
/// - Cache synchronization after successful remote operations
/// - Error handling and propagation
/// 
/// Example usage:
/// ```dart
/// final repository = ProductRepositoryImpl(
///   remoteDataSource: remoteDataSource,
///   localDataSource: localDataSource,
///   networkInfo: networkInfo,
/// );
/// 
/// // Automatically handles network availability
/// final products = await repository.getAllProducts();
/// ```
class ProductRepositoryImpl implements ProductRepository, ProductRepositoryContract {
  /// Remote data source for API operations
  final ProductRemoteDataSource remoteDataSource;
  
  /// Local data source for caching
  final ProductLocalDataSource localDataSource;
  
  /// Network connectivity checker
  final NetworkInfo networkInfo;

  /// Creates a ProductRepositoryImpl with required dependencies
  /// 
  /// All parameters are required to ensure proper functionality:
  ///   - [remoteDataSource]: Handles API calls to backend server
  ///   - [localDataSource]: Handles local cache operations
  ///   - [networkInfo]: Checks network connectivity status
  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    // Check network connectivity
    if (await networkInfo.isConnected) {
      try {
        // Fetch from remote when online
        final products = await remoteDataSource.fetchAllProducts();
        
        // Update local cache with fresh data
        await localDataSource.cacheProducts(products);
        
        return products;
      } catch (e) {
        // On remote error, fallback to cache
        return await localDataSource.getCachedProducts();
      }
    } else {
      // When offline, use cached data
      return await localDataSource.getCachedProducts();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    // Check network connectivity
    if (await networkInfo.isConnected) {
      try {
        // Fetch from remote when online
        final product = await remoteDataSource.fetchProductById(id);
        
        // Update cache if product exists
        if (product != null) {
          await localDataSource.cacheProduct(product);
        }
        
        return product;
      } catch (e) {
        // On remote error, fallback to cache
        return await localDataSource.getCachedProductById(id);
      }
    } else {
      // When offline, use cached data
      return await localDataSource.getCachedProductById(id);
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    // Check network connectivity
    if (await networkInfo.isConnected) {
      try {
        // Create on remote server
        await remoteDataSource.addProduct(product);
        
        // Update local cache after successful creation
        await localDataSource.cacheProduct(product);
      } on Exception {
        // Cache locally even if remote fails (for sync later)
        await localDataSource.cacheProduct(product);
        
        // Re-throw to inform caller of the error
        rethrow;
      }
    } else {
      // When offline, cache locally first for future sync
      await localDataSource.cacheProduct(product);
      
      // Throw error to inform caller that product was only cached
      throw Exception('No network connection. Product cached locally.');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    // Check network connectivity
    if (await networkInfo.isConnected) {
      try {
        // Update on remote server
        await remoteDataSource.editProduct(product);
        
        // Update local cache after successful update
        await localDataSource.updateCachedProduct(product);
      } on Exception {
        // Update cache even if remote fails
        await localDataSource.updateCachedProduct(product);
        
        // Re-throw to inform caller of the error
        rethrow;
      }
    } else {
      // When offline, update cache first
      await localDataSource.updateCachedProduct(product);
      
      // Throw error to inform caller that update was only local
      throw Exception('No network connection. Product updated locally.');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    // Check network connectivity
    if (await networkInfo.isConnected) {
      try {
        // Delete from remote server
        await remoteDataSource.removeProduct(id);
        
        // Remove from local cache after successful deletion
        await localDataSource.deleteCachedProduct(id);
      } on Exception {
        // Remove from cache even if remote fails
        await localDataSource.deleteCachedProduct(id);
        
        // Re-throw to inform caller of the error
        rethrow;
      }
    } else {
      // When offline, remove from cache first
      await localDataSource.deleteCachedProduct(id);
      
      // Throw error to inform caller that deletion was only local
      throw Exception('No network connection. Product deleted locally.');
    }
  }

  // Backward compatibility methods for existing use cases
  
  /// Delegates to createProduct for backward compatibility
  Future<void> insertProduct(Product product) async {
    await createProduct(product);
  }

  /// Delegates to getProductById for backward compatibility
  Future<Product?> getProduct(String id) async {
    return await getProductById(id);
  }

  /// Generates a unique ID for new products
  /// 
  /// Implements a simple UUID v4-like generator.
  /// In a production environment, IDs are typically generated by the server.
  String generateId() {
    // UUID v4-like generator
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (DateTime.now().microsecondsSinceEpoch % 1000000);
    final hash = timestamp.hashCode.abs();
    return '${timestamp.toRadixString(36)}-${random.toRadixString(36)}-${hash.toRadixString(36)}';
  }
}
