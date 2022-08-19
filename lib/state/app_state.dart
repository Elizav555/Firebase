import 'package:firebase/model/buy_item.dart';
import 'package:firebase/storage/storage_interactor.dart';

import '../database/db_interactor.dart';

// class AppState {
//   List<BuyItem> shoppingList = [];
//
//   AppState.empty();
//
//   AppState({required this.shoppingList});
//
//   void addItem(BuyItem newItem) {
//     shoppingList.add(newItem);
//   }
//
//   void checkItem(String id, bool isChecked) {
//     shoppingList.firstWhere((item) => item.id == id).isPurchased = isChecked;
//   }
// }

class AppState {
  final _dbInteractor = ShoppingDBInteractor();

  Future<BuyItem> addItem(int index) async {
    return await _dbInteractor.addBuyItem("NewItem$index");
  }

  Stream<List<BuyItem>> getListStream() => _dbInteractor.getListStream();

  Future<void> updateItem(String id, bool isChecked) =>
      _dbInteractor.updateBuyItem(id, {"isPurchased": isChecked});

  final _storageInteractor = StorageInteractor();

  Future<String> getBackgroundImageURL() =>
      _storageInteractor.getBackgroundImage();

  String? backgroundImageURL;
}
