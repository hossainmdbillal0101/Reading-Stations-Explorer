import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/features/auth/data/user_model.dart';
import 'package:explorer/features/books/data/book_request_model.dart';
import 'package:explorer/features/core/data/stations_model.dart';
import 'package:explorer/misc/firebase_constants.dart';
import 'package:explorer/utils/api_state.dart';
import 'package:explorer/utils/network_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentUserNotifier extends StateNotifier<ApiState<UserDataModel?>> {
  CurrentUserNotifier() : super(const ApiState.initial()) {
    getAllBooks();
  }
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _streamSub;

  Future<void> getAllBooks() async {
    state = const ApiState.loading();
    try {
      _streamSub = FBC.usersCollection
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots()
          .listen((event) {
        if (event.exists) {
          state = ApiState.loaded(data: UserDataModel.fromMap(event.data()!));
        } else {
          state = const ApiState.loaded(data: null);
        }
      });
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }

  @override
  void dispose() {
    if (_streamSub != null) {
      _streamSub!.cancel();
    }

    super.dispose();
  }
}

class AllUserNotifier extends StateNotifier<ApiState<List<UserDataModel>>> {
  AllUserNotifier() : super(const ApiState.initial()) {
    getAllUsers();
  }
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _streamSub;

  Future<void> getAllUsers() async {
    state = const ApiState.loading();
    try {
      _streamSub = FBC.usersCollection.snapshots().listen((event) {
        if (event.docs.isNotEmpty) {
          final List<UserDataModel> users = [];
          for (final element in event.docs) {
            users.add(UserDataModel.fromMap(element.data()));
          }
          state = ApiState.loaded(data: users);
        } else {
          state = const ApiState.loaded(data: []);
        }
      });
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }

  @override
  void dispose() {
    if (_streamSub != null) {
      _streamSub!.cancel();
    }

    super.dispose();
  }
}

class AdminsNotifier extends StateNotifier<ApiState<List<String>>> {
  AdminsNotifier() : super(const ApiState.initial()) {
    getAllAdmins();
  }
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _streamSub;

  Future<void> getAllAdmins() async {
    state = const ApiState.loading();
    try {
      _streamSub = FBC.adminsCollection.snapshots().listen((event) {
        if (event.docs.isNotEmpty) {
          final List<String> data = [];
          for (final element in event.docs) {
            data.add(element.id);
          }

          state = ApiState.loaded(data: data);
        } else {
          state = const ApiState.loaded(data: []);
        }
      });
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }

  @override
  void dispose() {
    if (_streamSub != null) {
      _streamSub!.cancel();
    }

    super.dispose();
  }
}

class AllStationsNotifier extends StateNotifier<ApiState<List<StationModel>>> {
  AllStationsNotifier() : super(const ApiState.initial()) {
    getAllStations();
  }
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _streamSub;

  Future<void> getAllStations() async {
    state = const ApiState.loading();
    try {
      _streamSub = FBC.stationsCollection.snapshots().listen((event) {
        if (event.docs.isNotEmpty) {
          final List<StationModel> data = [];
          for (final element in event.docs) {
            var station = StationModel.fromMap(element.data());
            if (station.id == null) {
              station = station.copyWith(id: element.id);
              FBC.stationsCollection.doc(element.id).set(station.toMap());
            }
            data.add(station);
          }

          state = ApiState.loaded(data: data);
        } else {
          state = const ApiState.loaded(data: []);
        }
      });
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }

  @override
  void dispose() {
    if (_streamSub != null) {
      _streamSub!.cancel();
    }

    super.dispose();
  }
}

class AllBookRequestNotifier
    extends StateNotifier<ApiState<List<BookRequestModel>>> {
  AllBookRequestNotifier() : super(const ApiState.initial()) {
    getAllbookRequests();
  }
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _streamSub;

  Future<void> getAllbookRequests() async {
    state = const ApiState.loading();
    try {
      _streamSub = FBC.bookRequestCollection.snapshots().listen((event) {
        if (event.docs.isNotEmpty) {
          final List<BookRequestModel> data = [];
          for (final element in event.docs) {
            var station = BookRequestModel.fromMap(element.data());
            if (station.requestID == null) {
              station = station.copyWith(requestID: element.id);
              FBC.bookRequestCollection.doc(element.id).set(station.toMap());
            }
            data.add(station);
          }
          state = ApiState.loaded(data: data);
        } else {
          state = const ApiState.loaded(data: []);
        }
      });
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }

  @override
  void dispose() {
    if (_streamSub != null) {
      _streamSub!.cancel();
    }

    super.dispose();
  }
}
