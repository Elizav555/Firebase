import '../database/buy_item_db.dart';
import '../utils/pair.dart';

abstract class AppEvent {}

class HasDataEvent extends AppEvent {
  final List<Pair<String, BuyItemDB>> data;

  HasDataEvent(this.data);
}

class AddItemEvent extends AppEvent {
  final String itemName;

  AddItemEvent(this.itemName);
}

class UpdateItemEvent extends AppEvent {
  final String id;
  final bool isPurchased;

  UpdateItemEvent(this.id, this.isPurchased);
}
