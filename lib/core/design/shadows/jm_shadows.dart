import 'package:flutter/material.dart';

/// =======================================================
/// JourneyMATE Enterprise Shadow System
/// =======================================================

class JMShadows {
  JMShadows._();

  static const BoxShadow sm = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 6,
    offset: Offset(0, 2),
  );

  static const BoxShadow md = BoxShadow(
    color: Color(0x1F000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  static const BoxShadow lg = BoxShadow(
    color: Color(0x29000000),
    blurRadius: 20,
    offset: Offset(0, 8),
  );

  static const List<BoxShadow> card = [md];
}
