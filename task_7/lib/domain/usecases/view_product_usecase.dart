import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'base_usecase.dart';

/// Parameters for viewing a specific product
class ViewProductParams {
  final String id;

  ViewProductParams(this.id);
}

/// Use case for retrieving a specific product by ID
class ViewProductUsecase extends UseCase<Product?, ViewProductParams> {
  final ProductRepository repository;

  ViewProductUsecase(this.repository);

  @override
  Future<Product?> call(ViewProductParams params) {
    return repository.getProductById(params.id);
  }
}

