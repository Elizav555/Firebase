import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/utils/sort_filter_types.dart';

import '../utils/pair.dart';
import 'buy_item_db.dart';

abstract class ShoppingDB {
  Stream<List<Pair<String, BuyItemDB>>> getAllItemsStream();

  Future<String> addBuyItem(String itemName);

  Future<void> updateBuyItem(String id, Map<String, dynamic> changes);

  Future<Pair<String, BuyItemDB>> getBuyItem(String id);

  Future<List<Pair<String, BuyItemDB>>> filterSortItems(
      FilterType filterType, SortType sortType);

  final FirebaseFirestore _firestore;

  ShoppingDB(this._firestore);
}

class ShoppingDBImpl extends ShoppingDB {
  ShoppingDBImpl(super.firestore);

  static const _kcollection = 'shopping_list';
  late final CollectionReference<BuyItemDB> _shoppingListCollection = _firestore
      .collection(_kcollection)
      .withConverter<BuyItemDB>(
          fromFirestore: (snapshot, _) => BuyItemDB.fromJSON(snapshot.data()!),
          toFirestore: (item, _) => item.toJSON());

  @override
  Future<String> addBuyItem(String itemName) async {
    final dbItem = BuyItemDB(name: itemName);
    return _shoppingListCollection
        .add(dbItem)
        .then((DocumentReference doc) => doc.id);
  }

  @override
  Future<void> updateBuyItem(String id, Map<String, dynamic> changes) =>
      _shoppingListCollection.doc(id).update(changes);

  @override
  Stream<List<Pair<String, BuyItemDB>>> getAllItemsStream() =>
      _shoppingListCollection.snapshots().map((event) => event.docs
          .map((e) => Pair<String, BuyItemDB>(key: e.id, value: e.data()))
          .toList());

  Future<List<Pair<String, BuyItemDB>>> getAllItems() =>
      _shoppingListCollection.get().then((value) =>
          value.docs.map((e) => Pair(key: e.id, value: e.data())).toList());

  @override
  Future<Pair<String, BuyItemDB>> getBuyItem(String id) async {
    final snapshot = await _shoppingListCollection.doc(id).get();
    return Pair<String, BuyItemDB>(key: snapshot.id, value: snapshot.data()!);
  }

  @override
  Future<List<Pair<String, BuyItemDB>>> filterSortItems(FilterType filterType, SortType sortType) {
    Query<BuyItemDB>? resultCollection = _shoppingListCollection.orderBy('name',
        descending: sortType == SortType.descending);
    if (filterType != FilterType.none) {
      resultCollection = resultCollection.where('isPurchased',
          isEqualTo: filterType == FilterType.purchased);
    } else {
      resultCollection = resultCollection.where(
        'isPurchased',
      );
    }
    return resultCollection.get().then((value) =>
        value.docs.map((e) => Pair(key: e.id, value: e.data())).toList());
  }
}
