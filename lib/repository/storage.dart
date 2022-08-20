import 'package:firebase_storage/firebase_storage.dart';

abstract class ShoppingStorage {
  Future<String> getBackgroundImage();

  final FirebaseStorage _storage;

  ShoppingStorage(this._storage);
}

class ShoppingStorageImpl extends ShoppingStorage {
  late final _storageRef = _storage.ref();

  ShoppingStorageImpl(super.storage);

  @override
  Future<String> getBackgroundImage() {
    final backRef = _storageRef.child("images/background.jpg");
    return backRef.getDownloadURL();
  }
}
