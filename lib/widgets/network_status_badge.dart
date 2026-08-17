import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/network_service.dart';

class NetworkStatusBadge extends StatelessWidget {
  const NetworkStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final network = context.watch<NetworkService>();
    final isOnline = network.isOnline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOnline ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: isOnline ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
          ),
          const SizedBox(width: 6),
          Text(
            isOnline ? 'Online AI' : 'Offline Engine',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isOnline ? const Color(0xFF065F46) : const Color(0xFF92400E),
            ),
          ),
        ],
      ),
    );
  }
}
