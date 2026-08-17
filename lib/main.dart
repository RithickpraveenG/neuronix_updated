import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes/app_router.dart';
import 'services/auth_service.dart';
import 'services/firebase_service.dart';
import 'services/network_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FirebaseService.initializeFirebase();
  } catch (e) {
    debugPrint('Firebase initialization warning: $e');
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FirebaseService()),
        ChangeNotifierProvider(create: (_) => NetworkService()),
      ],
      child: const NeuronixApp(),
    ),
  );
}

class NeuronixApp extends StatelessWidget {
  const NeuronixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Neuronix Healthcare Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
