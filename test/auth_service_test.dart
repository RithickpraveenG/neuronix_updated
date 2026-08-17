import 'package:flutter_test/flutter_test.dart';
import 'package:neuronix/services/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('signIn sets patient role and email', () async {
    final auth = AuthService();
    await auth.signIn(email: 'patient@example.com', password: 'demo');

    expect(auth.isAuthenticated, isTrue);
    expect(auth.role, 'patient');
    expect(auth.userEmail, 'patient@example.com');
  });

  test('signOut clears the session', () async {
    final auth = AuthService();
    await auth.signIn(email: 'doctor@example.com', password: 'demo');
    await auth.signOut();

    expect(auth.isAuthenticated, isFalse);
    expect(auth.role, 'patient');
  });
}
