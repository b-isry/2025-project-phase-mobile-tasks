class Product {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String imageUrl;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.category,
    required this.description,
  });

  // Dummy data for testing
  static List<Product> dummyProducts = [
    Product(
      id: '1',
      name: 'Derby Leather Shoes',
      price: 120.0,
      rating: 4.0,
      imageUrl: 'https://res.cloudinary.com/dtpohdm3h/image/upload/v1732482400/shoes_placeholder.png', // Placeholder, will need a real one or asset
      category: "Men's shoe",
      description:
          "A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe.",
    ),
     Product(
      id: '2',
      name: 'Derby Leather Shoes',
      price: 120.0,
      rating: 4.0,
      imageUrl: 'https://res.cloudinary.com/dtpohdm3h/image/upload/v1732482400/shoes_placeholder.png', 
      category: "Men's shoe",
      description: "Another description...",
    ),
  ];
}

