import '../../../domain/model/buy_item.dart';
import '../../../utils/sort_filter_types.dart';

abstract class ShoppingListState {
  FilterType filterType;
  SortType sortType;

  ShoppingListState(this.filterType, this.sortType);
}

class ListLoadingState extends ShoppingListState {
  ListLoadingState(super.filterType, super.sortType);
}

class ListHasDataState extends ShoppingListState {
  final List<BuyItem> data;
  final String backgroundImageURL;

  ListHasDataState(
      this.data, this.backgroundImageURL, super.filterType, super.sortType);
}
