import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_state_widget.dart';
import '../widgets/neuronix_card.dart';
import '../widgets/responsive_scaffold.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  List<Map<String, dynamic>> _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    setState(() => _isLoading = true);
    try {
      final res = await _apiService.getAppointments();
      setState(() {
        _appointments = res.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      });
    } catch (_) {
      // Local fallback appointments
      setState(() {
        _appointments = [
          {
            'id': 'a1',
            'title': 'Cardiology Follow-Up',
            'doctor': 'Dr. Rivera (Cardiology)',
            'date': '2026-08-20',
            'time': '10:30 AM',
            'status': 'Confirmed',
          },
          {
            'id': 'a2',
            'title': 'General Health Review',
            'doctor': 'Dr. Khan (Primary Care)',
            'date': '2026-08-25',
            'time': '02:00 PM',
            'status': 'Pending',
          },
        ];
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showBookAppointmentDialog() {
    final titleController = TextEditingController(text: 'General Consultation');
    final dateController = TextEditingController(text: '2026-08-28');
    String selectedDoctor = 'Dr. Rivera (Cardiology)';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Book New Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Reason for Visit'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedDoctor,
              decoration: const InputDecoration(labelText: 'Select Clinician'),
              items: ['Dr. Rivera (Cardiology)', 'Dr. Khan (Primary Care)', 'Dr. Chen (Neurology)']
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (val) => selectedDoctor = val!,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Preferred Date (YYYY-MM-DD)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newAppt = {
                'id': 'a-${DateTime.now().millisecondsSinceEpoch}',
                'title': titleController.text,
                'doctor': selectedDoctor,
                'date': dateController.text,
                'time': '10:00 AM',
                'status': 'Pending',
              };
              try {
                await _apiService.createAppointment(newAppt);
              } catch (_) {}
              setState(() {
                _appointments.insert(0, newAppt);
              });
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStatus(String id, String newStatus) async {
    Map<String, dynamic>? updatedTarget;
    setState(() {
      for (var appt in _appointments) {
        if (appt['id']?.toString() == id) {
          appt['status'] = newStatus;
          updatedTarget = Map<String, dynamic>.from(appt);
        }
      }
    });

    if (updatedTarget != null) {
      try {
        await _apiService.createAppointment(updatedTarget!);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isDoctor = auth.role == 'doctor';

    return ResponsiveScaffold(
      title: 'Appointments Schedule',
      actions: [
        if (!isDoctor)
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Book Appointment',
            onPressed: _showBookAppointmentDialog,
          ),
      ],
      body: _isLoading
          ? const LoadingStateWidget(message: 'Fetching appointments schedule...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isDoctor ? 'Patient Appointments' : 'My Care Appointments',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isDoctor
                                    ? 'Review and confirm scheduled clinical consultations.'
                                    : 'Schedule and manage upcoming visits with your clinicians.',
                                style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                          if (!isDoctor)
                            ElevatedButton.icon(
                              onPressed: _showBookAppointmentDialog,
                              icon: const Icon(Icons.calendar_today, size: 16),
                              label: const Text('Book Visit'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      if (_appointments.isEmpty)
                        const EmptyStateWidget(
                          title: 'No Appointments Found',
                          description: 'You have no scheduled clinical appointments at this time.',
                          icon: Icons.calendar_month_outlined,
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _appointments.length,
                          itemBuilder: (context, index) {
                            final item = _appointments[index];
                            final status = item['status']?.toString() ?? 'Pending';

                            Color statusBg;
                            Color statusFg;
                            if (status.contains('Confirmed') || status.contains('Complete')) {
                              statusBg = const Color(0xFFECFDF5);
                              statusFg = const Color(0xFF10B981);
                            } else if (status.contains('Cancelled') || status.contains('Reject')) {
                              statusBg = const Color(0xFFFEF2F2);
                              statusFg = const Color(0xFFEF4444);
                            } else {
                              statusBg = const Color(0xFFFFFBEB);
                              statusFg = const Color(0xFFF59E0B);
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: NeuronixCard(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1E88E5).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(Icons.event, color: Color(0xFF1E88E5)),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['title']?.toString() ?? 'Consultation',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0F172A),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                item['doctor']?.toString() ?? 'Clinician',
                                                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '${item['date']} • ${item['time'] ?? '10:00 AM'}',
                                                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: statusBg,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: statusFg,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isDoctor && status == 'Pending') ...[
                                      const Divider(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () => _updateStatus(item['id'].toString(), 'Cancelled'),
                                            child: const Text('Reject', style: TextStyle(color: Colors.red)),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF10B981),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            ),
                                            onPressed: () => _updateStatus(item['id'].toString(), 'Confirmed'),
                                            child: const Text('Accept Visit'),
                                          ),
                                        ],
                                      ),
                                    ] else if (!isDoctor && status != 'Cancelled') ...[
                                      const Divider(height: 20),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () => _updateStatus(item['id'].toString(), 'Cancelled'),
                                          child: const Text('Cancel Booking', style: TextStyle(color: Color(0xFF64748B))),
                                        ),
                                      ),
                                    ],
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
