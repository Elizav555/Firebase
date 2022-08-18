import 'package:firebase/model/buy_item.dart';

class AppState {
  List<BuyItem> shoppingList = [];

  AppState.empty();

  AppState({required this.shoppingList});

  void addItem(BuyItem newItem) {
    shoppingList.add(newItem);
  }

  void checkItem(String id, bool isChecked) {
    shoppingList.firstWhere((item) => item.id == id).isPurchased = isChecked;
  }
}
