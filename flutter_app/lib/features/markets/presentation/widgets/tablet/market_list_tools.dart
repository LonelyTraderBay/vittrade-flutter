import 'dart:async';

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

const double _marketToolsCompactHeight = AppSpacing.buttonCompact;
const double _marketToolCompactGap = AppSpacing.x2;
const EdgeInsets _marketToolCompactPadding =
    MarketsSpacingTokens.marketListToolCompactPadding;
const double _marketToolCompactIcon = AppSpacing.iconSm;

class MarketListTools extends StatelessWidget {
  const MarketListTools({
    super.key,
    required this.onNavigate,
    this.tablet = false,
  });

  final ValueChanged<String> onNavigate;

  /// Tablet sidebars have a bounded width, so show the core tools as a
  /// wrapped command group instead of exposing a clipped horizontal strip.
  /// Phone callers keep the original single-row, scrollable treatment.
  final bool tablet;

  /// HUB-only chips on the Markets list strip (STEP-P2.1 + P2.2).
  static const hubTools = [
    _MarketsTabletTool(
      icon: Icons.filter_alt_outlined,
      label: 'Bộ lọc',
      route: 'screener',
      color: marketListPrimary,
    ),
    _MarketsTabletTool(
      icon: Icons.balance_outlined,
      label: 'So sánh',
      route: 'compare',
      color: marketListPredictionAccent,
    ),
    _MarketsTabletTool(
      icon: Icons.calendar_month_outlined,
      label: 'Sự kiện',
      route: 'calendar',
      color: marketListArenaAccent,
    ),
    _MarketsTabletTool(
      icon: Icons.bolt_outlined,
      label: 'Phái sinh',
      route: 'derivatives',
      color: AppColors.sell,
    ),
    _MarketsTabletTool(
      icon: Icons.pie_chart_outline_rounded,
      label: 'Danh mục',
      route: 'portfolio-tracker',
      color: AppColors.buy,
    ),
    _MarketsTabletTool(
      icon: Icons.show_chart_rounded,
      label: 'Phân tích',
      route: 'advanced-charts',
      color: AppAssetColors.skyChain,
    ),
    _MarketsTabletTool(
      icon: Icons.grid_view_rounded,
      label: 'Bản đồ nhiệt',
      route: 'heatmap',
      color: AppColors.riskHigh,
    ),
    _MarketsTabletTool(
      icon: Icons.star_border_rounded,
      label: 'Theo dõi',
      route: 'watchlist',
      color: marketListPrimary,
    ),
  ];

  /// ẨN deep-link tools — reachable via overflow «Thêm» only (STEP-P2.2).
  static const overflowTools = [
    _MarketsTabletTool(
      icon: Icons.forum_outlined,
      label: 'Tâm lý',
      route: 'social-sentiment',
      color: AppAssetColors.cyanChain,
    ),
    _MarketsTabletTool(
      icon: Icons.article_outlined,
      label: 'Tin tức',
      route: 'news',
      color: AppColors.text3,
    ),
    _MarketsTabletTool(
      icon: Icons.lock_open_rounded,
      label: 'Mở khóa',
      route: 'unlocks',
      color: AppAssetColors.violetChain,
    ),
    _MarketsTabletTool(
      icon: Icons.radio_button_checked,
      label: 'Tín hiệu',
      route: 'signals',
      color: AppColors.riskHigh,
    ),
    _MarketsTabletTool(
      icon: Icons.account_tree_outlined,
      label: 'Tương quan',
      route: 'correlations',
      color: AppAssetColors.tealChain,
    ),
  ];

  void _openOverflowSheet(BuildContext context) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.bg,
        builder: (sheetContext) {
          return VitSheetPanel(
            title: 'Thêm công cụ',
            child: Wrap(
              spacing: AppSpacing.x3,
              runSpacing: AppSpacing.x3,
              children: [
                for (final tool in overflowTools)
                  SizedBox(
                    width:
                        (MediaQuery.sizeOf(sheetContext).width -
                            AppSpacing.contentPad * 2 -
                            AppSpacing.x3) /
                        2,
                    child: VitServiceTile(
                      density: VitServiceTileDensity.compact,
                      icon: tool.icon,
                      label: tool.label,
                      accentColor: tool.color,
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        onNavigate('/markets/${tool.route}');
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (tablet) {
      return Wrap(
        spacing: _marketToolCompactGap,
        runSpacing: _marketToolCompactGap,
        children: [
          for (final tool in hubTools)
            _ToolChip(
              tool: tool,
              onTap: () => onNavigate('/markets/${tool.route}'),
            ),
          VitChoicePill(
            label: 'Thêm',
            selected: false,
            showSelectedIcon: false,
            onTap: () => _openOverflowSheet(context),
            accentColor: AppColors.primary,
            padding: _marketToolCompactPadding,
            leading: const Icon(
              Icons.more_horiz_rounded,
              color: AppColors.primary,
              size: _marketToolCompactIcon,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height: _marketToolsCompactHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            for (var i = 0; i < hubTools.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.x4),
              _ToolChip(
                tool: hubTools[i],
                onTap: () => onNavigate('/markets/${hubTools[i].route}'),
              ),
            ],
            const SizedBox(width: AppSpacing.x4),
            VitChoicePill(
              label: 'Thêm',
              selected: false,
              showSelectedIcon: false,
              onTap: () => _openOverflowSheet(context),
              accentColor: AppColors.primary,
              padding: _marketToolCompactPadding,
              leading: const Icon(
                Icons.more_horiz_rounded,
                color: AppColors.primary,
                size: _marketToolCompactIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketsTabletTool {
  const _MarketsTabletTool({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String route;
  final Color color;
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({required this.tool, required this.onTap});

  final _MarketsTabletTool tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: tool.label,
      selected: true,
      onTap: onTap,
      accentColor: tool.color,
      padding: _marketToolCompactPadding,
      leading: Icon(tool.icon, color: tool.color, size: _marketToolCompactIcon),
    );
  }
}
