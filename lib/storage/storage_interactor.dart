import 'package:firebase/storage/storage.dart';

class StorageInteractor {
  final _storage = ShoppingStorage();

  Future<String> getBackgroundImage() => _storage.getBackgroundImage();
}
