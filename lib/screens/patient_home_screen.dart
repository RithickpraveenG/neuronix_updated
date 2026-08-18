import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/health_metric_card.dart';
import '../widgets/neuronix_card.dart';
import '../widgets/responsive_scaffold.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final name = auth.displayName.isNotEmpty ? auth.displayName : 'Alex Morgan';

    return ResponsiveScaffold(
      title: 'Patient Dashboard',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 640;

                if (isCompact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Good morning, $name',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: const Color(0xFF1E88E5).withOpacity(0.1),
                            child: const Icon(Icons.person, color: Color(0xFF1E88E5), size: 24),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Here's your personal AI health overview & care plan.",
                        style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                      ),
                    ],
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning, $name',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Here's your personal AI health overview & care plan.",
                            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF1E88E5).withOpacity(0.1),
                      child: const Icon(Icons.person, color: Color(0xFF1E88E5), size: 28),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // AI Insight Feature Highlight
            AIInsightCard(
              title: 'AI Health Assessment Ready',
              description:
                  'No critical health anomalies detected today. Your vital metrics are within expected baseline ranges.',
              actionLabel: 'Check Symptoms Now',
              onAction: () => context.push('/symptom-checker'),
            ),
            const SizedBox(height: 24),

            // Quick Actions Grid
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth;
                final columns = itemWidth >= 1100
                    ? 4
                    : itemWidth >= 760
                        ? 3
                        : itemWidth >= 500
                            ? 2
                            : 1;

                return GridView.count(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.5,
                  children: [
                    _buildActionCard(
                      context,
                      title: 'Symptom Checker',
                      subtitle: 'AI Risk Evaluation',
                      icon: Icons.healing,
                      color: const Color(0xFF1E88E5),
                      onTap: () => context.push('/symptom-checker'),
                    ),
                    _buildActionCard(
                      context,
                      title: 'Upload Report',
                      subtitle: 'OCR & NLP Processing',
                      icon: Icons.document_scanner,
                      color: const Color(0xFF00B4D8),
                      onTap: () => context.push('/report-upload'),
                    ),
                    _buildActionCard(
                      context,
                      title: 'Health Vitals',
                      subtitle: 'Track Vitals & Trends',
                      icon: Icons.favorite,
                      color: const Color(0xFF10B981),
                      onTap: () => context.push('/health-dashboard'),
                    ),
                    _buildActionCard(
                      context,
                      title: 'Appointments',
                      subtitle: 'Schedule Consultation',
                      icon: Icons.calendar_today,
                      color: const Color(0xFF8B5CF6),
                      onTap: () => context.push('/appointments'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),

            // Vitals Metric Cards Overview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Vitals & Metrics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/health-dashboard'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                return GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  childAspectRatio: 1.2,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    HealthMetricCard(
                      title: 'Heart Rate',
                      value: '72',
                      unit: 'bpm',
                      icon: Icons.favorite_outline,
                      color: Color(0xFFEF4444),
                      statusText: 'Normal',
                    ),
                    HealthMetricCard(
                      title: 'Blood Pressure',
                      value: '120/80',
                      unit: 'mmHg',
                      icon: Icons.speed,
                      color: Color(0xFF1E88E5),
                      statusText: 'Optimal',
                    ),
                    HealthMetricCard(
                      title: 'SpO2 Level',
                      value: '98',
                      unit: '%',
                      icon: Icons.air,
                      color: Color(0xFF00B4D8),
                      statusText: 'Normal',
                    ),
                    HealthMetricCard(
                      title: 'Sleep Average',
                      value: '7.5',
                      unit: 'hrs',
                      icon: Icons.bedtime_outlined,
                      color: Color(0xFF8B5CF6),
                      statusText: 'Restful',
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),

            // Upcoming Appointment Preview Card
            const Text(
              'Upcoming Care Visit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            NeuronixCard(
              onTap: () => context.push('/appointments'),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.event, color: Color(0xFF1E88E5), size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Cardiology Consultation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Dr. Rivera • Thursday, 10:30 AM',
                          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Confirmed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return NeuronixCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
