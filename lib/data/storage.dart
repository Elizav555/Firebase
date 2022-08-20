import '../domain/shopping_storage.dart';

class ShoppingStorageImpl extends ShoppingStorage {
  late final _storageRef = storage.ref();

  ShoppingStorageImpl(super.storage);

  @override
  Future<String> getBackgroundImage() {
    final backRef = _storageRef.child("images/background.jpg");
    return backRef.getDownloadURL();
  }
}
