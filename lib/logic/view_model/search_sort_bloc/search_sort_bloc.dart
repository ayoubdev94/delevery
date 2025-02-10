import 'package:bloc/bloc.dart';
 
 import '../../../data/models/product.dart';

part 'search_sort_event.dart';
part 'search_sort_state.dart';

class SearchSortBloc extends Bloc<SearchSortEvent, SearchSortState> {
  final List<Product> allItems; // Assume this is fetched from a data source

  SearchSortBloc(this.allItems)
      : super(SearchSortState(
            items: allItems,
            query: '',
            criteria: SortCriteria.nameAsc,
            selectedCategory: 'All',
            allCategories: _extractCategories(allItems))) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SortCriteriaChanged>(_onSortCriteriaChanged);
    on<CategoryChanged>(_onCategoryChanged);
  }

  static List<String> _extractCategories(List<Product> items) {
    return ['All'] + items.map((item) => item.category).toSet().toList();
  }

  void _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<SearchSortState> emit) {
    final filteredItems = _filterItems(event.query, state.selectedCategory);
    emit(state.copyWith(items: filteredItems, query: event.query));
  }

  void _onSortCriteriaChanged(
      SortCriteriaChanged event, Emitter<SearchSortState> emit) {
    final sortedItems = List<Product>.from(state.items);
    sortedItems.sort((firstItem, secondItem) {
      switch (event.criteria) {
        case SortCriteria.nameAsc:
          return firstItem.name.compareTo(secondItem.name);
        case SortCriteria.nameDesc:
          return secondItem.name.compareTo(firstItem.name);
        case SortCriteria.priceAsc:
          return firstItem.price.compareTo(secondItem.price);
        case SortCriteria.priceDesc:
          return secondItem.price.compareTo(firstItem.price);
        default:
          return 0;
      }
    });
    emit(state.copyWith(items: sortedItems, criteria: event.criteria));
  }

  void _onCategoryChanged(
      CategoryChanged event, Emitter<SearchSortState> emit) {
    final filteredItems = _filterItems(state.query, event.category);
    emit(
        state.copyWith(items: filteredItems, selectedCategory: event.category));
  }

  List<Product> _filterItems(String query, String category) {
    return allItems.where((item) {
      final matchesQuery =
          item.name.toLowerCase().contains(query.toLowerCase()) ||
              item.price.toString().contains(query);
      final matchesCategory = category == 'All' || item.category == category;
      return matchesQuery && matchesCategory;
    }).toList();
  }
}
