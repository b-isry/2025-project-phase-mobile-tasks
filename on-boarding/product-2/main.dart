import 'dart:io';
class Product{
  String _name; 
  String _description;
  double _price;

  Product(this._name, this._description, this._price);

  String get name => _name;
  String get description => _description;
  double get price => _price;

  set name(String newName){
    if (newName.isNotEmpty){
      _name = newName;
    }
    else{
      print("Name can't be empty.");
    }
  }

  set description(String newDescription){
    _description = newDescription;
  }

  set price(double newPrice) {
    if (newPrice >= 0) {
      _price = newPrice;
    } else {
      print("Price cannot be negative.");
    }
  }

  void display(){
    print('Product: $_name');
    print('Description: $_description');
    print('Price: $_price');
  }
}

class ProductManager{
  final List<Product> _products = [];

  void addProduct(){
    stdout.write("Enter product name: ");
    String? name = stdin.readLineSync();

    stdout.write("Enter Description: ");
    String? description = stdin.readLineSync();

    stdout.write("Enter the price: ");
    double? price = double.tryParse(stdin.readLineSync() ?? '');

    if (name == null || name.isEmpty || description == null || price == null) {
      print("Invalid input. Try again.\n");
      return;
    }
    _products.add(Product(name, description, price));
    print("Product added.\n");
  }

  void viewAll(){
    if (_products.isEmpty) {
      print("No products.\n");
    }
    else{
      for (var i = 0; i < _products.length; i++) {
        print("ID: ${i+1}");
        _products[i].display();
      }
    }
  }

  void viewSingle() {
    stdout.write("Enter the product ID to view: ");
    int? id = int.tryParse(stdin.readLineSync() ?? '');
    if (id == null || id < 1 || id > _products.length) {
      print("Invalid ID!");
      return;
    }
    _products[id-1].display();
  }

  void editProduct() {
    stdout.write("Enter the produst id to edit: ");
    int? id = int.tryParse(stdin.readLineSync() ?? '');
    if (id == null || id < 1 || id > _products.length) {
      print("Invalid ID!");
      return;
    }
    Product product = _products[id - 1];
    stdout.write("Enter new name (leave blank to keep '${product.name}'): ");
    String? newName = stdin.readLineSync();
    if (newName != null && newName.isNotEmpty) {
      product.name = newName;
    }

    stdout.write("Enter new description (leave blank to keep '${product.description}'): ");
    String? newDesc = stdin.readLineSync();
    if (newDesc != null && newDesc.isNotEmpty) {
      product.description = newDesc;
    }

    stdout.write("Enter new price (leave blank to keep ${product.price}): ");
    String? newPriceInput = stdin.readLineSync();
    if (newPriceInput != null && newPriceInput.isNotEmpty) {
      double? newPrice = double.tryParse(newPriceInput);
      if (newPrice != null) {
        product.price = newPrice;
      } else {
        print("Invalid price input.");
      }
    }
    print("Product updated!\n");
  }

  void deleteProduct() {
    stdout.write("Enter the produst id to delete: ");
    int? id = int.tryParse(stdin.readLineSync() ?? '');
    if (id == null || id < 1 || id > _products.length) {
      print("Invalid ID!");
      return;
    }
    _products.removeAt(id-1);
    print("Product deleted!");
  }
}

void main(){
  ProductManager manager = ProductManager();
  bool isRunning = true;

  print("Welcome to eCommerce CLI App!\n");
  while (isRunning) {
    print("========= MENU =========");
    print("1. Add Product");
    print("2. View All Products");
    print("3. View Single Product");
    print("4. Edit Product");
    print("5. Delete Product");
    print("6. Exit");
    print("========================");

        stdout.write("Choose an option: ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        manager.addProduct();
        break;
      case '2':
        manager.viewAll();
        break;
      case '3':
        manager.viewSingle();
        break;
      case '4':
        manager.editProduct();
        break;
      case '5':
        manager.deleteProduct();
        break;
      case '6':
        print("Exiting...");
        isRunning = false;
        break;
      default:
        print("Invalid option. Try again.\n");
    }
  }

}



