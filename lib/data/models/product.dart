class Product {
  final String id;
  final String name;
  final double price;
  int stockQuantity;
  final String category;

  // Add other relevant fields

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.category,
      required this.stockQuantity});
}
