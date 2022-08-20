import '../domain/model/buy_item.dart';
import 'buy_item_db.dart';

class BuyItemsMapper {
  static BuyItemDB mapBuyItemToDB(BuyItem item) =>
      BuyItemDB(name: item.name, isPurchased: item.isPurchased);

  static BuyItem mapBuyItemFromDB(String id, BuyItemDB itemDB) =>
      BuyItem(name: itemDB.name, id: id, isPurchased: itemDB.isPurchased);
}
