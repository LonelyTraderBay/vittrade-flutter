import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_breakpoints.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/phone/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tablet/markets_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

/// Width-based dispatcher for the Markets route (SC-008): the single widget
/// `markets_routes.dart`'s `GoRoute` builds, so the route topology audits
/// see no change in shape. Delegates to the untouched phone [MarketListPage]
/// below [AppBreakpoints.tablet], [MarketsTabletPage] at or above it —
/// neither of those two widgets is aware of the other. Named after the
/// feature/route (`markets_routes.dart`, `AppRoutePaths.markets`), not the
/// phone page class, since `MarketList*` and `Markets*` would otherwise
/// collide in intent. See
/// `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md`.
class MarketsResponsiveEntry extends StatelessWidget {
  const MarketsResponsiveEntry({super.key, this.shellRenderMode});

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (AppBreakpoints.isTablet(constraints.maxWidth)) {
          return const MarketsTabletPage();
        }
        return MarketListPage(shellRenderMode: shellRenderMode);
      },
    );
  }
}
