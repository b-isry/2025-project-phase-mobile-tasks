import '../repositories/product_repository.dart';
import 'base_usecase.dart';

/// Parameters for deleting a product
class DeleteProductParams {
  final String id;

  DeleteProductParams(this.id);
}

/// Use case for deleting a product
class DeleteProductUsecase extends UseCase<void, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<void> call(DeleteProductParams params) {
    return repository.deleteProduct(params.id);
  }
}

