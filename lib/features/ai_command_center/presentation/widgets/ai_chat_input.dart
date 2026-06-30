import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/radius/jm_radius.dart';
import '../../../../core/design/shadows/jm_shadows.dart';
import '../../../../core/design/spacing/jm_spacing.dart';
import '../../../../core/design/typography/jm_typography.dart';

class AIChatInput extends StatelessWidget {
  const AIChatInput({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onSend,
    this.onVoice,
    this.onAttachment,
    this.hintText = 'Ask JourneyMATE AI anything...',
    this.enabled = true,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSend;
  final VoidCallback? onVoice;
  final VoidCallback? onAttachment;
  final String hintText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: JMColors.card,
        borderRadius: JMRadius.radiusXL,
        border: Border.all(color: JMColors.border),
        boxShadow: JMShadows.card,
      ),
      padding: const EdgeInsets.all(JMSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.send,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: JMTypography.bodyLarge,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: JMTypography.bodyMedium,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: JMSpacing.sm,
                ),
              ),
            ),
          ),

          const SizedBox(width: JMSpacing.sm),

          _ActionButton(
            icon: Icons.attach_file_rounded,
            tooltip: 'Attachment',
            color: JMColors.primary,
            onTap: onAttachment,
          ),

          const SizedBox(width: JMSpacing.sm),

          _ActionButton(
            icon: Icons.mic_rounded,
            tooltip: 'Voice',
            color: JMColors.secondary,
            onTap: onVoice,
          ),

          const SizedBox(width: JMSpacing.sm),

          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: JMColors.primary,
              borderRadius: JMRadius.radiusLG,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: JMRadius.radiusLG,
                onTap: onSend,
                child: const Icon(
                  Icons.send_rounded,
                  color: JMColors.textInverse,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: JMRadius.radiusLG,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: JMRadius.radiusLG,
            onTap: onTap,
            child: Icon(icon, color: color, size: 22),
          ),
        ),
      ),
    );
  }
}
