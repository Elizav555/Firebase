import 'package:firebase_storage/firebase_storage.dart';

abstract class ShoppingStorage {
  Future<String> getBackgroundImage();

  final FirebaseStorage storage;

  ShoppingStorage(this.storage);
}
