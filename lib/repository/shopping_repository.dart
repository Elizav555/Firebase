import 'package:firebase/model/buy_item.dart';
import 'package:firebase/repository/shopping_db.dart';
import 'package:firebase/repository/storage.dart';
import 'package:firebase/utils/sort_filter_types.dart';

abstract class ShoppingRepository {
  final ShoppingDB _db;
  final ShoppingStorage _storage;
  String url = '';

  ShoppingRepository(this._db, this._storage);

  Future<Stream<List<BuyItem>>> initList();

  void addItem(String itemName);

  void updateItem(String itemId, bool isPurchased);

  Future<List<BuyItem>> filterSortItems(
      FilterType filterType, SortType sortType);
}

class ShoppingRepositoryImpl extends ShoppingRepository {
  ShoppingRepositoryImpl(super.db, super.storage);

  @override
  Future<Stream<List<BuyItem>>> initList() async {
    url = await _storage.getBackgroundImage();
    return _db.getAllItemsStream().map((list) =>
        list.map((pair) => BuyItem.fromDB(pair.key, pair.value)).toList());
  }

  @override
  void addItem(String itemName) {
    _db.addBuyItem(itemName);
  }

  @override
  void updateItem(String itemId, bool isPurchased) {
    _db.updateBuyItem(itemId, {"isPurchased": isPurchased});
  }

  @override
  Future<List<BuyItem>> filterSortItems(
      FilterType filterType, SortType sortType) async {
    final list = await _db.filterSortItems(filterType, sortType);
    return list.map((pair) => BuyItem.fromDB(pair.key, pair.value)).toList();
  }
}
