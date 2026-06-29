import 'package:flutter/material.dart';

class JMDivider extends StatelessWidget {
  const JMDivider({
    super.key,
    this.height = 24,
    this.thickness = .8,
    this.color,
  });

  final double height;

  final double thickness;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(height: height, thickness: thickness, color: color);
  }
}
