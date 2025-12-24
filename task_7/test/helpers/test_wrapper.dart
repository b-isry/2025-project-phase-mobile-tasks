import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/providers/product_provider.dart';
import 'package:product_manager/routes.dart';
import 'package:product_manager/theme/app_theme.dart';
import 'package:product_manager/data/repositories/product_repository_impl.dart';
import 'package:product_manager/data/datasources/remote/product_remote_datasource.dart';
import 'package:product_manager/data/datasources/local/product_local_datasource.dart';
import 'package:product_manager/core/network/network_info.dart';

/// Fake implementation of ProductRemoteDataSource for testing
class FakeRemoteDataSource implements ProductRemoteDataSource {
  final Map<String, Product> _products = {};

  FakeRemoteDataSource({List<Product> initialProducts = const []}) {
    for (final product in initialProducts) {
      _products[product.id] = product;
    }
  }

  @override
  Future<List<Product>> fetchAllProducts() async {
    return _products.values.toList();
  }

  @override
  Future<Product?> fetchProductById(String id) async {
    return _products[id];
  }

  @override
  Future<void> addProduct(Product product) async {
    _products[product.id] = product;
  }

  @override
  Future<void> editProduct(Product product) async {
    _products[product.id] = product;
  }

  @override
  Future<void> removeProduct(String id) async {
    _products.remove(id);
  }
}

/// Fake implementation of ProductLocalDataSource for testing
class FakeLocalDataSource implements ProductLocalDataSource {
  final Map<String, Product> _products = {};

  FakeLocalDataSource({List<Product> initialProducts = const []}) {
    for (final product in initialProducts) {
      _products[product.id] = product;
    }
  }

  @override
  Future<List<Product>> getCachedProducts() async {
    return _products.values.toList();
  }

  @override
  Future<Product?> getCachedProductById(String id) async {
    return _products[id];
  }

  @override
  Future<void> cacheProduct(Product product) async {
    _products[product.id] = product;
  }

  @override
  Future<void> cacheProducts(List<Product> products) async {
    for (final product in products) {
      _products[product.id] = product;
    }
  }

  @override
  Future<void> updateCachedProduct(Product product) async {
    _products[product.id] = product;
  }

  @override
  Future<void> deleteCachedProduct(String id) async {
    _products.remove(id);
  }

  @override
  Future<void> clearCache() async {
    _products.clear();
  }
}

/// Fake implementation of NetworkInfo for testing
class FakeNetworkInfo implements NetworkInfo {
  bool _isConnected = true;

  FakeNetworkInfo({bool isConnected = true}) : _isConnected = isConnected;

  @override
  Future<bool> get isConnected async => _isConnected;
}

/// Creates a MaterialApp wrapper with provider for testing
Future<Widget> createTestApp({
  required Widget child,
  List<Product>? initialProducts,
}) async {
  // Disable shadows for testing
  debugDisableShadows = true;

  // Initialize SharedPreferences for testing
  SharedPreferences.setMockInitialValues({});
  final sharedPreferences = await SharedPreferences.getInstance();

  // Create mock or fake dependencies for the ProductRepositoryImpl
  final remoteDataSource = FakeRemoteDataSource(
    initialProducts: initialProducts ?? [],
  );
  final localDataSource = FakeLocalDataSource(
    initialProducts: initialProducts ?? [],
  );
  final networkInfo = FakeNetworkInfo();

  final repository = ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );

  final provider = ProductProvider(
    repository: repository,
    sharedPreferences: sharedPreferences,
  );

  return ChangeNotifierProvider<ProductProvider>.value(
    value: provider,
    child: MaterialApp(
      theme: AppTheme.theme,
      home: child,
      onGenerateRoute: Routes.onGenerateRoute,
    ),
  );
}
