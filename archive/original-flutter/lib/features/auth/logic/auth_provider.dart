import 'package:explorer/features/auth/data/auth_repository.dart';
import 'package:explorer/features/auth/logic/auth_notifier.dart';
import 'package:explorer/utils/api_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//
//
//
// Provides Authorization repository
final authRepositoryProvider = Provider<IAuthRepo>((ref) => AuthRepo());
//
//
//
// Provides Current Auth Instance
final fAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
//
//
//
// Provides login Methods and States
final loginProvider =
    StateNotifierProvider.autoDispose<LoginNotfier, ApiState<UserCredential>>(
        (ref) {
  return LoginNotfier(ref.watch(authRepositoryProvider));
});
//
//
//
// Provides registration Methods and States
final registrationProvider = StateNotifierProvider.autoDispose<
    RegistrationNotfier, ApiState<UserCredential>>((ref) {
  return RegistrationNotfier(ref.watch(authRepositoryProvider));
});

//
//
//
// Provides logout Methods and States
final logOutProvider =
    StateNotifierProvider.autoDispose<LogoutNotifier, ApiState<bool>>((ref) {
  return LogoutNotifier(ref.watch(authRepositoryProvider));
});
