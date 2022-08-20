import 'package:firebase/utils/sort_filter_types.dart';

import '../../../domain/model/buy_item.dart';

abstract class ShoppingListEvent {
  FilterType filterType;
  SortType sortType;

  ShoppingListEvent(this.filterType, this.sortType);
}

class HasDataEvent extends ShoppingListEvent {
  final List<BuyItem> data;
  final String backgroundImageURL;

  HasDataEvent(
      this.data, this.backgroundImageURL, super.filterType, super.sortType);
}

class AddItemEvent extends ShoppingListEvent {
  final String itemName;

  AddItemEvent(this.itemName, super.filterType, super.sortType);
}

class UpdateItemEvent extends ShoppingListEvent {
  final String id;
  final bool isPurchased;

  UpdateItemEvent(this.id, this.isPurchased, super.filterType, super.sortType);
}

class FilterSortItemsEvent extends ShoppingListEvent {
  FilterSortItemsEvent(super.filterType, super.sortType);
}
