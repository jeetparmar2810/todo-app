import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../core/constants/app_strings.dart';
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

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;

    } on FirebaseAuthException catch (e) {
      String message = AppStrings.defaultError;

      if (e.code == 'user-not-found') {
        message = AppStrings.userNotFound;
      } else if (e.code == 'wrong-password') {
        message = AppStrings.wrongPassword;
      } else if (e.code == 'invalid-credential') {
        message = AppStrings.invalidCredentials;
      }

      showSnack(context, message);
      return false;

    } catch (_) {
      showSnack(context, AppStrings.somethingWentWrong);
      return false;

    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(BuildContext context, String email, String password) async {
    try {
      loading = true;
      notifyListeners();

      await _auth.signUp(email, password);

      showSnack(context, AppStrings.registerSuccess);
      return true;

    } on FirebaseAuthException catch (e) {
      String message = AppStrings.defaultError;

      if (e.code == 'email-already-in-use') {
        message = AppStrings.emailAlreadyUsed;
      } else if (e.code == 'invalid-email') {
        message = AppStrings.emailInvalid;
      } else if (e.code == 'weak-password') {
        message = AppStrings.passwordShort;
      } else {
        message = AppStrings.registrationFailed;
      }

      showSnack(context, message);
      return false;

    } catch (_) {
      showSnack(context, AppStrings.somethingWentWrong);
      return false;

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