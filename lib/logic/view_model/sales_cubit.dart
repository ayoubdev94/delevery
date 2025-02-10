/* import 'package:delevery/data/models/item_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit for Sales
class SalesCubit extends Cubit<SalesState> {
  SalesCubit() : super(SalesState());

  get totalPrice => null;

  get tax => null;

  // Add or update a product in the list
  void addOrUpdateProduct(Product product) {
    final existingProductIndex =
        state.products.indexWhere((p) => p.name == product.name);

    if (existingProductIndex != -1) {
      // If the product already exists, update the quantity
      final updatedProducts = List<Product>.from(state.products);
      updatedProducts[existingProductIndex].quantity += product.quantity;
      emit(state.copyWith(products: updatedProducts));
    } else {
      // If the product is new, add it to the list
      final updatedProducts = List<Product>.from(state.products)..add(product);
      emit(state.copyWith(products: updatedProducts));
    }

    _updateTotals();
  }

  // Remove a product from the list
  void removeProduct(int index) {
    if (index >= 0 && index < state.products.length) {
      final updatedProducts = List<Product>.from(state.products)
        ..removeAt(index);
      emit(state.copyWith(products: updatedProducts));
      _updateTotals();
    }
  }

  // Update the quantity of a product
  void updateProductQuantity(int index, int newQuantity) {
    if (index >= 0 && index < state.products.length && newQuantity > 0) {
      final updatedProducts = List<Product>.from(state.products);
      updatedProducts[index].quantity = newQuantity;
      emit(state.copyWith(products: updatedProducts));
      _updateTotals();
    }
  }

  // Private method to update totals
  void _updateTotals() {
    double total = 0.0;
    for (final product in state.products) {
      total += product.price * product.quantity;
    }
    emit(state.copyWith(total: total));
  }
}

// Sales State
class SalesState {
  final List<Product> products; // Products in the invoice
  final List<Product> allProducts; // All available products
  final List<Product> filteredProducts; // Search results
  final double total;

  SalesState({
    this.products = const [],
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.total = 0.0,
  });

  SalesState copyWith({
    List<Product>? products,
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    double? total,
  }) {
    return SalesState(
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      total: total ?? this.total,
    );
  }
}
 */