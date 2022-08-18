import 'package:flutter/material.dart';

import '../model/buy_item.dart';
import 'app_state.dart';

class AppStateNotifier with ChangeNotifier {
  AppState state = AppState.empty();

  void setState({Map<String, BuyItem> newList = const {}}) {
    state = AppState(shoppingList: newList);
    notifyListeners();
  }

  void addItem(BuyItem newItem) {
    state.addItem(newItem);
    notifyListeners();
  }

  void checkItem(String id, bool isChecked) {
    state.checkItem(id, isChecked);
    notifyListeners();
  }
}
