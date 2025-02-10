part of 'sales_cubit.dart';

class SalesState {
  final List<CartProduct>cartProducts;  // Products in the cart (CartProduct instead of Product)
  final double total;
  final double tax;

  SalesState({
    this.cartProducts = const [],
    this.total = 0.0,
    this.tax = 0.0,
  });

  SalesState copyWith({
    List<CartProduct>? cartProducts,
    double? total,
    double? tax,
  }) {
    return SalesState(
      cartProducts: cartProducts ?? this.cartProducts,
      total: total ?? this.total,
      tax: tax ?? this.tax,
    );
  }
}
