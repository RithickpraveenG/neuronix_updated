import 'package:flutter/material.dart';
import 'neuronix_button.dart';

/// Legacy PrimaryButton adapter forwarding to NeuronixButton
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return NeuronixButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}
