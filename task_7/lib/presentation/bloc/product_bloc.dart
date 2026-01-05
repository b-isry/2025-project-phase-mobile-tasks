import 'package:bloc/bloc.dart';
import '../../domain/usecases/view_all_products_usecase.dart';
import '../../domain/usecases/get_product_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/base_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

/// BLoC for managing product state and operations
/// 
/// This bloc follows Clean Architecture principles by depending only on domain use cases.
/// It handles all product-related events and emits appropriate states.
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  /// Use case for getting all products
  final ViewAllProductsUsecase getAllProducts;
  
  /// Use case for getting a single product
  final GetProductUsecase getSingleProduct;
  
  /// Use case for creating a product
  final CreateProductUsecase createProduct;
  
  /// Use case for updating a product
  final UpdateProductUsecase updateProduct;
  
  /// Use case for deleting a product
  final DeleteProductUsecase deleteProduct;

  /// Creates a ProductBloc instance
  /// 
  /// Requires all use cases to be provided as dependencies.
  ProductBloc({
    required this.getAllProducts,
    required this.getSingleProduct,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(const InitialState()) {
    // Register event handlers
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<GetSingleProductEvent>(_onGetSingleProduct);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  /// Handles LoadAllProductsEvent
  /// 
  /// Emits LoadingState, then LoadedAllProductsState on success or ErrorState on failure.
  Future<void> _onLoadAllProducts(
    LoadAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    
    try {
      final products = await getAllProducts(NoParams());
      emit(LoadedAllProductsState(products));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  /// Handles GetSingleProductEvent
  /// 
  /// Emits LoadingState, then LoadedSingleProductState on success or ErrorState on failure.
  Future<void> _onGetSingleProduct(
    GetSingleProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    
    try {
      final product = await getSingleProduct(GetProductParams(event.productId));
      if (product != null) {
        emit(LoadedSingleProductState(product));
      } else {
        emit(const ErrorState('Product not found'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  /// Handles CreateProductEvent
  /// 
  /// Emits LoadingState, creates the product, then reloads all products.
  /// Emits LoadedAllProductsState on success or ErrorState on failure.
  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    
    try {
      await createProduct(CreateProductParams(event.product));
      // Reload all products after creation
      final products = await getAllProducts(NoParams());
      emit(LoadedAllProductsState(products));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  /// Handles UpdateProductEvent
  /// 
  /// Emits LoadingState, updates the product, then emits LoadedSingleProductState.
  /// Emits ErrorState on failure.
  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    
    try {
      await updateProduct(UpdateProductParams(event.product));
      emit(LoadedSingleProductState(event.product));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  /// Handles DeleteProductEvent
  /// 
  /// Emits LoadingState, deletes the product, then reloads all products.
  /// Emits LoadedAllProductsState on success or ErrorState on failure.
  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    
    try {
      await deleteProduct(DeleteProductParams(event.productId));
      // Reload all products after deletion
      final products = await getAllProducts(NoParams());
      emit(LoadedAllProductsState(products));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
