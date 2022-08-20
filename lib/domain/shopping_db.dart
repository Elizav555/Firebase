import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/sort_filter_types.dart';
import 'model/buy_item.dart';

abstract class ShoppingDB {
  Stream<List<BuyItem>> getAllItemsStream();

  Future<String> addBuyItem(String itemName);

  Future<void> updateBuyItem(String id, Map<String, dynamic> changes);

  Future<BuyItem> getBuyItem(String id);

  Future<List<BuyItem>> filterSortItems(
      FilterType filterType, SortType sortType);

  final FirebaseFirestore firestore;

  ShoppingDB(this.firestore);
}
