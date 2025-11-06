import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/auth_service.dart';
import '../core/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  return AuthViewModel();
});

class AuthViewModel extends ChangeNotifier {
  final AuthService _auth = AuthService();
  bool loading = false;

  User? get currentUser => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();


  Future<bool> signIn(BuildContext context, String email, String password) async {
    try {
      loading = true;
      notifyListeners();

      await _auth.signIn(email,password);

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(BuildContext context, String email, String password) async {
    try {
      loading = true;
      notifyListeners();
      await _auth.signUp(email, password);
      showSnack(context, 'Registration successful');
    } on FirebaseAuthException catch (e) {
      showSnack(context, e.message ?? 'Registration failed');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
