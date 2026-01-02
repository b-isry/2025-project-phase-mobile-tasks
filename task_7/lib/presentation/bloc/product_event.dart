import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

/// Base class for all product-related events
/// 
/// All product events must extend this sealed/abstract class.
/// This ensures type safety and allows pattern matching in the bloc.
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all products
/// 
/// This event triggers fetching all products from the repository.
class LoadAllProductsEvent extends ProductEvent {
  const LoadAllProductsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to get a single product by ID
/// 
/// This event triggers fetching a specific product by its ID.
class GetSingleProductEvent extends ProductEvent {
  /// The ID of the product to retrieve
  final String productId;

  const GetSingleProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Event to create a new product
/// 
/// This event triggers creating a new product in the repository.
class CreateProductEvent extends ProductEvent {
  /// The product entity to create
  final Product product;

  const CreateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

/// Event to update an existing product
/// 
/// This event triggers updating an existing product in the repository.
class UpdateProductEvent extends ProductEvent {
  /// The product entity with updated data
  final Product product;

  const UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

/// Event to delete a product
/// 
/// This event triggers deleting a product from the repository.
class DeleteProductEvent extends ProductEvent {
  /// The ID of the product to delete
  final String productId;

  const DeleteProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}
