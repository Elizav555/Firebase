import 'package:bloc/bloc.dart';
import 'package:firebase/database/shopping_db.dart';

import '../model/buy_item.dart';
import '../storage/storage.dart';
import 'app_events.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final ShoppingDB db;
  final ShoppingStorage storage;

  AppBloc(this.db, this.storage) : super(AppLoadingState()) {
    storage.getBackgroundImage().then((url) =>
        db.getAllItemsStream().listen((data) => add(HasDataEvent(data, url))));
    on<HasDataEvent>(handleHasDataEvent);
    on<AddItemEvent>(handleAddItemEvent);
    on<UpdateItemEvent>(handleUpdateItemEvent);
  }

  void handleHasDataEvent(HasDataEvent event, Emitter<AppState> emit) {
    final convertedData =
        event.data.map((pair) => BuyItem.fromDB(pair.key, pair.value)).toList();
    emit(AppHasDataState(convertedData, event.backgroundImageURL));
  }

  void handleAddItemEvent(AddItemEvent event, Emitter<AppState> emit) {
    db.addBuyItem(event.itemName);
  }

  void handleUpdateItemEvent(UpdateItemEvent event, Emitter<AppState> emit) {
    db.updateBuyItem(event.id, {"isPurchased": event.isPurchased});
  }
}
