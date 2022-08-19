import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase/database/shopping_db.dart';
import 'package:firebase/utils/sort_filter_types.dart';

import '../model/buy_item.dart';
import '../storage/storage.dart';
import 'app_events.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final ShoppingDB db;
  final ShoppingStorage storage;
  String _url = '';

  AppBloc(this.db, this.storage)
      : super(AppLoadingState(FilterType.none, SortType.ascending)) {
    storage.getBackgroundImage().then((url) {
      _url = url;
      db.getAllItemsStream().listen((data) =>
          add(HasDataEvent(data, _url, FilterType.none, SortType.descending)));
    });
    on<HasDataEvent>(handleHasDataEvent);
    on<AddItemEvent>(handleAddItemEvent);
    on<UpdateItemEvent>(handleUpdateItemEvent);
    on<FilterSortItemsEvent>(handleFilterSortItemsEvent);
  }

  void handleHasDataEvent(HasDataEvent event, Emitter<AppState> emit) {
    final convertedData =
        event.data.map((pair) => BuyItem.fromDB(pair.key, pair.value)).toList();
    emit(AppHasDataState(convertedData, event.backgroundImageURL,
        event.filterType, event.sortType));
  }

  void handleAddItemEvent(AddItemEvent event, Emitter<AppState> emit) {
    db.addBuyItem(event.itemName);
  }

  void handleUpdateItemEvent(UpdateItemEvent event, Emitter<AppState> emit) {
    db.updateBuyItem(event.id, {"isPurchased": event.isPurchased});
  }

  Future<void> handleFilterSortItemsEvent(
      FilterSortItemsEvent event, Emitter<AppState> emit) async {
    emit(AppLoadingState(event.filterType, event.sortType));
    final list = await db.filterSortItems(event.filterType, event.sortType);
    final newData =
        list.map((pair) => BuyItem.fromDB(pair.key, pair.value)).toList();
    emit(AppHasDataState(newData, _url, event.filterType, event.sortType));
  }
}
