import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FBC {
  FBC._();
  static final storage = FirebaseStorage.instance;
  static final booksCollection =
      FirebaseFirestore.instance.collection(FBCD.books);
  static final bookRequestCollection =
      FirebaseFirestore.instance.collection(FBCD.bookRequests);
  static final usersCollection =
      FirebaseFirestore.instance.collection(FBCD.users);
  static final adminsCollection =
      FirebaseFirestore.instance.collection(FBCD.admins);
  static final stationsCollection =
      FirebaseFirestore.instance.collection(FBCD.stations);
  static final loginCollection =
      FirebaseFirestore.instance.collection(FBCD.loginLog);
}

class FBCD {
  // Storasge Directory names
  FBCD._();
  static const books = "books";
  static const bookRequests = "bookRequests";
  static const users = "users";
  static const admins = "admins";
  static const stations = "stations";
  static const loginLog = "loginLog";
}
