import 'package:flutter/material.dart';

import '../model/buy_item.dart';
import 'app_state.dart';

// class AppStateNotifier with ChangeNotifier {
//   AppState state = AppState.empty();
//
//   void setState({List<BuyItem> newList = const []}) {
//     state = AppState(shoppingList: newList);
//     notifyListeners();
//   }
//
//   void addItem(BuyItem newItem) {
//     state.addItem(newItem);
//     notifyListeners();
//   }
//
//   void checkItem(String id, bool isChecked) {
//     state.checkItem(id, isChecked);
//     notifyListeners();
//   }
// }

class AppStateNotifier with ChangeNotifier {
  AppState state = AppState();

  Future<BuyItem> addItem(int index) => state.addItem(index);

  Stream<List<BuyItem>> getListStream() => state.getListStream();

  Future<void> updateItem(String id, bool isChecked) =>
      state.updateItem(id, isChecked);
}
