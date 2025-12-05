import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'base_usecase.dart';

/// Parameters for updating a product
class UpdateProductParams {
  final Product product;

  UpdateProductParams(this.product);
}

/// Use case for updating an existing product
class UpdateProductUsecase extends UseCase<void, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<void> call(UpdateProductParams params) {
    return repository.updateProduct(params.product);
  }
}

