import 'package:flutter/widgets.dart';

import '../../design/spacing/jm_spacing.dart';

class JMGap extends SizedBox {
  const JMGap.xs({super.key}) : super(height: JMSpacing.xs);

  const JMGap.sm({super.key}) : super(height: JMSpacing.sm);

  const JMGap.md({super.key}) : super(height: JMSpacing.md);

  const JMGap.lg({super.key}) : super(height: JMSpacing.lg);

  const JMGap.xl({super.key}) : super(height: JMSpacing.xl);

  const JMGap.horizontalXs({super.key}) : super(width: JMSpacing.xs);

  const JMGap.horizontalSm({super.key}) : super(width: JMSpacing.sm);

  const JMGap.horizontalMd({super.key}) : super(width: JMSpacing.md);

  const JMGap.horizontalLg({super.key}) : super(width: JMSpacing.lg);
}
