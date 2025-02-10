/* import 'dart:async';

import 'package:delevery/logic/view_model/sales_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_styles.dart';
import '../../data/models/item_model.dart';
import '../../logic/view_model/sales_cubit/sales_cubit.dart';
import '../../logic/view_model/search_sort_bloc/search_sort_bloc.dart';

class SearchSortScreen extends StatefulWidget {
  const SearchSortScreen({super.key});

  @override
  State<SearchSortScreen> createState() => _SearchSortScreenState();
}

class _SearchSortScreenState extends State<SearchSortScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search and Sort'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchInput(context),
          /*  _buildCategoryList(context), */          _buildCartList(),

          if (!_isSearchEmpty) _buildItemsList(), // Conditionally show list
        ],
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchItemsController,
        onChanged: (query) => _onSearchChanged(context, query),
        decoration: AppStyles.inputDecoration.copyWith(
          hintText: 'Search items...',
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.sort, color: Colors.grey[700]),
                onPressed: () {
                  _showSortModal(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.clear, color: Colors.grey[700]),
                onPressed: () {
                  searchItemsController.clear();
                  context.read<SearchSortBloc>().add(SearchQueryChanged(""));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: BlocBuilder<SearchSortBloc, SearchSortState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: state.allCategories.map((category) {
                final bool isSelected = category == state.selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      context
                          .read<SearchSortBloc>()
                          .add(CategoryChanged(category));
                    },
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No items found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return _buildListItem(item);
            },
          );
        },
      ),
    );
  }

  Widget _buildCartList( ) {
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, state) {
        
        return ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            final product = state.products[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price: \$${455}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quantity: ${5}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        if (product.quantity > 1) {
                          // Decrease quantity
                          context.read<SalesCubit>().updateProductQuantity(
                              index, product.quantity - 1);
                        } else {
                          // Remove product if quantity is 1
                          context.read<SalesCubit>().removeProduct(index);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.green),
                      onPressed: () {
                        // Increase quantity
                        context
                            .read<SalesCubit>()
                            .updateProductQuantity(index, product.quantity + 1);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListItem(Product item) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            item.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${item.price.toStringAsFixed(2)}'),
            Text('Category: ${item.category}',
                style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          // Add your onTap logic here
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Handle navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              // Handle navigation
            },
          ),
        ],
      ),
    );
  }

  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
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
        );
      },
    );
  }
}
 */