import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================= REGISTER =================
  Future<AppUser?> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        AppUser newUser = AppUser(
          uid: user.uid,
          email: email,
          role: 'student',
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toMap());

        return newUser;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception("Email already registered.");
      } else if (e.code == 'weak-password') {
        throw Exception("Password must be at least 6 characters.");
      } else {
        throw Exception(e.message ?? "Registration failed.");
      }
    }
    return null;
  }

  // ================= LOGIN =================
  Future<AppUser?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        final doc =
        await _firestore.collection('users').doc(user.uid).get();

        return AppUser.fromMap(doc.data()!, user.uid);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("User not found. Please register.");
      } else if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw Exception("Incorrect email or password.");
      } else {
        throw Exception("Login failed. Please try again.");
      }
    }
    return null;
  }
  // ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
  }
}