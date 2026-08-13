import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_breakpoints.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/phone/profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/pages/tablet/profile_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

/// Width-based dispatcher for the Profile route (SC-156): the single widget
/// `profile_routes.dart`'s `GoRoute` builds, so the route topology audits see
/// no change in shape. Delegates to the untouched phone [ProfilePage] below
/// [AppBreakpoints.tablet], [ProfileTabletPage] at or above it — neither of
/// those two widgets is aware of the other. See
/// `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md`.
class ProfileResponsiveEntry extends StatelessWidget {
  const ProfileResponsiveEntry({super.key, this.shellRenderMode});

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (AppBreakpoints.isTablet(constraints.maxWidth)) {
          return const ProfileTabletPage();
        }
        return ProfilePage(shellRenderMode: shellRenderMode);
      },
    );
  }
}
