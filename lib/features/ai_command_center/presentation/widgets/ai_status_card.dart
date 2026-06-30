import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';
import '../../../../core/providers/ai_provider.dart';

class AIStatusCard extends ConsumerWidget {
  const AIStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ai = ref.watch(aiProvider);

    final (statusColor, statusIcon) = switch (ai.status) {
      AIStatus.ready => (JMColors.success, Icons.check_circle_rounded),
      AIStatus.thinking => (JMColors.warning, Icons.psychology_rounded),
      AIStatus.planning => (JMColors.primary, Icons.route_rounded),
      AIStatus.completed => (JMColors.ai, Icons.auto_awesome_rounded),
      AIStatus.error => (JMColors.error, Icons.error_rounded),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(JMSpacing.cardPadding),
      decoration: BoxDecoration(
        color: JMColors.card,
        borderRadius: JMRadius.radiusLG,
        border: Border.all(color: JMColors.border),
        boxShadow: JMShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //--------------------------------------------------------
          // Header
          //--------------------------------------------------------
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: JMRadius.radiusLG,
                ),
                child: Icon(statusIcon, color: statusColor),
              ),

              const SizedBox(width: JMSpacing.lg),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AI Status', style: JMTypography.titleLarge),

                    const SizedBox(height: JMSpacing.xs),

                    Text(ai.message, style: JMTypography.bodyMedium),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.xxl),

          //--------------------------------------------------------
          // Footer
          //--------------------------------------------------------
          Row(
            children: [
              Icon(Icons.circle, size: 12, color: statusColor),

              const SizedBox(width: JMSpacing.sm),

              Text(
                ai.status.name.toUpperCase(),
                style: JMTypography.labelMedium.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Text(ai.currentModel, style: JMTypography.bodySmall),
            ],
          ),

          const SizedBox(height: JMSpacing.lg),

          LinearProgressIndicator(
            value: ai.loading ? null : 1,
            minHeight: 6,
            borderRadius: JMRadius.radiusPill,
            backgroundColor: JMColors.border,
            color: statusColor,
          ),

          const SizedBox(height: JMSpacing.xxl),

          //--------------------------------------------------------
          // Demo Controls
          //--------------------------------------------------------
          Wrap(
            spacing: JMSpacing.sm,
            runSpacing: JMSpacing.sm,
            children: [
              FilledButton(
                onPressed: () => ref.read(aiProvider.notifier).setReady(),
                child: const Text('Ready'),
              ),
              FilledButton(
                onPressed: () => ref.read(aiProvider.notifier).setThinking(),
                child: const Text('Thinking'),
              ),
              FilledButton(
                onPressed: () => ref.read(aiProvider.notifier).setPlanning(),
                child: const Text('Planning'),
              ),
              FilledButton(
                onPressed: () => ref.read(aiProvider.notifier).setCompleted(),
                child: const Text('Completed'),
              ),
              FilledButton(
                onPressed: () => ref.read(aiProvider.notifier).setError(),
                child: const Text('Error'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
