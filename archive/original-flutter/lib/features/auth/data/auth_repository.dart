import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthRepo {
  FirebaseAuth fAuth = FirebaseAuth.instance;

  Future<UserCredential> loginUser({
    required String email,
    required String password,
  });
  Future<UserCredential> registerUser({
    required String email,
    required String password,
  });
  bool isLoggedIn();
  Future<bool> logOutUser();
}

class AuthRepo extends IAuthRepo {
  @override
  bool isLoggedIn() {
    if (fAuth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> logOutUser() async {
    try {
      await fAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    final UserCredential userCred = await fAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCred;
  }

  @override
  Future<UserCredential> registerUser({
    required String email,
    required String password,
  }) async {
    final UserCredential userCred = await fAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCred;
  }
}
