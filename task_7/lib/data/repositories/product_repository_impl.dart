import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/product_repository_contract.dart';
import '../datasources/local/product_local_datasource.dart';
import '../datasources/remote/product_remote_datasource.dart';

/// Concrete implementation of ProductRepository following Clean Architecture
/// 
/// This repository implementation acts as a mediator between the domain layer
/// (use cases) and the data layer (data sources). It implements the repository
/// contract and delegates work to remote and local data sources.
/// 
/// The repository follows these principles:
/// - Tries remote data source first for fresh data
/// - Falls back to local cache if remote fails (offline support)
/// - Keeps local cache synchronized with remote data
/// - Handles error cases gracefully
/// 
/// Dependencies are injected through the constructor for better testability
/// and flexibility.
/// 
/// Example usage:
/// ```dart
/// final repository = ProductRepositoryImpl(
///   remoteDataSource: ProductRemoteDataSourceImpl(httpClient),
///   localDataSource: ProductLocalDataSourceImpl(database),
/// );
/// 
/// final products = await repository.getAllProducts();
/// ```
class ProductRepositoryImpl implements ProductRepository, ProductRepositoryContract {
  /// Remote data source for fetching data from API
  final ProductRemoteDataSource? remoteDataSource;
  
  /// Local data source for caching data
  final ProductLocalDataSource? localDataSource;
  
  /// In-memory storage for fallback/testing (will be replaced by actual data sources)
  final List<Product> _products;

  /// Creates a ProductRepositoryImpl with optional data source dependencies
  /// 
  /// Parameters:
  ///   - [remoteDataSource]: Optional remote data source for API calls
  ///   - [localDataSource]: Optional local data source for caching
  ///   - [initialProducts]: Optional initial products for testing/fallback
  /// 
  /// If no data sources are provided, the repository uses in-memory storage.
  ProductRepositoryImpl({
    this.remoteDataSource,
    this.localDataSource,
    List<Product>? initialProducts,
  }) : _products = initialProducts ?? [
          Product(
            id: '1',
            name: 'Laptop',
            description: 'High-performance laptop for developers',
            imageUrl: '',
            price: 999.99,
          ),
          Product(
            id: '2',
            name: 'Smartphone',
            description: 'Latest flagship smartphone with amazing camera',
            imageUrl: '',
            price: 799.99,
          ),
          Product(
            id: '3',
            name: 'Headphones',
            description: 'Noise-cancelling wireless headphones',
            imageUrl: '',
            price: 299.99,
          ),
        ];

  @override
  Future<List<Product>> getAllProducts() async {
    // TODO: Implement proper data source logic
    // Strategy: Try remote first, fallback to local cache, finally fallback to in-memory
    
    try {
      // Try fetching from remote data source first
      if (remoteDataSource != null) {
        final products = await remoteDataSource!.fetchAllProducts();
        
        // Cache the fetched products locally
        if (localDataSource != null) {
          await localDataSource!.cacheProducts(products);
        }
        
        return products;
      }
      
      // If no remote source, try local cache
      if (localDataSource != null) {
        final cachedProducts = await localDataSource!.getCachedProducts();
        if (cachedProducts.isNotEmpty) {
          return cachedProducts;
        }
      }
      
      // Fallback to in-memory storage
      return List.unmodifiable(_products);
    } catch (e) {
      // On error, try local cache as fallback
      if (localDataSource != null) {
        try {
          return await localDataSource!.getCachedProducts();
        } catch (_) {
          // If cache also fails, return in-memory data
          return List.unmodifiable(_products);
        }
      }
      
      // Final fallback to in-memory storage
      return List.unmodifiable(_products);
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    // TODO: Implement proper data source logic
    // Strategy: Check local cache first for speed, then remote if not found
    
    try {
      // Try local cache first for better performance
      if (localDataSource != null) {
        final cached = await localDataSource!.getCachedProductById(id);
        if (cached != null) {
          return cached;
        }
      }
      
      // If not in cache, fetch from remote
      if (remoteDataSource != null) {
        final product = await remoteDataSource!.fetchProductById(id);
        
        // Cache the fetched product
        if (product != null && localDataSource != null) {
          await localDataSource!.cacheProduct(product);
        }
        
        return product;
      }
      
      // Fallback to in-memory storage
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      // Try in-memory storage as final fallback
      try {
        return _products.firstWhere((product) => product.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    // TODO: Implement proper data source logic
    // Strategy: Save to remote first, then update local cache
    
    try {
      // Save to remote data source
      if (remoteDataSource != null) {
        await remoteDataSource!.addProduct(product);
      }
      
      // Cache locally for offline access
      if (localDataSource != null) {
        await localDataSource!.cacheProduct(product);
      }
      
      // Update in-memory storage as fallback
      _products.add(product);
    } catch (e) {
      // On error, at least save locally and in-memory
      if (localDataSource != null) {
        await localDataSource!.cacheProduct(product);
      }
      _products.add(product);
      rethrow; // Propagate error to caller
    }
  }

  // Backward compatibility method (not part of contract)
  Future<void> insertProduct(Product product) async {
    // Delegate to createProduct for compatibility with use cases
    await createProduct(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    // TODO: Implement proper data source logic
    // Strategy: Update remote first, then sync with local cache
    
    try {
      // Update in remote data source
      if (remoteDataSource != null) {
        await remoteDataSource!.editProduct(product);
      }
      
      // Update local cache to stay in sync
      if (localDataSource != null) {
        await localDataSource!.updateCachedProduct(product);
      }
      
      // Update in-memory storage
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }
    } catch (e) {
      // On error, at least update locally
      if (localDataSource != null) {
        await localDataSource!.updateCachedProduct(product);
      }
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }
      rethrow; // Propagate error to caller
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    // TODO: Implement proper data source logic
    // Strategy: Delete from remote first, then remove from local cache
    
    try {
      // Delete from remote data source
      if (remoteDataSource != null) {
        await remoteDataSource!.removeProduct(id);
      }
      
      // Remove from local cache
      if (localDataSource != null) {
        await localDataSource!.deleteCachedProduct(id);
      }
      
      // Remove from in-memory storage
      _products.removeWhere((product) => product.id == id);
    } catch (e) {
      // On error, at least delete locally
      if (localDataSource != null) {
        await localDataSource!.deleteCachedProduct(id);
      }
      _products.removeWhere((product) => product.id == id);
      rethrow; // Propagate error to caller
    }
  }

  // Backward compatibility method (not part of contract)
  Future<Product?> getProduct(String id) async {
    // Delegate to getProductById for compatibility with use cases
    return await getProductById(id);
  }

  /// Generate a unique ID for new products (helper method)
  String generateId() {
    if (_products.isEmpty) return '1';
    final ids = _products.map((p) => int.tryParse(p.id) ?? 0).toList();
    final maxId = ids.reduce((a, b) => a > b ? a : b);
    return (maxId + 1).toString();
  }
}

