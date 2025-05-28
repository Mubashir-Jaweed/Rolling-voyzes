import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      log("Error Failed to sign in anonymously: $e");
      return null;
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.snackbar("Success", "You have been signed out.");
    } catch (e) {
      Get.snackbar("Error", "Failed to sign out: $e");
    }
  }

  // Get current user UID
  String? getCurrentUserUid() {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future<String?> login(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return null; // success
  } on FirebaseAuthException catch (e) {
    return e.message;
  }
}

Future<String?> signUp(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return null; // success
  } on FirebaseAuthException catch (e) {
    return e.message;
  }
}

}
