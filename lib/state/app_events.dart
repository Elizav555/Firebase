import 'package:firebase/utils/sort_filter_types.dart';

import '../database/buy_item_db.dart';
import '../utils/pair.dart';

abstract class AppEvent {
  FilterType filterType;
  SortType sortType;

  AppEvent(this.filterType, this.sortType);
}

class HasDataEvent extends AppEvent {
  final List<Pair<String, BuyItemDB>> data;
  final String backgroundImageURL;

  HasDataEvent(this.data, this.backgroundImageURL, super.isPurchasedOnly,
      super.sortType);
}

class AddItemEvent extends AppEvent {
  final String itemName;

  AddItemEvent(this.itemName, super.isPurchasedOnly, super.sortType);
}

class UpdateItemEvent extends AppEvent {
  final String id;
  final bool isPurchased;

  UpdateItemEvent(
      this.id, this.isPurchased, super.isPurchasedOnly, super.sortType);
}

class FilterSortItemsEvent extends AppEvent {
  FilterSortItemsEvent(super.isPurchasedOnly, super.sortType);
}
