import 'package:flutter/material.dart';

import '../../design/colors/jm_colors.dart';
import '../../design/typography/jm_typography.dart';

class JMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const JMAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: JMTypography.titleLarge.copyWith(
          color: JMColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      backgroundColor: JMColors.background,
      foregroundColor: JMColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
