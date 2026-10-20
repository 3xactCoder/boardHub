import 'package:flutter/widgets.dart';

import '../theme/app_spacing.dart';

extension ResponsiveContext on BuildContext {
  bool get isDesktop =>
      MediaQuery.sizeOf(this).width >= AppSpacing.desktopBreakpoint;
}
