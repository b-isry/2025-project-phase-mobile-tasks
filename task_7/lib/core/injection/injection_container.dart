import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Core
import '../network/network_info.dart';
import '../network/network_info_impl.dart';

// Data Sources
import '../../data/datasources/remote/product_remote_datasource.dart';
import '../../data/datasources/remote/product_remote_datasource_impl.dart';
import '../../data/datasources/local/product_local_datasource.dart';
import '../../data/datasources/local/product_local_datasource_impl.dart';

// Repository
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/product_repository_contract.dart';

// Use Cases
import '../../domain/usecases/view_all_products_usecase.dart';
import '../../domain/usecases/get_product_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';

// Bloc
import '../../presentation/bloc/product_bloc.dart';

/// Service locator instance
/// 
/// This is a singleton instance of GetIt used throughout the app
/// for dependency injection. All dependencies should be registered
/// through the [init] function before the app starts.
final sl = GetIt.instance;

/// Initializes the dependency injection container
/// 
/// This function registers all dependencies in the correct order,
/// respecting dependency chains and Clean Architecture layers.
/// 
/// Registration order:
/// 1. Core/External dependencies (SharedPreferences, NetworkInfo)
/// 2. Data Sources (Remote, Local)
/// 3. Repository
/// 4. Use Cases
/// 5. Bloc
/// 
/// Throws an exception if a dependency is already registered.
Future<void> init() async {
  // ============================================
  // Core / External Dependencies
  // ============================================
  
  // SharedPreferences - must be registered asynchronously
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );

  // ============================================
  // Data Sources
  // ============================================
  
  // HTTP Client
  sl.registerLazySingleton<http.Client>(
    () => http.Client(),
  );

  // Remote Data Source
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      client: sl<http.Client>(),
    ),
  );

  // Local Data Source
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // ============================================
  // Repository
  // ============================================
  
  // ProductRepositoryImpl - register factory that creates shared instance
  sl.registerLazySingleton<ProductRepositoryImpl>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl<ProductRemoteDataSource>(),
      localDataSource: sl<ProductLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register as ProductRepositoryContract (used by some use cases)
  sl.registerLazySingleton<ProductRepositoryContract>(
    () => sl<ProductRepositoryImpl>(),
  );

  // Register as ProductRepository (used by other use cases)
  sl.registerLazySingleton<ProductRepository>(
    () => sl<ProductRepositoryImpl>(),
  );

  // ============================================
  // Use Cases (Domain Layer)
  // ============================================
  
  // ViewAllProductsUsecase (GetAllProducts)
  sl.registerLazySingleton<ViewAllProductsUsecase>(
    () => ViewAllProductsUsecase(
      sl<ProductRepository>(),
    ),
  );

  // GetProductUsecase (GetSingleProduct)
  sl.registerLazySingleton<GetProductUsecase>(
    () => GetProductUsecase(
      sl<ProductRepositoryContract>(),
    ),
  );

  // CreateProductUsecase
  sl.registerLazySingleton<CreateProductUsecase>(
    () => CreateProductUsecase(
      sl<ProductRepository>(),
    ),
  );

  // UpdateProductUsecase
  sl.registerLazySingleton<UpdateProductUsecase>(
    () => UpdateProductUsecase(
      sl<ProductRepositoryContract>(),
    ),
  );

  // DeleteProductUsecase
  sl.registerLazySingleton<DeleteProductUsecase>(
    () => DeleteProductUsecase(
      sl<ProductRepositoryContract>(),
    ),
  );

  // ============================================
  // Bloc Layer
  // ============================================
  
  // ProductBloc - registered as factory to create new instances
  sl.registerFactory<ProductBloc>(
    () => ProductBloc(
      getAllProducts: sl<ViewAllProductsUsecase>(),
      getSingleProduct: sl<GetProductUsecase>(),
      createProduct: sl<CreateProductUsecase>(),
      updateProduct: sl<UpdateProductUsecase>(),
      deleteProduct: sl<DeleteProductUsecase>(),
    ),
  );
}
