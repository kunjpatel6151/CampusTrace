import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_trace/backend/models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signUpWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        AppUser newUser = AppUser(
          uid: credential.user!.uid,
          fullName: fullName,
          email: email,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(newUser.uid).set(newUser.toMap());
      }
    } on FirebaseAuthException catch (e) {
      throw _getReadableAuthError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _getReadableAuthError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Exception _getReadableAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return Exception('This email is already registered. Please sign in instead.');
      case 'weak-password':
        return Exception('The password provided is too weak. Please use a stronger password.');
      case 'invalid-email':
        return Exception('The email address is not valid.');
      case 'user-not-found':
      case 'invalid-credential':
        return Exception('Invalid email or password.');
      case 'wrong-password':
        return Exception('Incorrect password. Please try again.');
      case 'network-request-failed':
        return Exception('Network error. Please check your connection and try again.');
      default:
        return Exception(e.message ?? 'An unknown authentication error occurred.');
    }
  }
}
