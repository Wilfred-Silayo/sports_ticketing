import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_ticketing/providers/auth_provider.dart';

final storageAPIProvider = Provider((ref) {
  final storage = FirebaseStorage.instance;
  final currentUser = ref.watch(currentUserAccountProvider).value;
  return StorageAPI(storage: storage, user: currentUser);
});

class StorageAPI {
  final FirebaseStorage _storage;
  final User? _currentUser;
  StorageAPI({required FirebaseStorage storage, User? user})
      : _storage = storage,
        _currentUser = user;

  Future<List<String>> uploadImage(String childName, List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      Reference ref = _storage.ref().child(childName).child(_currentUser!.uid);
      final uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() {});
      final downloadUrl = await ref.getDownloadURL();
      imageLinks.add(downloadUrl);
    }
    return imageLinks;
  }
}
