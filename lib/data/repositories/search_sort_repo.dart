 import 'package:delevery/data/models/product.dart';

class SearchSortRepo {
  // Fetch Data From API
  static List<Product> getProducts() {
    final List<Product> sampleProducts = [
      Product(id: '01', name: 'Apple', price: 1.99, category: 'Fruit', stockQuantity: 10),
      Product(id: '02', name: 'Banana', price: 0.99, category: 'Fruit', stockQuantity: 10),
      Product(id: '03', name: 'Cherry', price: 2.99, category: 'Fruit', stockQuantity: 10),
      Product(id: '04', name: 'Date', price: 3.49, category: 'Fruit', stockQuantity: 10),
      Product(id: '05', name: 'Elderberry', price: 4.99, category: 'Fruit', stockQuantity: 10),
      Product(id: '06', name: 'Fig', price: 2.49, category: 'Fruit', stockQuantity: 10),
      Product(id: '07', name: 'Grapes', price: 2.99, category: 'Fruit', stockQuantity: 10),
      Product(id: '08', name: 'Honeydew', price: 3.99, category: 'Fruit', stockQuantity: 10),
      Product(id: '09', name: 'Iceberg Lettuce', price: 1.49, category: 'Vegetable', stockQuantity: 10),
      Product(id: '10', name: 'Jalapeno', price: 1.99, category: 'Vegetable', stockQuantity: 10),
      Product(id: '11', name: 'Kale', price: 2.99, category: 'Vegetable', stockQuantity: 10),
      Product(id: '12', name: 'Lemon', price: 0.89, category: 'Fruit', stockQuantity: 10),
      Product(id: '13', name: 'Mango', price: 1.49, category: 'Fruit', stockQuantity: 10),
      Product(id: '14', name: 'Nectarine', price: 2.49, category: 'Fruit', stockQuantity: 10),
      Product(id: '15', name: 'Orange', price: 1.29, category: 'Fruit', stockQuantity: 10),
      Product(id: '16', name: 'Peach', price: 2.29, category: 'Fruit', stockQuantity: 10),
      Product(id: '17', name: 'Quince', price: 3.99, category: 'Fruit', stockQuantity: 10),
      Product(id: '18', name: 'Radish', price: 1.19, category: 'Vegetable', stockQuantity: 10),
      Product(id: '19', name: 'Spinach', price: 1.99, category: 'Vegetable', stockQuantity: 10),
      Product(id: '20', name: 'Tomato', price: 1.99, category: 'Vegetable', stockQuantity: 10),
      Product(id: '21', name: 'Ugli Fruit', price: 4.99, category: 'Fruit', stockQuantity: 10),
      Product(id: '22', name: 'Vidalia Onion', price: 0.79, category: 'Vegetable', stockQuantity: 10),
      Product(id: '23', name: 'Watermelon', price: 3.99, category: 'Fruit', stockQuantity: 10),
      Product(id: '24', name: 'Xigua', price: 5.99, category: 'Fruit', stockQuantity: 10),
      Product(id: '25', name: 'Yellow Pepper', price: 2.49, category: 'Vegetable', stockQuantity: 10),
      Product(id: '26', name: 'Zucchini', price: 1.29, category: 'Vegetable', stockQuantity: 10),
    ];
    return sampleProducts;
  }
}
