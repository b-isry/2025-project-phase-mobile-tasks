import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'base_usecase.dart';

/// Parameters for creating a product
class CreateProductParams {
  final Product product;

  CreateProductParams(this.product);
}

/// Use case for creating a new product
class CreateProductUsecase extends UseCase<void, CreateProductParams> {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  @override
  Future<void> call(CreateProductParams params) {
    return repository.createProduct(params.product);
  }
}

