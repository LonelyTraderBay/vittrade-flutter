import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_breakpoints.dart';

/// Compatibility-only width dispatcher for callers of [createAppRouter].
///
/// Explicit Phone, Tablet, and Web routers never use this widget. It exists
/// at the composition boundary solely to preserve the historical responsive
/// facade while each surface continues to own an independent page tree.
class ResponsiveSurfacePage extends StatelessWidget {
  const ResponsiveSurfacePage({
    super.key,
    required this.phoneBuilder,
    required this.tabletBuilder,
  });

  final WidgetBuilder phoneBuilder;
  final WidgetBuilder tabletBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final builder = AppBreakpoints.isTablet(constraints.maxWidth)
            ? tabletBuilder
            : phoneBuilder;
        return builder(context);
      },
    );
  }
}
