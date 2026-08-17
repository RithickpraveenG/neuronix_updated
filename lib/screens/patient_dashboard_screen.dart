import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../widgets/feature_card.dart';

class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              if (!context.mounted) return;
              context.go('/auth');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Welcome back, ${auth.displayName.isEmpty ? 'Patient' : auth.displayName}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Your care companion for symptoms, history, and follow-ups.', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 20),
          const FeatureCard(title: 'AI Symptom Checker', subtitle: 'Describe symptoms and receive guided insights.'),
          const FeatureCard(title: 'Upload Medical Report', subtitle: 'Upload PDF or image reports for AI-assisted review.'),
          const FeatureCard(title: 'Health Timeline', subtitle: 'Track medications, diagnoses, and appointments.'),
          const FeatureCard(title: 'Appointments', subtitle: 'Book and view upcoming visits with your clinician.'),
          const FeatureCard(title: 'Emergency Contact', subtitle: 'Keep your essential contacts accessible.'),
        ],
      ),
    );
  }
}
