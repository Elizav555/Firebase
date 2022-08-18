import 'package:firebase/model/buy_item.dart';

class AppState {
  Map<String, BuyItem> shoppingList = {};

  AppState.empty();

  AppState({required this.shoppingList});

  void addItem(BuyItem newItem) {
    shoppingList[newItem.id] = newItem;
  }

  void checkItem(String id, bool isChecked) {
    shoppingList[id]?.isPurchased = isChecked;
  }
}
