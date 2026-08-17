import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../widgets/neuronix_button.dart';
import '../widgets/neuronix_card.dart';
import '../widgets/responsive_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isDoctor = auth.role == 'doctor';
    final name = auth.displayName.isNotEmpty
        ? auth.displayName
        : (isDoctor ? 'Dr. Rivera' : 'Alex Morgan');
    final email = auth.userEmail.isNotEmpty ? auth.userEmail : (isDoctor ? 'rivera@hospital.org' : 'alex@example.com');

    return ResponsiveScaffold(
      title: 'User Profile & Settings',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Banner Card
                NeuronixCard(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: const Color(0xFF1E88E5).withOpacity(0.1),
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E88E5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDoctor
                                    ? const Color(0xFF00B4D8).withOpacity(0.1)
                                    : const Color(0xFF1E88E5).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isDoctor ? 'Licensed Physician' : 'Registered Patient',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDoctor ? const Color(0xFF00B4D8) : const Color(0xFF1E88E5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Personal Details Section
                const Text(
                  'Personal Medical Record',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 12),
                NeuronixCard(
                  child: Column(
                    children: [
                      _buildProfileItem(Icons.bloodtype_outlined, 'Blood Type', 'O Positive (O+)'),
                      const Divider(height: 1),
                      _buildProfileItem(Icons.phone_outlined, 'Emergency Contact', '+1 (555) 019-2831'),
                      const Divider(height: 1),
                      _buildProfileItem(Icons.medical_services_outlined, 'Primary Physician', 'Dr. Rivera (Cardiology)'),
                      const Divider(height: 1),
                      _buildProfileItem(Icons.history_edu_outlined, 'Medical History', 'Prior mild hypertension, Asthma'),
                      const Divider(height: 1),
                      _buildProfileItem(Icons.warning_amber_outlined, 'Known Allergies', 'Penicillin (Mild rash)'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Security & Actions
                const Text(
                  'Account & Security',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 12),
                NeuronixCard(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.shield_outlined, color: Color(0xFF1E88E5)),
                        title: const Text('Firebase HIPAA Compliance & Privacy'),
                        subtitle: const Text('End-to-end encrypted Firestore record storage'),
                        trailing: const Icon(Icons.chevron_right, size: 20),
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.lock_reset_outlined, color: Color(0xFF1E88E5)),
                        title: const Text('Change Account Password'),
                        subtitle: const Text('Request email reset token'),
                        trailing: const Icon(Icons.chevron_right, size: 20),
                        onTap: () async {
                          await auth.forgotPassword(email: email);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password reset instructions requested.')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                NeuronixButton(
                  label: 'Sign Out of Neuronix',
                  isSecondary: true,
                  icon: Icons.logout,
                  onPressed: () async {
                    await auth.signOut();
                    if (!context.mounted) return;
                    context.go('/auth');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF64748B)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
