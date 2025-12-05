import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'base_usecase.dart';

/// Use case for retrieving all products
class ViewAllProductsUsecase extends UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  ViewAllProductsUsecase(this.repository);

  @override
  Future<List<Product>> call(NoParams params) {
    return repository.getAllProducts();
  }
}

