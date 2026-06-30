import 'package:flutter/material.dart';

import '../../../../core/design/colors/jm_colors.dart';
import '../../../../core/design/spacing/jm_spacing.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _opacity(int index) {
    final value = (_controller.value * 3 - index).abs();

    if (value >= 1) {
      return .30;
    }

    return 1 - (value * .70);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(opacity: _opacity(0)),
            const SizedBox(width: JMSpacing.sm),
            _Dot(opacity: _opacity(1)),
            const SizedBox(width: JMSpacing.sm),
            _Dot(opacity: _opacity(2)),
          ],
        );
      },
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: JMColors.ai,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
