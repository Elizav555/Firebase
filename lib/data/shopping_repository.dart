import 'package:firebase/utils/sort_filter_types.dart';

import '../domain/model/buy_item.dart';
import '../domain/shopping_repository.dart';

class ShoppingRepositoryImpl extends ShoppingRepository {
  ShoppingRepositoryImpl(super.db, super.storage);

  @override
  Future<Stream<List<BuyItem>>> initList() async {
    url = await storage.getBackgroundImage();
    return db.getAllItemsStream();
  }

  @override
  void addItem(String itemName) {
    db.addBuyItem(itemName);
  }

  @override
  void updateItem(String itemId, bool isPurchased) {
    db.updateBuyItem(itemId, {"isPurchased": isPurchased});
  }

  @override
  Future<List<BuyItem>> filterSortItems(
      FilterType filterType, SortType sortType) {
    return db.filterSortItems(filterType, sortType);
  }
}
