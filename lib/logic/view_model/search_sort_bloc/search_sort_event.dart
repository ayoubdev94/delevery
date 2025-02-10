part of 'search_sort_bloc.dart';

abstract class SearchSortEvent {}

class SearchQueryChanged extends SearchSortEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class SortCriteriaChanged extends SearchSortEvent {
  final SortCriteria criteria;
  SortCriteriaChanged(this.criteria);
}

class CategoryChanged extends SearchSortEvent {
  final String category;
  CategoryChanged(this.category);
}

enum SortCriteria { nameAsc, nameDesc, priceAsc, priceDesc }
