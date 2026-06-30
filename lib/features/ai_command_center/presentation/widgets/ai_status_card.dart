import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class AIStatusCard extends StatelessWidget {
  const AIStatusCard({
    super.key,
    this.isOnline = true,
    this.confidence = 98,
    this.responseTime = '0.24 s',
    this.lastSync = 'Just now',
  });

  final bool isOnline;
  final int confidence;
  final String responseTime;
  final String lastSync;

  @override
  Widget build(BuildContext context) {
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
          //------------------------------------
          // Header
          //------------------------------------
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(JMSpacing.md),
                decoration: BoxDecoration(
                  color: JMColors.primary.withOpacity(.08),
                  borderRadius: JMRadius.radiusMD,
                ),
                child: const Icon(
                  Icons.memory_rounded,
                  color: JMColors.primary,
                  size: 26,
                ),
              ),

              const SizedBox(width: JMSpacing.lg),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AI Status', style: JMTypography.titleLarge),
                    const SizedBox(height: JMSpacing.xs),
                    Text(
                      isOnline
                          ? 'JourneyMATE AI is operational'
                          : 'JourneyMATE AI is offline',
                      style: JMTypography.bodySmall,
                    ),
                  ],
                ),
              ),

              _StatusBadge(isOnline: isOnline),
            ],
          ),

          const SizedBox(height: JMSpacing.xxl),

          //------------------------------------
          // Metrics
          //------------------------------------
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.psychology_alt_rounded,
                  title: 'Confidence',
                  value: '$confidence%',
                  color: JMColors.ai,
                ),
              ),
              const SizedBox(width: JMSpacing.lg),
              Expanded(
                child: _MetricTile(
                  icon: Icons.speed_rounded,
                  title: 'Response',
                  value: responseTime,
                  color: JMColors.info,
                ),
              ),
            ],
          ),

          const SizedBox(height: JMSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.sync_rounded,
                  title: 'Last Sync',
                  value: lastSync,
                  color: JMColors.success,
                ),
              ),
              const SizedBox(width: JMSpacing.lg),
              const Expanded(
                child: _MetricTile(
                  icon: Icons.cloud_done_rounded,
                  title: 'Server',
                  value: 'Healthy',
                  color: JMColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: JMSpacing.md,
        vertical: JMSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isOnline
            ? JMColors.success.withOpacity(.10)
            : JMColors.error.withOpacity(.10),
        borderRadius: JMRadius.radiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: isOnline ? JMColors.success : JMColors.error,
          ),
          const SizedBox(width: JMSpacing.sm),
          Text(
            isOnline ? 'ONLINE' : 'OFFLINE',
            style: TextStyle(
              color: isOnline ? JMColors.success : JMColors.error,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(JMSpacing.lg),
      decoration: BoxDecoration(
        color: JMColors.background,
        borderRadius: JMRadius.radiusMD,
        border: Border.all(color: JMColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: JMSpacing.md),
          Text(title, style: JMTypography.labelMedium),
          const SizedBox(height: JMSpacing.xs),
          Text(value, style: JMTypography.titleMedium),
        ],
      ),
    );
  }
}
