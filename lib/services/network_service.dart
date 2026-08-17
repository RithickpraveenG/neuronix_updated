import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Network status service to detect online vs offline state.
class NetworkService extends ChangeNotifier {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal() {
    checkConnection();
  }

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  Future<bool> checkConnection() async {
    try {
      final res = await http.get(Uri.parse('http://127.0.0.1:8000/health')).timeout(
        const Duration(seconds: 3),
      );
      final status = res.statusCode == 200;
      if (_isOnline != status) {
        _isOnline = status;
        notifyListeners();
      }
      return _isOnline;
    } catch (_) {
      if (_isOnline) {
        _isOnline = false;
        notifyListeners();
      }
      return false;
    }
  }
}
