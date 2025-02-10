import 'package:delevery/data/models/product.dart';

class CartProduct {
  final Product product; // The product itself
  int quantity; // The quantity of the product in the cart

  CartProduct({
    required this.product,
    this.quantity = 1, // Default quantity to 1 if not provided
  });

  // You can also add methods to update or manage CartProduct if needed
}
