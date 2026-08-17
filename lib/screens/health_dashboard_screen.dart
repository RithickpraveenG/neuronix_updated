import 'package:flutter/material.dart';
import '../widgets/health_metric_card.dart';
import '../widgets/neuronix_card.dart';
import '../widgets/responsive_scaffold.dart';

class HealthDashboardScreen extends StatefulWidget {
  const HealthDashboardScreen({super.key});

  @override
  State<HealthDashboardScreen> createState() => _HealthDashboardScreenState();
}

class _HealthDashboardScreenState extends State<HealthDashboardScreen> {
  final List<Map<String, dynamic>> _vitalsHistory = [
    {'date': 'Today, 8:30 AM', 'type': 'Blood Pressure', 'value': '120/80 mmHg', 'status': 'Optimal'},
    {'date': 'Yesterday, 9:15 PM', 'type': 'Heart Rate', 'value': '72 bpm', 'status': 'Normal'},
    {'date': 'Yesterday, 8:00 AM', 'type': 'SpO2 Oxygen', 'value': '98%', 'status': 'Normal'},
    {'date': 'Aug 12, 2026', 'type': 'Body Weight', 'value': '68.5 kg', 'status': 'Stable'},
  ];

  void _showAddMetricDialog() {
    final typeController = TextEditingController(text: 'Heart Rate');
    final valueController = TextEditingController(text: '75 bpm');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Health Metric'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Metric Name (e.g. Heart Rate, Blood Pressure)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(labelText: 'Reading Value (e.g. 75 bpm, 120/80)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (valueController.text.isNotEmpty) {
                setState(() {
                  _vitalsHistory.insert(0, {
                    'date': 'Just Now',
                    'type': typeController.text,
                    'value': valueController.text,
                    'status': 'Normal',
                  });
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save Reading'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Health Vitals & Trends',
      actions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Add Reading',
          onPressed: _showAddMetricDialog,
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vitals Monitoring Dashboard',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        SizedBox(height: 4),
                        Text('Continuous baseline vitals and health metric history.', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddMetricDialog,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Log Metric'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Metrics Grid Overview
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
                          icon: Icons.favorite,
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
                          icon: Icons.bedtime,
                          color: Color(0xFF8B5CF6),
                          statusText: 'Restful',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),

                // Recent Vitals Log History
                const Text(
                  'Recent Reading History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _vitalsHistory.length,
                  itemBuilder: (context, index) {
                    final item = _vitalsHistory[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: NeuronixCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E88E5).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.monitor_heart, color: Color(0xFF1E88E5), size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['type'] as String,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                                  ),
                                  Text(
                                    item['date'] as String,
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              item['value'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
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
