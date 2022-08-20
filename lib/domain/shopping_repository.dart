import 'package:firebase/domain/shopping_db.dart';
import 'package:firebase/utils/sort_filter_types.dart';

import 'model/buy_item.dart';
import 'shopping_storage.dart';

abstract class ShoppingRepository {
  final ShoppingDB db;
  final ShoppingStorage storage;
  String url = '';

  ShoppingRepository(this.db, this.storage);

  Future<Stream<List<BuyItem>>> initList();

  void addItem(String itemName);

  void updateItem(String itemId, bool isPurchased);

  Future<List<BuyItem>> filterSortItems(
      FilterType filterType, SortType sortType);
}
