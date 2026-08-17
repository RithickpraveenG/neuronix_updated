import 'package:flutter/material.dart';

class RiskBadge extends StatelessWidget {
  final String riskLevel;

  const RiskBadge({super.key, required this.riskLevel});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    final levelUpper = riskLevel.toUpperCase();

    if (levelUpper.contains('CRITICAL') || levelUpper.contains('URGENT') || levelUpper.contains('HIGH')) {
      bg = const Color(0xFFFEF2F2);
      fg = const Color(0xFFEF4444);
    } else if (levelUpper.contains('MODERATE') || levelUpper.contains('PRIORITY') || levelUpper.contains('ATTENTION')) {
      bg = const Color(0xFFFFFBEB);
      fg = const Color(0xFFF59E0B);
    } else {
      bg = const Color(0xFFECFDF5);
      fg = const Color(0xFF10B981);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            riskLevel,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
