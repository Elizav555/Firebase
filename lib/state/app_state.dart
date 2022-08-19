import '../model/buy_item.dart';
import '../utils/sort_filter_types.dart';

abstract class AppState {
  FilterType filterType;
  SortType sortType;

  AppState(this.filterType, this.sortType);
}

class AppLoadingState extends AppState {
  AppLoadingState(super.isPurchasedOnly, super.sortType);
}

class AppHasDataState extends AppState {
  final List<BuyItem> data;
  final String backgroundImageURL;

  AppHasDataState(this.data, this.backgroundImageURL, super.isPurchasedOnly,
      super.sortType);
}
