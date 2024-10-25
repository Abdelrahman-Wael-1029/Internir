import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireStorage {
  FireStorage._();

  static final _storage = FirebaseStorage.instance;
  static Future<String> uploadFile({
    required String path,
    required String fileName,
    required Uint8List file,
    String? contentType,
  }) async {
    Reference ref = _storage.ref().child(path).child(fileName);
    UploadTask uploadTask = ref.putData(
      file,
      SettableMetadata(contentType: contentType),
    );
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  static Future<bool> deleteFile(String ref) async {
    try {
      await _storage.ref(ref).delete();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
