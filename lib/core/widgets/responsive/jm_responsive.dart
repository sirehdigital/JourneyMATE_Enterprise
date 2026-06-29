import 'package:flutter/material.dart';

import '../../design/breakpoints/jm_breakpoints.dart';

class JMResponsive extends StatelessWidget {
  const JMResponsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    if (JMBreakpoints.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }

    if (JMBreakpoints.isTablet(context)) {
      return tablet ?? mobile;
    }

    return mobile;
  }
}
