import 'package:delevery/data/models/cart_product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/product.dart';

part 'sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  SalesCubit() : super(SalesState());

  // Add or update a product in the cart
  void addOrUpdateProduct(Product product) {
    final existingProductIndex = state.cartProducts.indexWhere(
      (cartProduct) => cartProduct.product.id == product.id,
    );

    if (existingProductIndex != -1) {
      // If the product already exists in the cart, update its quantity
      final updatedCartProducts = List<CartProduct>.from(state.cartProducts);
      updatedCartProducts[existingProductIndex].quantity +=
          1; // Increase quantity by 1
      emit(state.copyWith(cartProducts: updatedCartProducts));
    } else {
      // If the product is new, add it to the cart
      final newCartProduct = CartProduct(product: product);
      final updatedCartProducts = List<CartProduct>.from(state.cartProducts)
        ..add(newCartProduct);
      emit(state.copyWith(cartProducts: updatedCartProducts));
    }

    _updateTotals();
  }

  // Remove a product from the cart
  void removeProduct(int index) {
    if (index >= 0 && index < state.cartProducts.length) {
      final updatedCartProducts = List<CartProduct>.from(state.cartProducts)
        ..removeAt(index);
      emit(state.copyWith(cartProducts: updatedCartProducts));
      _updateTotals();
    }
  }

  // Update the quantity of a product in the cart
  void updateProductQuantity(int index, int newQuantity) {
    if (index >= 0 && index < state.cartProducts.length && newQuantity > 0) {
      final updatedCartProducts = List<CartProduct>.from(state.cartProducts);
      updatedCartProducts[index].quantity = newQuantity;
      emit(state.copyWith(cartProducts: updatedCartProducts));
      _updateTotals();
    }
  }

  // Function to increment the quantity of a product by 1
  void increment(int index) {
    if (index >= 0 && index < state.cartProducts.length) {
      final updatedCartProducts = List<CartProduct>.from(state.cartProducts);
      updatedCartProducts[index].quantity += 1; // Increase quantity by 1
      emit(state.copyWith(cartProducts: updatedCartProducts));
      _updateTotals();
    }
  }

  // Function to decrement the quantity of a product by 1, but not below 1
  void decrement(int index) {
    if (index >= 0 && index < state.cartProducts.length) {
      final updatedCartProducts = List<CartProduct>.from(state.cartProducts);
      if (updatedCartProducts[index].quantity > 1) {
        updatedCartProducts[index].quantity -= 1; // Decrease quantity by 1
        emit(state.copyWith(cartProducts: updatedCartProducts));
        _updateTotals();
      }
    }
  }

  // Private method to update totals (total price and tax)
  void _updateTotals() {
    double total = 0.0;
    for (final cartProduct in state.cartProducts) {
      total += cartProduct.product.price * cartProduct.quantity;
    }

    // Assuming tax rate is 10%
    double tax = total * 0.10;

    emit(state.copyWith(total: total, tax: tax));
  }
}
