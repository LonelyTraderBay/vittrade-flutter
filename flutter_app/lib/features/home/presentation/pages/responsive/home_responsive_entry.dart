import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_breakpoints.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/tablet/pages/home_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

/// Width-based dispatcher for the Home route (SC-007): the single widget
/// `home_routes.dart`'s `GoRoute` builds, so the route topology audits see
/// no change in shape. Delegates to the untouched phone [HomePage] below
/// [AppBreakpoints.tablet], [HomeTabletPage] at or above it — neither of
/// those two widgets is aware of the other.
class HomeResponsiveEntry extends StatelessWidget {
  const HomeResponsiveEntry({super.key, this.shellRenderMode});

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (AppBreakpoints.isTablet(constraints.maxWidth)) {
          return const HomeTabletPage();
        }
        return HomePage(shellRenderMode: shellRenderMode);
      },
    );
  }
}
