import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

/// Firebase service facade for authentication, Firestore, storage, and messaging.
class FirebaseService extends ChangeNotifier {
  FirebaseService() {
    _initialize();
  }

  static bool _isFirebaseInitialized = false;

  static Future<void> initializeFirebase() async {
    if (_isFirebaseInitialized) return;
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }
      _isFirebaseInitialized = true;
    } catch (e) {
      debugPrint('Firebase init error: $e');
    }
  }

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseStorage get _storage => FirebaseStorage.instance;

  bool _initialized = false;
  bool get isInitialized => _initialized || _isFirebaseInitialized;
  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<void> _initialize() async {
    await initializeFirebase();
    _initialized = true;
    notifyListeners();
  }

  // Authentication
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmail(String email, String password) async {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Firestore helpers
  Future<void> setDocument(String collection, String id, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(id).set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getDocument(String collection, String id) async {
    final result = await _firestore.collection(collection).doc(id).get();
    if (!result.exists) return null;
    return result.data();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  // Storage helpers
  Future<String> uploadFile(String path, String fileName, Uint8List bytes) async {
    final ref = _storage.ref().child(path).child(fileName);
    final task = await ref.putData(bytes);
    return task.ref.getDownloadURL();
  }

  // Messaging placeholder for push notifications
  Future<void> sendNotification(String userId, String title, String body) async {
    await _firestore.collection('notifications').add({
      'userId': userId,
      'title': title,
      'body': body,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
