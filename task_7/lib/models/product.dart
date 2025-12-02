/// Product model representing an e-commerce product
class Product {
  final String id;
  final String title;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.description,
  });

  /// Create a copy of this product with updated fields
  Product copyWith({
    String? id,
    String? title,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

