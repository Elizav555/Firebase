import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../repository/shopping_repository.dart';
import '../../utils/sort_filter_types.dart';
import 'shopping_list_events.dart';
import 'shopping_list_state.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  final ShoppingRepository _repository;

  ShoppingListBloc(this._repository)
      : super(ListLoadingState(FilterType.none, SortType.ascending)) {
    on<HasDataEvent>(handleHasDataEvent);
    on<AddItemEvent>(handleAddItemEvent);
    on<UpdateItemEvent>(handleUpdateItemEvent);
    on<FilterSortItemsEvent>(handleFilterSortItemsEvent);
  }

  void init() {
    _repository.initList().then((stream) {
      stream.listen((data) => add(HasDataEvent(
          data, _repository.url, FilterType.none, SortType.descending)));
    });
  }

  void handleHasDataEvent(HasDataEvent event, Emitter<ShoppingListState> emit) {
    emit(ListHasDataState(
        event.data, _repository.url, event.filterType, event.sortType));
  }

  void handleAddItemEvent(AddItemEvent event, Emitter<ShoppingListState> emit) {
    _repository.addItem(event.itemName);
  }

  void handleUpdateItemEvent(
      UpdateItemEvent event, Emitter<ShoppingListState> emit) {
    _repository.updateItem(event.id, event.isPurchased);
  }

  Future<void> handleFilterSortItemsEvent(
      FilterSortItemsEvent event, Emitter<ShoppingListState> emit) async {
    emit(ListLoadingState(event.filterType, event.sortType));
    final newData =
        await _repository.filterSortItems(event.filterType, event.sortType);
    emit(ListHasDataState(
        newData, _repository.url, event.filterType, event.sortType));
  }
}
