import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage mStorage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFiles(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await mStorage.ref('bigmarket/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  // Future<firebase_storage.ListResult> getListFiles() async {
  //   firebase_storage.ListResult results =
  //       await storage.ref('bigmarket').listAll();
  //   print('list data'+results.items.length.toString());
  //   return results;
  // }
}
