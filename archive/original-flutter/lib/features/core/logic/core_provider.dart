import 'package:explorer/features/auth/data/user_model.dart';
import 'package:explorer/features/books/data/book_request_model.dart';
import 'package:explorer/features/core/data/stations_model.dart';
import 'package:explorer/features/core/logic/core_notfier.dart';
import 'package:explorer/utils/api_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomBarIndex = StateProvider<int>((ref) => 0);
final bottomPageController = StateProvider<PageController>(
  (ref) => PageController(initialPage: ref.watch(bottomBarIndex)),
);

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, ApiState<UserDataModel?>>((ref) {
  return CurrentUserNotifier();
});
// Current User Related Providers
final currentUserData = StateProvider<UserDataModel?>(
  (ref) => ref.watch(currentUserProvider).maybeWhen(
    orElse: () {
      return null;
    },
    loaded: (data) {
      return data;
    },
  ),
);
//Admin Related Providers
final adminListProvider =
    StateNotifierProvider<AdminsNotifier, ApiState<List<String>>>((ref) {
  return AdminsNotifier();
});

final alladminProvider = StateProvider<List<String>>((ref) {
  return ref
      .watch(adminListProvider)
      .maybeWhen(orElse: () => [], loaded: (data) => data);
});
final allUserProvider =
    StateNotifierProvider<AllUserNotifier, ApiState<List<UserDataModel>>>(
        (ref) {
  return AllUserNotifier();
});
final isAdminProvider = StateProvider<bool>((ref) {
  return ref
      .watch(alladminProvider)
      .contains(FirebaseAuth.instance.currentUser?.uid);
});
//

//Station Related Providers
final stationsProvider =
    StateNotifierProvider<AllStationsNotifier, ApiState<List<StationModel>>>(
        (ref) {
  return AllStationsNotifier();
});

final allStationsProvider = StateProvider<List<StationModel>>((ref) {
  return ref
      .watch(stationsProvider)
      .maybeWhen(orElse: () => [], loaded: (data) => data);
});
// booksProvider
final allbookRequestProvider = StateNotifierProvider<AllBookRequestNotifier,
    ApiState<List<BookRequestModel>>>((ref) {
  return AllBookRequestNotifier();
});

final allBookRequestProvider = StateProvider<List<BookRequestModel>>((ref) {
  return ref
      .watch(allbookRequestProvider)
      .maybeWhen(orElse: () => [], loaded: (data) => data);
});
