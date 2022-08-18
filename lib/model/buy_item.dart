import 'package:firebase/database/buy_item_db.dart';

class BuyItem {
  final String id;
  final String name;
  bool isPurchased;

  BuyItem({required this.name, required this.id, this.isPurchased = false});

  BuyItemDB toDB() => BuyItemDB(name: name, isPurchased: isPurchased);

  factory BuyItem.fromDB(String id, BuyItemDB itemDB) =>
      BuyItem(name: itemDB.name, id: id, isPurchased: itemDB.isPurchased);
}
