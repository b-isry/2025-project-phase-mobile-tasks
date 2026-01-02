import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

/// Base class for all product-related states
/// 
/// All product states must extend this abstract class.
/// States are immutable and represent the current state of the product bloc.
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the bloc is first created
/// 
/// This is the default state before any events are processed.
class InitialState extends ProductState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

/// State indicating that an async operation is in progress
/// 
/// This state is emitted before any async operation begins.
class LoadingState extends ProductState {
  const LoadingState();

  @override
  List<Object?> get props => [];
}

/// State indicating that all products have been successfully loaded
/// 
/// This state contains the list of all products.
class LoadedAllProductsState extends ProductState {
  /// The list of all products
  final List<Product> products;

  const LoadedAllProductsState(this.products);

  @override
  List<Object?> get props => [products];
}

/// State indicating that a single product has been successfully loaded
/// 
/// This state contains a single product.
class LoadedSingleProductState extends ProductState {
  /// The product that was loaded
  final Product product;

  const LoadedSingleProductState(this.product);

  @override
  List<Object?> get props => [product];
}

/// State indicating that an error has occurred
/// 
/// This state contains the error message or failure information.
class ErrorState extends ProductState {
  /// The error message describing what went wrong
  final String message;

  const ErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
