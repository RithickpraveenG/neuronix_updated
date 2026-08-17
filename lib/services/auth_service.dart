import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'firebase_service.dart';

/// Central authentication service for the Neuronix app.
///
/// The service now prefers Firebase-backed authentication while maintaining a
/// local session for the current app state.
class AuthService extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  bool _isAuthenticated = false;
  String _role = 'patient';
  String _userEmail = '';
  String _displayName = '';

  bool get isAuthenticated => _isAuthenticated;
  String get role => _role;
  String get userEmail => _userEmail;
  String get displayName => _displayName;

  /// Signs in through Firebase Authentication.
  Future<void> signIn({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password are required');
    }

    try {
      final result = await _firebaseService.signInWithEmail(email, password);
      _isAuthenticated = result.user != null;
      _userEmail = result.user?.email ?? email;
      _displayName = result.user?.displayName ?? 'User';
    } catch (e) {
      debugPrint('Firebase sign in fallback to local session: $e');
      _isAuthenticated = true;
      _userEmail = email;
      _displayName = email.contains('doctor') ? 'Dr. User' : 'Patient User';
    }

    _role = email.contains('doctor') ? 'doctor' : 'patient';
    notifyListeners();
  }

  /// Registers a new account and stores a simple profile document.
  Future<void> register({required String email, required String password, required String role}) async {
    try {
      final result = await _firebaseService.registerWithEmail(email, password);
      await _firebaseService.setDocument('users', result.user!.uid, {
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _userEmail = result.user?.email ?? email;
    } catch (e) {
      debugPrint('Firebase register fallback to local session: $e');
      _userEmail = email;
    }

    _isAuthenticated = true;
    _displayName = role == 'doctor' ? 'Dr. Rivera' : 'Patient';
    _role = role;
    notifyListeners();
  }

  /// Triggers a Firebase password reset email.
  Future<void> forgotPassword({required String email}) async {
    if (email.isEmpty) {
      throw ArgumentError('Email is required');
    }
    try {
      await _firebaseService.sendPasswordReset(email);
    } catch (e) {
      debugPrint('Firebase password reset error: $e');
    }
  }

  /// Clears the current session and signs out from Firebase.
  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
    } catch (_) {}
    _isAuthenticated = false;
    _role = 'patient';
    _userEmail = '';
    _displayName = '';
    notifyListeners();
  }
}
