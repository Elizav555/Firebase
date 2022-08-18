import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/pair.dart';
import 'buy_item_db.dart';

class ShoppingDB {
  static const _kcollection = 'shopping_list';
  final _shoppingListCollection = FirebaseFirestore.instance
      .collection(_kcollection)
      .withConverter<BuyItemDB>(
          fromFirestore: (snapshot, _) => BuyItemDB.fromJSON(snapshot.data()!),
          toFirestore: (item, _) => item.toJSON());

  Future<String> addBuyItem(String itemName) async {
    final dbItem = BuyItemDB(name: itemName);
    return _shoppingListCollection
        .add(dbItem)
        .then((DocumentReference doc) => doc.id);
  }

  Future<void> updateBuyItem(String id, Map<String, dynamic> changes) =>
      _shoppingListCollection.doc(id).update(changes);

  Stream<List<Pair<String, BuyItemDB>>> getAllItemsStream() =>
      _shoppingListCollection.snapshots().map((event) => event.docs
          .map((e) => Pair<String, BuyItemDB>(key: e.id, value: e.data()))
          .toList());

  Future<List<Pair<String, BuyItemDB>>> getAllItems() =>
      _shoppingListCollection.get().then((value) =>
          value.docs.map((e) => Pair(key: e.id, value: e.data())).toList());

  Future<Pair<String, BuyItemDB>> getBuyItem(String id) async {
    final snapshot = await _shoppingListCollection.doc(id).get();
    return Pair<String, BuyItemDB>(key: snapshot.id, value: snapshot.data()!);
  }
}
