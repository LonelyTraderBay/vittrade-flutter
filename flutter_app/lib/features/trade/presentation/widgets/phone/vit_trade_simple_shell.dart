// Phone/fallback trade shell.
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';

/// Home-like scroll shell for beginner trade experience.
class VitTradeSimpleShell extends StatelessWidget {
  const VitTradeSimpleShell({
    super.key,
    required this.title,
    required this.children,
    this.semanticLabel,
    this.semanticIdentifier,
    this.subtitle,
    this.contentKey,
    this.showBack = false,
    this.onBack,
    this.backKey,
    this.shellRenderMode,
    this.headerActions = const [],
    this.showProductTabs = true,
    this.activeProductId,
    this.productPair,
    this.quickNavKey,
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
  final ShellRenderMode? shellRenderMode;
  final List<VitHeaderActionItem> headerActions;
  final bool showProductTabs;
  final String? activeProductId;
  final TradePair? productPair;
  final Key Function(String id)? quickNavKey;

  @override
  Widget build(BuildContext context) {
    return VitTradeHubScaffold(
      title: title,
      subtitle: subtitle,
      semanticLabel: semanticLabel,
      semanticIdentifier: semanticIdentifier,
      contentKey: contentKey,
      showBack: showBack,
      onBack: onBack,
      backKey: backKey,
      shellRenderMode: shellRenderMode,
      headerActions: headerActions,
      showProductTabs: showProductTabs,
      activeProductId: activeProductId,
      productPair: productPair,
      quickNavKey: quickNavKey,
      // VitTradeSimpleShell is trade_terminal-owned and only ever wraps the
      // 4 core L1 instrument pages (Spot/Futures/Margin/Convert), so it is
      // safe to always hand trade_core the trade_terminal nav source here —
      // it is only ever rendered when showProductTabs is true.
      navigationBuilder: buildTradeProductNavigation,
      children: [
        ...children,
        Text(
          'Giao dịch tiền mã hoá có rủi ro. Chỉ dùng số tiền bạn chấp nhận mất.',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}
