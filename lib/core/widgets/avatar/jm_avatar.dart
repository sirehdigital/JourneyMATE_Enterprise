import 'package:flutter/material.dart';

import '../../design/colors/jm_colors.dart';
import '../../design/radius/jm_radius.dart';

class JMAvatar extends StatelessWidget {
  const JMAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 24,
    this.isOnline = false,
  });

  final String? imageUrl;
  final String? initials;
  final double radius;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: JMColors.primary.withValues(alpha: 0.12),
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null
              ? Text(
                  initials ?? "JM",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: radius * .7,
                    color: JMColors.primary,
                  ),
                )
              : null,
        ),

        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(JMRadius.pill),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
