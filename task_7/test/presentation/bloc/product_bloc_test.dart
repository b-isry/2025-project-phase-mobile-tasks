import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_manager/domain/entities/product.dart';
import 'package:product_manager/domain/repositories/product_repository.dart';
import 'package:product_manager/domain/repositories/product_repository_contract.dart';
import 'package:product_manager/domain/usecases/view_all_products_usecase.dart';
import 'package:product_manager/domain/usecases/get_product_usecase.dart';
import 'package:product_manager/domain/usecases/create_product_usecase.dart';
import 'package:product_manager/domain/usecases/update_product_usecase.dart';
import 'package:product_manager/domain/usecases/delete_product_usecase.dart';
import 'package:product_manager/presentation/bloc/product_bloc.dart';
import 'package:product_manager/presentation/bloc/product_event.dart';
import 'package:product_manager/presentation/bloc/product_state.dart';

/// Mock repository for testing ViewAllProductsUsecase and CreateProductUsecase
class MockProductRepository extends ProductRepository {
  final Map<String, Product> _products = {};
  bool _shouldThrowError = false;
  String? _errorMessage;

  void setProducts(List<Product> products) {
    _products.clear();
    for (final product in products) {
      _products[product.id] = product;
    }
  }

  void setThrowError(bool shouldThrow, [String? errorMessage]) {
    _shouldThrowError = shouldThrow;
    _errorMessage = errorMessage;
  }

  @override
  Future<List<Product>> getAllProducts() async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage ?? 'Failed to load products');
    }
    return List.unmodifiable(_products.values.toList());
  }

  @override
  Future<Product?> getProductById(String id) async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage ?? 'Failed to get product');
    }
    return _products[id];
  }

  @override
  Future<void> createProduct(Product product) async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage ?? 'Failed to create product');
    }
    _products[product.id] = product;
  }

  @override
  Future<void> updateProduct(Product product) async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage ?? 'Failed to update product');
    }
    if (!_products.containsKey(product.id)) {
      throw Exception('Product not found');
    }
    _products[product.id] = product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage ?? 'Failed to delete product');
    }
    if (!_products.containsKey(id)) {
      throw Exception('Product not found');
    }
    _products.remove(id);
  }
}

/// Mock repository contract for testing GetProductUsecase, UpdateProductUsecase, DeleteProductUsecase
class MockProductRepositoryContract extends ProductRepositoryContract {
  final Map<String, Product> _products = {};
  bool _shouldThrowError = false;
  String? _errorMessage;
  Product? _lastCreatedProduct;
  Product? _lastUpdatedProduct;
  String? _lastDeletedProductId;

  Product? get lastCreatedProduct => _lastCreatedProduct;
  Product? get lastUpdatedProduct => _lastUpdatedProduct;
  String? get lastDeletedProductId => _lastDeletedProductId;

  void setProducts(List<Product> products) {
    _products.clear();
    for (final product in products) {
      _products[product.id] = product;
    }
  }

  void setProduct(String id, Product? product) {
    if (product == null) {
      _products.remove(id);
    } else {
      _products[id] = product;
    }
  }

  void setThrowError(bool shouldThrow, [String? errorMessage]) {
    _shouldThrowError = shouldThrow;
    _errorMessage = errorMessage;
  }

  @override
  Future<List<Product>> getAllProducts() async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage ?? 'Failed to load products');
    }
    return List.unmodifiable(_products.values.toList());
  }

  @override
  Future<Product?> getProductById(String id) async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage ?? 'Failed to get product');
    }
    return _products[id];
  }

  @override
  Future<void> createProduct(Product product) async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage ?? 'Failed to create product');
    }
    _lastCreatedProduct = product;
    _products[product.id] = product;
  }

  @override
  Future<void> updateProduct(Product product) async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage ?? 'Failed to update product');
    }
    if (!_products.containsKey(product.id)) {
      throw Exception('Product not found');
    }
    _lastUpdatedProduct = product;
    _products[product.id] = product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (_shouldThrowError) {
      throw Exception(_errorMessage ?? 'Failed to delete product');
    }
    if (!_products.containsKey(id)) {
      throw Exception('Product not found');
    }
    _lastDeletedProductId = id;
    _products.remove(id);
  }
}

void main() {
  late MockProductRepository mockRepository;
  late MockProductRepositoryContract mockRepositoryContract;
  late ViewAllProductsUsecase getAllProducts;
  late GetProductUsecase getSingleProduct;
  late CreateProductUsecase createProduct;
  late UpdateProductUsecase updateProduct;
  late DeleteProductUsecase deleteProduct;
  late ProductBloc bloc;

  setUp(() {
    mockRepository = MockProductRepository();
    mockRepositoryContract = MockProductRepositoryContract();
    
    getAllProducts = ViewAllProductsUsecase(mockRepository);
    getSingleProduct = GetProductUsecase(mockRepositoryContract);
    createProduct = CreateProductUsecase(mockRepository);
    updateProduct = UpdateProductUsecase(mockRepositoryContract);
    deleteProduct = DeleteProductUsecase(mockRepositoryContract);

    bloc = ProductBloc(
      getAllProducts: getAllProducts,
      getSingleProduct: getSingleProduct,
      createProduct: createProduct,
      updateProduct: updateProduct,
      deleteProduct: deleteProduct,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ProductBloc', () {
    test('initial state should be InitialState', () {
      // Assert
      expect(bloc.state, equals(const InitialState()));
    });

    group('LoadAllProductsEvent', () {
      final testProducts = [
        Product(
          id: '1',
          name: 'Product 1',
          description: 'Description 1',
          price: 50.0,
        ),
        Product(
          id: '2',
          name: 'Product 2',
          description: 'Description 2',
          price: 75.0,
        ),
      ];

      blocTest<ProductBloc, ProductState>(
        'should emit LoadingState then LoadedAllProductsState on success',
        build: () {
          mockRepository.setProducts(testProducts);
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadAllProductsEvent()),
        expect: () => [
          const LoadingState(),
          LoadedAllProductsState(testProducts),
        ],
      );

      blocTest<ProductBloc, ProductState>(
        'should emit LoadingState then ErrorState on failure',
        build: () {
          mockRepository.setThrowError(true, 'Network error');
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadAllProductsEvent()),
        expect: () => [
          const LoadingState(),
          const ErrorState('Exception: Network error'),
        ],
      );

      blocTest<ProductBloc, ProductState>(
        'should emit LoadingState then LoadedAllProductsState with empty list when no products',
        build: () {
          mockRepository.setProducts([]);
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadAllProductsEvent()),
        expect: () => [
          const LoadingState(),
          const LoadedAllProductsState([]),
        ],
      );
    });

    group('GetSingleProductEvent', () {
      final testProduct = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 99.99,
      );

      blocTest<ProductBloc, ProductState>(
        'should emit LoadingState then LoadedSingleProductState on success',
        build: () {
          mockRepositoryContract.setProduct('1', testProduct);
          return bloc;
        },
        act: (bloc) => bloc.add(const GetSingleProductEvent('1')),
        expect: () => [
          const LoadingState(),
          LoadedSingleProductState(testProduct),
        ],
      );

      blocTest<ProductBloc, ProductState>(
        'should emit LoadingState then ErrorState when product not found',
        build: () {
          mockRepositoryContract.setProduct('1', null);
          return bloc;
        },
        act: (bloc) => bloc.add(const GetSingleProductEvent('1')),
        expect: () => [
          const LoadingState(),
          const ErrorState('Product not found'),
        ],
      );

      blocTest<ProductBloc, ProductState>(
        'should emit LoadingState then ErrorState on failure',
        build: () {
          mockRepositoryContract.setThrowError(true, 'Database error');
          return bloc;
        },
        act: (bloc) => bloc.add(const GetSingleProductEvent('1')),
        expect: () => [
          const LoadingState(),
          const ErrorState('Exception: Database error'),
        ],
      );
    });

    group('CreateProductEvent', () {
      final newProduct = Product(
        id: '1',
        name: 'New Product',
        description: 'New Description',
        price: 150.0,
      );

      final allProducts = [
        newProduct,
        Product(
          id: '2',
          name: 'Existing Product',
          description: 'Existing Description',
          price: 100.0,
        ),
      ];

      blocTest<ProductBloc, ProductState>(
        'should emit LoadingState then LoadedAllProductsState on success',
        build: () {
          // After creation, getAllProducts should return updated list
          mockRepository.setProducts(allProducts);
          return bloc;
        },
        act: (bloc) => bloc.add(CreateProductEvent(newProduct)),
        expect: () => [
          const LoadingState(),
          LoadedAllProductsState(allProducts),
        ],
      );

      blocTest<ProductBloc, ProductState>(
        'should emit LoadingState then ErrorState on failure',
        build: () {
          mockRepository.setThrowError(true, 'Creation failed');
          return bloc;
        },
        act: (bloc) => bloc.add(CreateProductEvent(newProduct)),
        expect: () => [
          const LoadingState(),
          const ErrorState('Exception: Creation failed'),
        ],
      );
    });

    group('UpdateProductEvent', () {
      final updatedProduct = Product(
        id: '1',
        name: 'Updated Product',
        description: 'Updated Description',
        price: 200.0,
      );

      blocTest<ProductBloc, ProductState>(
        'should emit LoadingState then LoadedSingleProductState on success',
        build: () {
          // Set up the product to exist first
          mockRepositoryContract.setProduct('1', updatedProduct);
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateProductEvent(updatedProduct)),
        expect: () => [
          const LoadingState(),
          LoadedSingleProductState(updatedProduct),
        ],
        verify: (_) {
          expect(mockRepositoryContract.lastUpdatedProduct, equals(updatedProduct));
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit LoadingState then ErrorState on failure',
        build: () {
          mockRepositoryContract.setThrowError(true, 'Update failed');
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateProductEvent(updatedProduct)),
        expect: () => [
          const LoadingState(),
          const ErrorState('Exception: Update failed'),
        ],
      );
    });

    group('DeleteProductEvent', () {
      final remainingProducts = [
        Product(
          id: '2',
          name: 'Remaining Product',
          description: 'Remaining Description',
          price: 100.0,
        ),
      ];

      blocTest<ProductBloc, ProductState>(
        'should emit LoadingState then LoadedAllProductsState on success',
        build: () {
          // Set up product to exist first
          mockRepositoryContract.setProduct('1', Product(
            id: '1',
            name: 'Product to Delete',
            description: 'Description',
            price: 50.0,
          ));
          mockRepository.setProducts(remainingProducts);
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteProductEvent('1')),
        expect: () => [
          const LoadingState(),
          LoadedAllProductsState(remainingProducts),
        ],
        verify: (_) {
          expect(mockRepositoryContract.lastDeletedProductId, equals('1'));
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit LoadingState then ErrorState on failure',
        build: () {
          mockRepositoryContract.setThrowError(true, 'Deletion failed');
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteProductEvent('1')),
        expect: () => [
          const LoadingState(),
          const ErrorState('Exception: Deletion failed'),
        ],
      );
    });

    group('Integration scenarios', () {
      blocTest<ProductBloc, ProductState>(
        'should handle multiple events in sequence',
        build: () {
          final products = [
            Product(
              id: '1',
              name: 'Product 1',
              description: 'Description 1',
              price: 50.0,
            ),
          ];
          mockRepository.setProducts(products);
          mockRepositoryContract.setProduct('1', products[0]);
          return bloc;
        },
        act: (bloc) async {
          bloc.add(const LoadAllProductsEvent());
          await bloc.stream.first;
          bloc.add(const GetSingleProductEvent('1'));
        },
        expect: () => [
          const LoadingState(),
          LoadedAllProductsState([
            Product(
              id: '1',
              name: 'Product 1',
              description: 'Description 1',
              price: 50.0,
            ),
          ]),
          const LoadingState(),
          LoadedSingleProductState(
            Product(
              id: '1',
              name: 'Product 1',
              description: 'Description 1',
              price: 50.0,
            ),
          ),
        ],
      );
    });
  });
}
