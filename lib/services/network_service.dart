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
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => checkConnection());
  }

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  Future<bool> checkConnection() async {
    final baseUrl = ApiConfig.backendBaseUrl;
    final targets = <String>[
      '$baseUrl/health',
      'http://localhost:8000/health',
      'http://127.0.0.1:8000/health',
    ];

    for (final url in targets) {
      try {
        final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));
        if (res.statusCode == 200) {
          if (!_isOnline) {
            _isOnline = true;
            notifyListeners();
          }
          return true;
        }
      } catch (_) {}
    }

    if (_isOnline) {
      _isOnline = false;
      notifyListeners();
    }
    return false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
