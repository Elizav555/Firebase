import 'package:firebase/database/shopping_db.dart';
import 'package:firebase/model/buy_item.dart';

class ShoppingDBInteractor {
  final _db = ShoppingDB();

  Future<BuyItem> addBuyItem(String itemName) async {
    final id = await _db.addBuyItem(itemName);
    return BuyItem(name: itemName, id: id);
  }

  Future<void> updateBuyItem(String id, Map<String, dynamic> changes) =>
      _db.updateBuyItem(id, changes);

  Stream<List<BuyItem>> getListStream() => _db.getAllItemsStream().map(
      (e) => e.map((pair) => BuyItem.fromDB(pair.key, pair.value)).toList());

  Future<List<BuyItem>> getList() async {
    final list = await _db.getAllItems();
    return list.map((pair) => BuyItem.fromDB(pair.key, pair.value)).toList();
  }

  Future<BuyItem> getItem(String id) async {
    final dbItemPair = await _db.getBuyItem(id);
    return BuyItem.fromDB(dbItemPair.key, dbItemPair.value);
  }
}
