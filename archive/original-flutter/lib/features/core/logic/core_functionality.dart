import 'dart:io';

import 'package:explorer/misc/firebase_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CoreMethods {
  CoreMethods._();
  static Future<String?> uploadimage({
    required File file,
    required String directory,
  }) async {
    final String title = DateTime.now().toIso8601String();
    final Reference _storageReference =
        FBC.storage.ref().child(directory).child(title);

    final UploadTask _uploadTask = _storageReference.putFile(file);
    final TaskSnapshot taskSnapshot = await _uploadTask;
    final String storagePath = await taskSnapshot.ref.getDownloadURL();
    return storagePath;
  }
}
