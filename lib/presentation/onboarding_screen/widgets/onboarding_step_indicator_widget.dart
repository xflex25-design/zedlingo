import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class OnboardingStepIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingStepIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Step $currentStep of ${totalSteps - 1}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B6B6B),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(totalSteps - 1, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep - 1;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 6,
                decoration: BoxDecoration(
                  color: isCompleted || isCurrent
                      ? AppTheme.primary
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
