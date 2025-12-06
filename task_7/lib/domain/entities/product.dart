/// Product entity representing an e-commerce product in the domain layer
/// 
/// This entity follows Clean Architecture principles and is part of the domain layer.
/// It is framework-independent and contains only business logic.
class Product {
  /// Unique identifier for the product
  final String id;
  
  /// Name of the product
  final String name;
  
  /// Detailed description of the product
  final String description;
  
  /// Price of the product in the default currency
  final double price;
  
  /// URL pointing to the product image
  final String imageUrl;

  /// Creates a Product instance
  /// 
  /// Can be created using either [name] or [title] (for backward compatibility).
  /// [imageUrl] and [price] have default values if not provided.
  Product({
    required this.id,
    String? name,
    String? title,
    required this.description,
    this.price = 0.0,
    this.imageUrl = '',
  }) : name = name ?? title ?? '';

  /// Backward compatibility getter for existing code using 'title'
  String get title => name;

  /// Creates a copy of this product with updated fields
  /// 
  /// Any field can be updated by passing a new value.
  /// Accepts both [name] and [title] for backward compatibility.
  /// Fields not provided will retain their current values.
  Product copyWith({
    String? id,
    String? name,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? title ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// Converts this Product to a JSON map
  /// 
  /// Returns a map representation suitable for serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  /// Creates a Product from a JSON map
  /// 
  /// Throws a [TypeError] if required fields are missing or have wrong types.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String? ?? json['title'] as String, // Support both 'name' and 'title'
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  /// Checks equality based on all fields
  /// 
  /// Two products are equal if all their fields are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.imageUrl == imageUrl;
  }

  /// Generates a hash code based on all fields
  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      price,
      imageUrl,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, imageUrl: $imageUrl)';
  }
}

