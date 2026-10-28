import 'dart:io';
import 'dart:math';

import 'package:explorer/features/books/data/book_details_model.dart';
import 'package:explorer/features/core/data/stations_model.dart';
import 'package:explorer/misc/firebase_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

int randomNumber(int min, int max) {
  final random = Random();
  final int next = min + random.nextInt(max - min);
  return next;
}

Future<String> uploadFile({
  required String collection,
  required File file,
}) async {
  final String ext = file.path.split('.').last;
  final Reference firebaseStorageRef = FBC.storage
      .ref()
      .child("$collection/${DateTime.now().toIso8601String()}.$ext");
  final UploadTask uploadTask = firebaseStorageRef.putFile(file);
  final TaskSnapshot taskSnapshot = await uploadTask;
  final String storagePath = await taskSnapshot.ref.getDownloadURL();
  return storagePath;
}

Future<void> increaseBookViewCount() async {}

Future<void> addStation(StationModel stationModel) async {
  try {
    await FBC.stationsCollection.doc(stationModel.id).set(stationModel.toMap());
    EasyLoading.showSuccess("Station Added");
  } catch (e) {
    EasyLoading.showError(e.toString());
  }
}
String processStation(BookDetails book, List<StationModel> stations) {
    String stationName = '';
    for (final element in stations) {
      if (element.id == book.stationID) {
        stationName = element.name;
      }
    }
    return stationName;
  }
