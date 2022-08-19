import '../model/buy_item.dart';

abstract class AppState {}

class AppLoadingState extends AppState {}

class AppHasDataState extends AppState {
  final List<BuyItem> data;
  final String backgroundImageURL;

  AppHasDataState(this.data, this.backgroundImageURL);
}
