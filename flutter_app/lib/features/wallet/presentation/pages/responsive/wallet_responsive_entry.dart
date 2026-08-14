import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_breakpoints.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/wallet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

/// Width-based dispatcher for the Wallet route (SC-135): the single widget
/// `wallet_routes.dart`'s `GoRoute` builds, so the route topology audits see
/// no change in shape. Delegates to the untouched phone [WalletPage] below
/// [AppBreakpoints.tablet], [WalletTabletPage] at or above it — neither of
/// those two widgets is aware of the other. See
/// `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md`.
class WalletResponsiveEntry extends StatelessWidget {
  const WalletResponsiveEntry({super.key, this.shellRenderMode});

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (AppBreakpoints.isTablet(constraints.maxWidth)) {
          return const WalletTabletPage();
        }
        return WalletPage(shellRenderMode: shellRenderMode);
      },
    );
  }
}
