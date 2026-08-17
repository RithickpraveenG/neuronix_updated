import 'package:flutter/material.dart';
import '../widgets/health_metric_card.dart';
import '../widgets/neuronix_button.dart';
import '../widgets/neuronix_card.dart';
import '../widgets/responsive_scaffold.dart';
import '../widgets/risk_badge.dart';

class DoctorPatientDetailScreen extends StatefulWidget {
  final String patientName;

  const DoctorPatientDetailScreen({super.key, required this.patientName});

  @override
  State<DoctorPatientDetailScreen> createState() => _DoctorPatientDetailScreenState();
}

class _DoctorPatientDetailScreenState extends State<DoctorPatientDetailScreen> {
  final TextEditingController _notesController = TextEditingController(
    text: 'Patient advised 12-lead ECG and complete blood count. Monitor blood pressure twice daily.',
  );

  bool _isSaved = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveClinicalNotes() {
    setState(() => _isSaved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Clinical notes updated in EHR record.')),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isSaved = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'EHR: ${widget.patientName}',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 950),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Summary Header Banner
                NeuronixCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: const Color(0xFF1E88E5).withOpacity(0.1),
                        child: Text(
                          widget.patientName[0],
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5)),
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
                                  widget.patientName,
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                                const SizedBox(width: 12),
                                const RiskBadge(riskLevel: 'HIGH'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Age 45 • Male • MRN: #NX-94021 • Blood Type: O+',
                              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Patient Vitals Grid
                const Text(
                  'Patient Vital Metrics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
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
                          title: 'Blood Pressure',
                          value: '140/90',
                          unit: 'mmHg',
                          icon: Icons.speed,
                          color: Color(0xFFEF4444),
                          statusText: 'Stage 1 HTN',
                        ),
                        HealthMetricCard(
                          title: 'Heart Rate',
                          value: '84',
                          unit: 'bpm',
                          icon: Icons.favorite,
                          color: Color(0xFF1E88E5),
                          statusText: 'Elevated',
                        ),
                        HealthMetricCard(
                          title: 'SpO2 Level',
                          value: '97',
                          unit: '%',
                          icon: Icons.air,
                          color: Color(0xFF00B4D8),
                          statusText: 'Normal',
                        ),
                        HealthMetricCard(
                          title: 'Temperature',
                          value: '101.2',
                          unit: '°F',
                          icon: Icons.thermostat,
                          color: Color(0xFFF59E0B),
                          statusText: 'Febrile',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),

                // AI Clinical Decision Support Panel (Clearly Tagged as AI)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E88E5).withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1E88E5).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E88E5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'AI Clinical Decision Support (CDS) Assessment',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Extracted Symptoms: Chest pressure, elevated BP 140/90, mild fever 101.2 F, dry cough.',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Scikit-learn Prediction: Hypertensive Concern & Viral Respiratory Risk (Model Confidence: 82%).',
                        style: TextStyle(fontSize: 14, color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 12),
                      const Text('Recommended Investigations:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: const [
                          Chip(label: Text('12-Lead ECG'), backgroundColor: Colors.white),
                          Chip(label: Text('Serum Troponin T'), backgroundColor: Colors.white),
                          Chip(label: Text('Chest X-Ray (PA View)'), backgroundColor: Colors.white),
                          Chip(label: Text('Complete Blood Count'), backgroundColor: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Disclaimer: AI CDS recommendations are generated for physician decision support only.',
                        style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Doctor Clinical Notes Entry Panel (Clearly Tagged as Doctor-Entered)
                const Text(
                  'Attending Physician Clinical Notes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 12),
                NeuronixCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _notesController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Enter Physician Observations & Prescription Orders',
                          hintText: 'Type official clinical notes to save to patient EHR...',
                        ),
                      ),
                      const SizedBox(height: 16),
                      NeuronixButton(
                        label: _isSaved ? 'Notes Saved to EHR ✓' : 'Save Physician Clinical Notes',
                        icon: Icons.save_outlined,
                        onPressed: _saveClinicalNotes,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
