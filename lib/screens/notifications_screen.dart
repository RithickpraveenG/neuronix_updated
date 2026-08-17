import 'package:flutter/material.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/neuronix_card.dart';
import '../widgets/responsive_scaffold.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'n1',
      'title': 'Medical Report Analysis Complete',
      'body': 'Your blood panel OCR and spaCy NLP analysis is ready for review.',
      'time': '10 min ago',
      'type': 'ai',
      'read': false,
    },
    {
      'id': 'n2',
      'title': 'Upcoming Appointment Reminder',
      'body': 'Cardiology consultation with Dr. Rivera tomorrow at 10:30 AM.',
      'time': '2 hours ago',
      'type': 'appointment',
      'read': false,
    },
    {
      'id': 'n3',
      'title': 'Vitals Baseline Alert',
      'body': 'Your weekly average blood pressure remains optimal at 120/80 mmHg.',
      'time': '1 day ago',
      'type': 'health',
      'read': true,
    },
  ];

  void _markAllRead() {
    setState(() {
      for (var item in _notifications) {
        item['read'] = true;
      }
    });
  }

  void _toggleRead(String id) {
    setState(() {
      for (var item in _notifications) {
        if (item['id'] == id) {
          item['read'] = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => n['read'] == false).length;

    return ResponsiveScaffold(
      title: 'Notifications & Alerts',
      actions: [
        if (unreadCount > 0)
          TextButton(
            onPressed: _markAllRead,
            child: const Text('Mark All Read'),
          ),
      ],
      body: SingleChildScrollView(
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
                        const Text(
                          'Notifications',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$unreadCount unread health alerts and appointment updates',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    if (unreadCount > 0)
                      ElevatedButton.icon(
                        onPressed: _markAllRead,
                        icon: const Icon(Icons.done_all, size: 16),
                        label: const Text('Clear Unread'),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                if (_notifications.isEmpty)
                  const EmptyStateWidget(
                    title: 'No Notifications',
                    description: 'You have no recent health alerts or system updates.',
                    icon: Icons.notifications_off_outlined,
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final item = _notifications[index];
                      final isRead = item['read'] as bool;
                      final type = item['type'] as String;

                      IconData iconData;
                      Color iconColor;
                      if (type == 'ai') {
                        iconData = Icons.auto_awesome;
                        iconColor = const Color(0xFF1E88E5);
                      } else if (type == 'appointment') {
                        iconData = Icons.event;
                        iconColor = const Color(0xFF8B5CF6);
                      } else {
                        iconData = Icons.favorite;
                        iconColor = const Color(0xFF10B981);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NeuronixCard(
                          onTap: () => _toggleRead(item['id'] as String),
                          backgroundColor: isRead ? Colors.white : const Color(0xFFF8FAFC),
                          border: isRead
                              ? Border.all(color: const Color(0xFFE2E8F0))
                              : Border.all(color: const Color(0xFF1E88E5).withOpacity(0.4), width: 1.5),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: iconColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(iconData, color: iconColor, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['title'] as String,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                        Text(
                                          item['time'] as String,
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['body'] as String,
                                      style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isRead) ...[
                                const SizedBox(width: 8),
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1E88E5),
                                    shape: BoxShape.circle,
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
