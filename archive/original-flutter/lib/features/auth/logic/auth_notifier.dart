import 'package:explorer/features/auth/data/auth_repository.dart';
import 'package:explorer/misc/firebase_constants.dart';
import 'package:explorer/utils/api_state.dart';
import 'package:explorer/utils/network_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginNotfier extends StateNotifier<ApiState<UserCredential>> {
  final IAuthRepo iAuthRepo;
  LoginNotfier(this.iAuthRepo) : super(const ApiState.initial());
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      state = const ApiState.loading();

      final user = await iAuthRepo.loginUser(email: email, password: password);
      FBC.loginCollection.add({
        'user': user.user?.uid,
        'type': 0,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
      state = ApiState.loaded(data: user);
    } catch (e) {
      state = ApiState.error(
        error: NetworkExceptions.getErrorMessage(
          NetworkExceptions.getDioException(e),
        ),
      );
    }
  }
}

class RegistrationNotfier extends StateNotifier<ApiState<UserCredential>> {
  final IAuthRepo iAuthRepo;
  RegistrationNotfier(this.iAuthRepo) : super(const ApiState.initial());
  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      state = const ApiState.loading();
      final user =
          await iAuthRepo.registerUser(email: email, password: password);
      FBC.loginCollection.add({
        'user': user.user?.uid,
        'type': 0,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
      state = ApiState.loaded(data: user);
    } catch (e) {
      state = ApiState.error(
        error: NetworkExceptions.getErrorMessage(
          NetworkExceptions.getDioException(e),
        ),
      );
    }
  }
}

class LogoutNotifier extends StateNotifier<ApiState<bool>> {
  final IAuthRepo iAuthRepo;
  LogoutNotifier(this.iAuthRepo) : super(const ApiState.initial());
  Future<void> logOut() async {
    try {
      state = const ApiState.loading();
      FBC.loginCollection.add({
        'user': FirebaseAuth.instance.currentUser?.uid,
        'type': 1,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
      final user = await iAuthRepo.logOutUser();
      state = ApiState.loaded(data: user);
    } catch (e) {
      state = ApiState.error(
        error: NetworkExceptions.getErrorMessage(
          NetworkExceptions.getDioException(e),
        ),
      );
    }
  }
}
