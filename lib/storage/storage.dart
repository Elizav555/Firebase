import 'package:firebase_storage/firebase_storage.dart';

class ShoppingStorage {
  final _storageRef = FirebaseStorage.instance.ref();

  Future<String> getBackgroundImage() {
    final backRef = _storageRef.child("images/background.jpg");
    return backRef.getDownloadURL();
  }
}
