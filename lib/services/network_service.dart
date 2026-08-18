import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

/// Network status service to detect online vs offline state.
class NetworkService extends ChangeNotifier {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  Timer? _timer;

  NetworkService._internal() {
    checkConnection();
    _timer = Timer.periodic(const Duration(seconds: 8), (_) => checkConnection());
  }

  bool _isOnline = false;
  bool get isOnline => _isOnline;

  // Hysteresis counters to avoid flicker on slow first requests / cold starts.
  int _consecutiveSuccesses = 0;
  int _consecutiveFailures = 0;
  static const int _successThreshold = 2; // require 2 successful checks to mark online
  static const int _failureThreshold = 3; // require 3 failures to mark offline

  Future<bool> checkConnection() async {
    final baseUrl = ApiConfig.backendBaseUrl.trim();
    final normalizedBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final healthUrl = '$normalizedBaseUrl/health';

    try {
      final res = await http.get(Uri.parse(healthUrl)).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        _consecutiveFailures = 0;
        _consecutiveSuccesses++;
        if (_consecutiveSuccesses >= _successThreshold) {
          if (!_isOnline) {
            _isOnline = true;
            notifyListeners();
          }
        }
        return true;
      }
    } catch (_) {}

    // failure path
    _consecutiveSuccesses = 0;
    _consecutiveFailures++;
    if (_consecutiveFailures >= _failureThreshold) {
      if (_isOnline) {
        _isOnline = false;
        notifyListeners();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
