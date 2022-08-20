import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/utils/sort_filter_types.dart';

import '../domain/model/buy_item.dart';
import '../domain/shopping_db.dart';
import '../utils/pair.dart';
import 'buy_item_db.dart';
import 'mapper.dart';

class ShoppingDBImpl extends ShoppingDB {
  ShoppingDBImpl(super.firestore);

  static const _kcollection = 'shopping_list';
  late final CollectionReference<BuyItemDB> _shoppingListCollection = firestore
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
  Stream<List<BuyItem>> getAllItemsStream() =>
      _shoppingListCollection.snapshots().map((event) => event.docs
          .map((e) => BuyItemsMapper.mapBuyItemFromDB(e.id, e.data()))
          .toList());

  Future<List<Pair<String, BuyItemDB>>> getAllItems() =>
      _shoppingListCollection.get().then((value) =>
          value.docs.map((e) => Pair(key: e.id, value: e.data())).toList());

  @override
  Future<BuyItem> getBuyItem(String id) async {
    final snapshot = await _shoppingListCollection.doc(id).get();
    return BuyItemsMapper.mapBuyItemFromDB(snapshot.id, snapshot.data()!);
  }

  @override
  Future<List<BuyItem>> filterSortItems(
      FilterType filterType, SortType sortType) {
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
    return resultCollection.get().then((value) => value.docs
        .map((e) => BuyItemsMapper.mapBuyItemFromDB(e.id, e.data()))
        .toList());
  }
}
