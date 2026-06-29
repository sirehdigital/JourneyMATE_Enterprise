import 'package:flutter/material.dart';

import '../../design/colors/jm_colors.dart';
import '../../design/radius/jm_radius.dart';
import '../../design/spacing/jm_spacing.dart';

class JMSearchBar extends StatelessWidget {
  const JMSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onTap,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: JMColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: JMSpacing.md,
          vertical: JMSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(JMRadius.xl),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(JMRadius.xl),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(JMRadius.xl),
          borderSide: BorderSide(color: JMColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
