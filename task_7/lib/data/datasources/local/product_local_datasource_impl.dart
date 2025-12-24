import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/product.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/constants/cache_constants.dart';
import '../../../core/utils/json_helper.dart';
import 'product_local_datasource.dart';

/// SharedPreferences implementation of ProductLocalDataSource
/// 
/// This implementation uses SharedPreferences to persist product data locally.
/// Products are stored as a list of JSON-encoded strings for efficient storage.
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  /// Creates a ProductLocalDataSourceImpl with SharedPreferences
  /// 
  /// Parameters:
  ///   - [sharedPreferences]: The SharedPreferences instance to use for storage
  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Product>> getCachedProducts() async {
    final jsonStringList = sharedPreferences.getStringList(CacheConstants.cachedProductsKey);
    
    if (jsonStringList == null || jsonStringList.isEmpty) {
      throw CacheException();
    }

    try {
      return jsonStringList
          .map((jsonString) => Product.fromJson(JsonHelper.decodeMap(jsonString)))
          .toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Product?> getCachedProductById(String id) async {
    final jsonStringList = sharedPreferences.getStringList(CacheConstants.cachedProductsKey);
    
    if (jsonStringList == null || jsonStringList.isEmpty) {
      return null;
    }

    try {
      final products = jsonStringList
          .map((jsonString) => Product.fromJson(JsonHelper.decodeMap(jsonString)))
          .toList();
      
      try {
        return products.firstWhere((product) => product.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheProducts(List<Product> products) async {
    final jsonStringList = JsonHelper.toJsonStringList(products, (p) => p.toJson());

    await sharedPreferences.setStringList(
      CacheConstants.cachedProductsKey,
      jsonStringList,
    );
  }

  @override
  Future<void> cacheProduct(Product product) async {
    final products = await getCachedProducts().catchError((_) => <Product>[]);
    
    // Remove existing product with same ID if present
    products.removeWhere((p) => p.id == product.id);
    
    // Add the new/updated product
    products.add(product);
    
    // Save the updated list
    await cacheProducts(products);
  }

  @override
  Future<void> updateCachedProduct(Product product) async {
    final products = await getCachedProducts();
    
    final index = products.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      throw CacheException();
    }
    
    products[index] = product;
    await cacheProducts(products);
  }

  @override
  Future<void> deleteCachedProduct(String id) async {
    final products = await getCachedProducts();
    
    products.removeWhere((product) => product.id == id);
    
    if (products.isEmpty) {
      await sharedPreferences.remove(CacheConstants.cachedProductsKey);
    } else {
      await cacheProducts(products);
    }
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(CacheConstants.cachedProductsKey);
  }
}
