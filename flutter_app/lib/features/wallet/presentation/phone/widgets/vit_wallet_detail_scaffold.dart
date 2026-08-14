import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_inset_scroll_view.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

/// Home-aligned bottom scroll clearance for wallet L2 flow pages.
double walletScrollEndPad(
  BuildContext context, {
  ShellRenderMode? shellRenderMode,
}) {
  final mode = shellRenderMode ?? defaultShellRenderMode();
  return (mode.usesVisualQaFrame
          ? WalletSpacingTokens.walletVisualChromePad
          : WalletSpacingTokens.walletNativeChromePad) +
      MediaQuery.paddingOf(context).bottom;
}

/// L2 detail scaffold for wallet flow pages (deposit, withdraw, transfer, buy).
class VitWalletDetailScaffold extends StatelessWidget {
  const VitWalletDetailScaffold({
    super.key,
    required this.title,
    required this.children,
    this.semanticLabel,
    this.semanticIdentifier,
    this.subtitle,
    this.contentKey,
    this.showBack = true,
    this.onBack,
    this.backKey,
    this.scrollEndPad,
    this.shellRenderMode,
    this.backgroundColor = AppColors.bg,
    this.contentGap = VitContentGap.defaultGap,
    this.rhythm = VitPageRhythm.standard,
    this.scrollChild,
  });

  final String title;
  final List<Widget> children;
  final String? semanticLabel;

  /// Internal screen code (e.g. `SC-007`) for tooling/debugging — see A11Y-1,
  /// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
  final String? semanticIdentifier;
  final String? subtitle;
  final Key? contentKey;
  final bool showBack;
  final VoidCallback? onBack;
  final Key? backKey;
  final double? scrollEndPad;
  final ShellRenderMode? shellRenderMode;
  final Color backgroundColor;
  final VitContentGap contentGap;
  final VitPageRhythm rhythm;
  final Widget? scrollChild;

  @override
  Widget build(BuildContext context) {
    final resolvedPad =
        scrollEndPad ??
        walletScrollEndPad(context, shellRenderMode: shellRenderMode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      semanticIdentifier: semanticIdentifier,
      child: Material(
        color: backgroundColor,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: showBack,
            onBack: onBack,
            backKey: backKey,
          ),
          child: VitInsetScrollView(
            key: contentKey,
            bottomInset: resolvedPad,
            child:
                scrollChild ??
                VitPageContent(
                  rhythm: rhythm,
                  padding: VitContentPadding.compact,
                  density: VitDensity.compact,
                  gap: contentGap,
                  children: children,
                ),
          ),
        ),
      ),
    );
  }
}
