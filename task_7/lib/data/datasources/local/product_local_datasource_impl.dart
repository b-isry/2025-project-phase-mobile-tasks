import '../../../domain/entities/product.dart';
import 'product_local_datasource.dart';

/// Simple in-memory implementation of ProductLocalDataSource
/// 
/// This is a basic implementation for development/testing purposes.
/// In production, this would use actual local storage (SQLite, Hive, etc.).
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Map<String, Product> _cachedProducts = {};

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

