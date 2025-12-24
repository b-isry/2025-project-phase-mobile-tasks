import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/product.dart';
import '../domain/usecases/base_usecase.dart';
import '../domain/usecases/view_all_products_usecase.dart';
import '../domain/usecases/view_product_usecase.dart';
import '../domain/usecases/create_product_usecase.dart';
import '../domain/usecases/update_product_usecase.dart';
import '../domain/usecases/delete_product_usecase.dart';
import '../data/repositories/product_repository_impl.dart';
import '../data/datasources/remote/product_remote_datasource_impl.dart';
import '../data/datasources/local/product_local_datasource_impl.dart';
import '../core/network/network_info_impl.dart';

/// Provider for managing products with CRUD operations
/// Refactored to use Clean Architecture domain layer with use cases
class ProductProvider extends ChangeNotifier {
  // Repository implementation
  final ProductRepositoryImpl _repository;

  // Use cases
  late final ViewAllProductsUsecase _viewAllProductsUsecase;
  late final ViewProductUsecase _viewProductUsecase;
  late final CreateProductUsecase _createProductUsecase;
  late final UpdateProductUsecase _updateProductUsecase;
  late final DeleteProductUsecase _deleteProductUsecase;

  List<Product> _products = [];
  bool _isInitialized = false;

  ProductProvider({
    ProductRepositoryImpl? repository,
    required SharedPreferences sharedPreferences,
  }) : _repository = repository ??
            ProductRepositoryImpl(
              remoteDataSource: ProductRemoteDataSourceImpl(),
              localDataSource: ProductLocalDataSourceImpl(
                sharedPreferences: sharedPreferences,
              ),
              networkInfo: NetworkInfoImpl(),
            ) {
    // Initialize use cases with repository
    _viewAllProductsUsecase = ViewAllProductsUsecase(_repository);
    _viewProductUsecase = ViewProductUsecase(_repository);
    _createProductUsecase = CreateProductUsecase(_repository);
    _updateProductUsecase = UpdateProductUsecase(_repository);
    _deleteProductUsecase = DeleteProductUsecase(_repository);

    // Load initial products
    _initializeProducts();
  }

  /// Initialize products synchronously for backward compatibility
  void _initializeProducts() {
    _viewAllProductsUsecase(NoParams()).then((products) {
      _products = products;
      _isInitialized = true;
      notifyListeners();
    });
  }

  List<Product> get products => List.unmodifiable(_products);

  bool get isInitialized => _isInitialized;

  /// Get a product by ID (synchronous for backward compatibility with UI)
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get a product by ID using use case (async version)
  Future<Product?> getProductByIdAsync(String id) async {
    return await _viewProductUsecase(ViewProductParams(id));
  }

  /// Add a new product using use case
  void addProduct(Product product) {
    // Persist through use case and update local state
    _createProductUsecase(CreateProductParams(product)).then((_) async {
      _products = await _viewAllProductsUsecase(NoParams());
      notifyListeners();
    });
  }

  /// Update an existing product using use case
  void updateProduct(Product updatedProduct) {
    // Persist through use case and update local state
    _updateProductUsecase(UpdateProductParams(updatedProduct)).then((_) async {
      _products = await _viewAllProductsUsecase(NoParams());
      notifyListeners();
    });
  }

  /// Delete a product by ID using use case
  void deleteProduct(String id) {
    // Persist through use case and update local state
    _deleteProductUsecase(DeleteProductParams(id)).then((_) async {
      _products = await _viewAllProductsUsecase(NoParams());
      notifyListeners();
    });
  }

  /// Generate a unique ID for new products
  String generateId() {
    return _repository.generateId();
  }
}

