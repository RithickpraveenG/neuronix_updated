import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../widgets/neuronix_card.dart';
import '../widgets/responsive_scaffold.dart';
import '../widgets/risk_badge.dart';
import '../widgets/stat_card.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  final List<Map<String, dynamic>> _patientRoster = [
    {
      'id': 'p1',
      'name': 'Alex Morgan',
      'age': 45,
      'gender': 'Male',
      'risk': 'HIGH',
      'symptoms': 'Chest pressure, elevated BP 140/90',
      'lastVisit': 'Today, 9:00 AM',
      'status': 'Pending Review',
    },
    {
      'id': 'p2',
      'name': 'Nia Chen',
      'age': 62,
      'gender': 'Female',
      'risk': 'CRITICAL',
      'symptoms': 'Shortness of breath, oxygen 91%',
      'lastVisit': 'Today, 10:15 AM',
      'status': 'Urgent Triage',
    },
    {
      'id': 'p3',
      'name': 'Marcus Vance',
      'age': 34,
      'gender': 'Male',
      'risk': 'MODERATE',
      'symptoms': 'Persistent cough, mild fever 100.4 F',
      'lastVisit': 'Yesterday',
      'status': 'Follow-Up Needed',
    },
    {
      'id': 'p4',
      'name': 'Sophia Patel',
      'age': 28,
      'gender': 'Female',
      'risk': 'LOW',
      'symptoms': 'Routine annual vitals monitoring',
      'lastVisit': 'Aug 10, 2026',
      'status': 'Stable Baseline',
    },
  ];

  String _filterRisk = 'ALL';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final doctorName = auth.displayName.isNotEmpty ? auth.displayName : 'Dr. Rivera';

    final filteredList = _filterRisk == 'ALL'
        ? _patientRoster
        : _patientRoster.where((p) => p['risk'] == _filterRisk).toList();

    return ResponsiveScaffold(
      title: 'Doctor Clinical Workspace',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning, $doctorName',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Clinical decision support & patient triage overview.',
                          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/symptom-checker'),
                      icon: const Icon(Icons.psychology, size: 18),
                      label: const Text('Run CDS Analysis'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Clinical Stat Summary Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 700;
                    return GridView.count(
                      crossAxisCount: isWide ? 4 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      childAspectRatio: isWide ? 1.8 : 1.4,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        StatCard(
                          title: 'Today\'s Visits',
                          value: '8 Patients',
                          icon: Icons.calendar_today,
                          color: Color(0xFF1E88E5),
                        ),
                        StatCard(
                          title: 'High Risk Alerts',
                          value: '2 Urgent',
                          icon: Icons.warning_amber,
                          color: Color(0xFFEF4444),
                        ),
                        StatCard(
                          title: 'Pending Reviews',
                          value: '5 Reports',
                          icon: Icons.assignment_outlined,
                          color: Color(0xFFF59E0B),
                        ),
                        StatCard(
                          title: 'Total Roster',
                          value: '42 Active',
                          icon: Icons.people_outline,
                          color: Color(0xFF10B981),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),

                // Patient Priority Triage Filter & Roster Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Patient Triage Roster',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Row(
                      children: ['ALL', 'CRITICAL', 'HIGH', 'MODERATE', 'LOW'].map((risk) {
                        final isSelected = _filterRisk == risk;
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: ChoiceChip(
                            selected: isSelected,
                            label: Text(risk, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                            selectedColor: const Color(0xFF1E88E5),
                            backgroundColor: const Color(0xFFF1F5F9),
                            onSelected: (_) => setState(() => _filterRisk = risk),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Patient List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final patient = filteredList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NeuronixCard(
                        onTap: () => context.push('/doctor-patient-detail', extra: patient['name']),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFF1E88E5).withOpacity(0.1),
                              child: Text(
                                (patient['name'] as String)[0],
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${patient['name']} (${patient['age']}y, ${patient['gender']})',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                      ),
                                      const SizedBox(width: 10),
                                      RiskBadge(riskLevel: patient['risk'] as String),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Symptoms: ${patient['symptoms']}',
                                    style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Last Visit: ${patient['lastVisit']} • Status: ${patient['status']}',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => context.push('/doctor-patient-detail', extra: patient['name']),
                              child: const Text('Review EHR', style: TextStyle(fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
