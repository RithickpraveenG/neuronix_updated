import 'package:flutter_test/flutter_test.dart';
import 'package:neuronix/services/firebase_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('firebase service initializes and exposes current user state', () async {
    final service = FirebaseService();
    await Future.delayed(const Duration(milliseconds: 200));
    expect(service.isInitialized, isTrue);
  });
}
