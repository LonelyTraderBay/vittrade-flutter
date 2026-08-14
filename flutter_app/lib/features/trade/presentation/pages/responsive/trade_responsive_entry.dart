import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_breakpoints.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

/// Width-based dispatcher for the Trade route (SC-048): the single widget
/// `trade_routes.dart`'s `GoRoute` builds, so the route topology audits see
/// no change in shape. Delegates to the untouched phone [TradePage] below
/// [AppBreakpoints.tablet], [TradeTabletPage] at or above it — neither of
/// those two widgets is aware of the other. Only forwards the params the
/// root `/trade` route actually passes (`initialSide`); `pairId`/
/// `chartVariant` keep their `TradePage` defaults on both branches, same as
/// the phone-only route today. See
/// `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md`.
class TradeResponsiveEntry extends StatelessWidget {
  const TradeResponsiveEntry({
    super.key,
    this.initialSide = TradeOrderSide.buy,
    this.shellRenderMode,
  });

  final TradeOrderSide initialSide;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (AppBreakpoints.isTablet(constraints.maxWidth)) {
          return TradeTabletPage(initialSide: initialSide);
        }
        return TradePage(
          initialSide: initialSide,
          shellRenderMode: shellRenderMode,
        );
      },
    );
  }
}
