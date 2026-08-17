import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'network_status_badge.dart';

class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const ResponsiveScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isDoctor = auth.role == 'doctor';
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;

    final navItems = isDoctor
        ? [
            const NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
            const NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Patients'),
            const NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_today), label: 'Visits'),
            const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          ]
        : [
            const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            const NavigationDestination(icon: Icon(Icons.medical_services_outlined), selectedIcon: Icon(Icons.medical_services), label: 'Checker'),
            const NavigationDestination(icon: Icon(Icons.upload_file_outlined), selectedIcon: Icon(Icons.upload_file), label: 'Reports'),
            const NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: 'Vitals'),
            const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          ];

    void handleNavTap(int index) {
      if (isDoctor) {
        switch (index) {
          case 0:
            context.go('/doctor');
            break;
          case 1:
            context.go('/doctor');
            break;
          case 2:
            context.go('/appointments');
            break;
          case 3:
            context.go('/profile');
            break;
        }
      } else {
        switch (index) {
          case 0:
            context.go('/patient');
            break;
          case 1:
            context.go('/symptom-checker');
            break;
          case 2:
            context.go('/report-upload');
            break;
          case 3:
            context.go('/health-dashboard');
            break;
          case 4:
            context.go('/profile');
            break;
        }
      }
    }

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            // Desktop Sidebar
            Container(
              width: 250,
              color: const Color(0xFF0A192F),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E88E5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.local_hospital, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'NEURONIX',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFF1E293B)),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.dashboard_outlined, color: Colors.white70),
                    title: Text(isDoctor ? 'Doctor Workspace' : 'Patient Workspace', style: const TextStyle(color: Colors.white)),
                    onTap: () => context.go(isDoctor ? '/doctor' : '/patient'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.healing_outlined, color: Colors.white70),
                    title: const Text('Symptom Checker', style: TextStyle(color: Colors.white70)),
                    onTap: () => context.go('/symptom-checker'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_present_outlined, color: Colors.white70),
                    title: const Text('Lab Reports', style: TextStyle(color: Colors.white70)),
                    onTap: () => context.go('/report-upload'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.monitor_heart_outlined, color: Colors.white70),
                    title: const Text('Vitals & Trends', style: TextStyle(color: Colors.white70)),
                    onTap: () => context.go('/health-dashboard'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.event_outlined, color: Colors.white70),
                    title: const Text('Appointments', style: TextStyle(color: Colors.white70)),
                    onTap: () => context.go('/appointments'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined, color: Colors.white70),
                    title: const Text('Notifications', style: TextStyle(color: Colors.white70)),
                    onTap: () => context.go('/notifications'),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: NetworkStatusBadge(),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
                    onTap: () async {
                      await auth.signOut();
                      if (!context.mounted) return;
                      context.go('/auth');
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // Desktop Content Body
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(title),
                  actions: [
                    const NetworkStatusBadge(),
                    const SizedBox(width: 12),
                    if (actions != null) ...actions!,
                    IconButton(
                      icon: const Icon(Icons.person_outline),
                      onPressed: () => context.go('/profile'),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                body: body,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          const NetworkStatusBadge(),
          const SizedBox(width: 8),
          if (actions != null) ...actions!,
        ],
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        destinations: navItems,
        onDestinationSelected: handleNavTap,
      ),
    );
  }
}
