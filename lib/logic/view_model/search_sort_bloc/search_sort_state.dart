part of 'search_sort_bloc.dart';

class SearchSortState {
  final List<Product> items;
  final String query;
  final SortCriteria criteria;
  final String selectedCategory;
  final List<String> allCategories;

  SearchSortState({
    required this.items,
    required this.query,
    required this.criteria,
    required this.selectedCategory,
    required this.allCategories,
  });

  SearchSortState copyWith({
    List<Product>? items,
    String? query,
    SortCriteria? criteria,
    String? selectedCategory,
    List<String>? allCategories,
  }) {
    return SearchSortState(
      items: items ?? this.items,
      query: query ?? this.query,
      criteria: criteria ?? this.criteria,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      allCategories: allCategories ?? this.allCategories,
    );
  }
}
