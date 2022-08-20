import 'package:firebase_storage/firebase_storage.dart';

abstract class ShoppingStorage {
  Future<String> getBackgroundImage();
}

class ShoppingStorageImpl extends ShoppingStorage {
  final _storageRef = FirebaseStorage.instance.ref();

  @override
  Future<String> getBackgroundImage() {
    final backRef = _storageRef.child("images/background.jpg");
    return backRef.getDownloadURL();
  }
}
