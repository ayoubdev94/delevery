import 'dart:async';

import 'package:delevery/data/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/view_model/sales_cubit/sales_cubit.dart';
import '../../logic/view_model/search_sort_bloc/search_sort_bloc.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  TextEditingController searchItemsController = TextEditingController();
  Timer? _debounce;
  bool _isSearchEmpty = true; // Tracks if search is empty

  @override
  void initState() {
    super.initState();
    searchItemsController.addListener(() {
      setState(() {
        _isSearchEmpty = searchItemsController.text.isEmpty;
      });
    });
  }

/*  @override
  void initState() {
    super.initState();
    // Initialize search controller to listen to changes and update SearchSortBloc
    searchItemsController.addListener(() {
      // Read from the controller and update the SearchSortBloc's search query
      context
          .read<SearchSortBloc>()
          .add(SearchQueryChanged(searchItemsController.text));
    });
  } */
  @override
  void dispose() {
    _debounce?.cancel();
    searchItemsController.dispose();
    super.dispose();
  }

  void _onSearchChanged(BuildContext context, String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<SearchSortBloc>().add(SearchQueryChanged(query));
    });
  }

  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => SalesCubit(),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.sort_by_alpha),
                  title: const Text('Sort by name (A-Z)'),
                  onTap: () {
                    context
                        .read<SearchSortBloc>()
                        .add(SortCriteriaChanged(SortCriteria.nameAsc));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.sort_by_alpha_outlined),
                  title: const Text('Sort by name (Z-A)'),
                  onTap: () {
                    context
                        .read<SearchSortBloc>()
                        .add(SortCriteriaChanged(SortCriteria.nameDesc));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_upward),
                  title: const Text('Sort by price (Low to High)'),
                  onTap: () {
                    context
                        .read<SearchSortBloc>()
                        .add(SortCriteriaChanged(SortCriteria.priceAsc));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_downward),
                  title: const Text('Sort by price (High to Low)'),
                  onTap: () {
                    context
                        .read<SearchSortBloc>()
                        .add(SortCriteriaChanged(SortCriteria.priceDesc));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Enable RTL for Arabic
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المبيعات'),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Menu action
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Header Section
            POSHeader(
              searchController: searchItemsController,
              onSearchChanged: (query) => _onSearchChanged(context, query),
              onSortPressed: () => _showSortModal(context),
            ),

            // Table Headers
            _buildTableHeaders(),

            // Conditionally show list
            if (!_isSearchEmpty) _buildItemsList(),

            // Table Content (placeholder for now)
            if (_isSearchEmpty) _buildCartList(context),

            // Footer Section
            _buildFooter(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Floating action logic
          },
          child: const Icon(Icons.grid_view),
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return Expanded(
      child: BlocConsumer<SearchSortBloc, SearchSortState>(
        listener: (context, state) {
          // Add listener logic if needed
        },
        builder: (context, state) {
          if (state.items.isEmpty) {
            // Improved empty state with better visuals
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text(
                    'لا توجد نتائج بحث عن "${searchItemsController.text}"',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          // ListView with improved item design
          return ListView.builder(
            itemCount: state.items.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return _buildListItem(item);
            },
          );
        },
      ),
    );
  }

  Widget _buildCartList(BuildContext context) {
    bool isDragging = false; // Track the drag state
    double dragStart = 0.0; // Track where the drag started
    double scale = 1.0; // Track the scale of the widget
    Color backgroundColor = Colors.transparent; // Track background color
    return Expanded(
      child: BlocBuilder<SalesCubit, SalesState>(
        builder: (context, state) {
          if (state.cartProducts.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.cartProducts.length,
            itemBuilder: (context, index) {
              final cartProduct = state.cartProducts[index];
              return GestureDetector(
                onHorizontalDragStart: (details) {
                  // Record the initial position of the drag when it starts
                  dragStart = details.localPosition.dx;
                  isDragging = true;
                },
                onHorizontalDragUpdate: (details) {
                  // Only trigger actions if a drag direction change occurs
                  if (isDragging) {
                    double dragDelta = details.localPosition.dx - dragStart;

                    if (dragDelta > 50) {
                      // Dragged right (add 1)
                      context.read<SalesCubit>().increment(index);
                      isDragging = false; // Reset dragging flag
                    } else if (dragDelta < -50) {
                      // Dragged left (subtract 1)
                      context.read<SalesCubit>().decrement(index);
                      isDragging = false; // Reset dragging flag
                    }
                  }
                },
                onHorizontalDragEnd: (_) {
                  // Reset drag state when the drag ends
                  isDragging = false;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(cartProduct.product.name,
                              textAlign: TextAlign.center)),
                      Expanded(
                          child: Text(
                              cartProduct.product.price.toStringAsFixed(2),
                              textAlign: TextAlign.center)),
                      Expanded(
                          child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          // Check if the drag direction is left (subtract 1) or right (add 1)
                          if (details.primaryDelta! < 0) {
                            // Dragging left, decrease quantity by 1 (only if quantity is > 1)
                            context.read<SalesCubit>().increment(index);
                          } else if (details.primaryDelta! > 0) {
                            // Dragging right, increase quantity by 1
                            context.read<SalesCubit>().decrement(index);
                          }
                        },
                        onTap: () {
                          context.read<SalesCubit>().increment(index);
                        },
                        child: Text('${cartProduct.quantity}',
                            textAlign: TextAlign.center),
                      )),
                      Expanded(
                          child: Text(
                              (cartProduct.quantity * cartProduct.product.price)
                                  .toStringAsFixed(2),
                              textAlign: TextAlign.center)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildListItem(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          // Add product to the cart
          context.read<SalesCubit>().addOrUpdateProduct(product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${product.name} added to the cart'),
              duration: const Duration(seconds: 1),
            ),
          );
          searchItemsController.clear();
          context.read<SearchSortBloc>().add(SearchQueryChanged(""));
        },
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blueAccent,
            child: Text(
              product.name.substring(0, 1).toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          title: Text(
            product.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Price: \$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          trailing: const Icon(Icons.add_shopping_cart, color: Colors.green),
        ),
      ),
    );
  }

  Widget _buildTableHeaders() {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: const Row(
        children: [
          Expanded(child: Text('المنتج', textAlign: TextAlign.center)),
          Expanded(child: Text('السعر', textAlign: TextAlign.center)),
          Expanded(child: Text('الكمية', textAlign: TextAlign.center)),
          Expanded(child: Text('الإجمالي', textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildTableRow(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text('منتج $index', textAlign: TextAlign.center)),
          const Expanded(child: Text('100.00', textAlign: TextAlign.center)),
          const Expanded(child: Text('1', textAlign: TextAlign.center)),
          const Expanded(child: Text('100.00', textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final salesCubit = context.watch<SalesCubit>();
    final total = salesCubit.state.total;
    final tax = salesCubit.state.tax;
    final grandTotal = total + tax;

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text('الإجمالي', style: TextStyle(color: Colors.red)),
                Text(total.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text('TAX+', style: TextStyle(color: Colors.green)),
                Text(tax.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.green)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text('ع.ق', style: TextStyle(color: Colors.red)),
                Text(grandTotal.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class POSHeader extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onSortPressed;

  const POSHeader({
    required this.searchController,
    required this.onSearchChanged,
    required this.onSortPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey[200],
              child: const Text(
                '2024-11-30', // Example date
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'بحث عن منتج أو استخدم الكام',
                prefixIcon: BlocBuilder<SearchSortBloc, SearchSortState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: Icon(
                        state.query.isEmpty ? Icons.search : Icons.clear,
                        color: state.query.isEmpty ? Colors.grey : Colors.red,
                      ),
                      onPressed: () {
                        if (state.query.isNotEmpty) {
                          searchController.clear();
                          context
                              .read<SearchSortBloc>()
                              .add(SearchQueryChanged(''));
                        }
                      },
                    );
                  },
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.qr_code),
                      onPressed: () {
                        // Barcode action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.sort, color: Colors.grey[700]),
                      onPressed: onSortPressed,
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
