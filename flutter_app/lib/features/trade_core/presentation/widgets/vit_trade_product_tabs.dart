import 'dart:async';

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_module_components.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';

/// Product tab descriptor for horizontal product switcher.
final class VitTradeProductTab {
  const VitTradeProductTab({
    required this.id,
    required this.label,
    required this.onTap,
    this.tabKey,
    this.riskBadge,
  });

  final String id;
  final String label;
  final VoidCallback onTap;
  final Key? tabKey;

  /// Compact risk disclosure on leveraged / automated products (e.g. Margin, Bot).
  final String? riskBadge;
}

/// Overflow hub tile for the "more products" sheet.
final class VitTradeProductOverflowItem {
  const VitTradeProductOverflowItem({
    required this.id,
    required this.label,
    required this.badge,
    required this.icon,
    required this.accentColor,
    required this.onTap,
    this.tileKey,
  });

  final String id;
  final String label;
  final String badge;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
  final Key? tileKey;
}

/// Horizontal product tabs: Spot / Futures / Margin / Convert.
class VitTradeProductTabs extends StatelessWidget {
  const VitTradeProductTabs({
    super.key,
    required this.tabs,
    required this.activeId,
    this.overflowItems = const [],
    this.moreSheetTitle = 'Thêm sản phẩm',
  });

  final List<VitTradeProductTab> tabs;
  final String activeId;
  final List<VitTradeProductOverflowItem> overflowItems;
  final String moreSheetTitle;

  void _openMoreSheet(BuildContext context) {
    if (overflowItems.isEmpty) return;
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.bg,
        builder: (sheetContext) {
          return VitSheetPanel(
            title: moreSheetTitle,
            child: Wrap(
              spacing: AppSurfaceSpacing.x3,
              runSpacing: AppSurfaceSpacing.x3,
              children: [
                for (final item in overflowItems)
                  SizedBox(
                    width:
                        (MediaQuery.sizeOf(sheetContext).width -
                            AppSurfaceSpacing.contentPad * 2 -
                            AppSurfaceSpacing.x3) /
                        2,
                    child: VitServiceTile(
                      key: item.tileKey,
                      density: VitServiceTileDensity.compact,
                      icon: item.icon,
                      label: item.label,
                      accentColor: item.accentColor,
                      badgeLabel: item.badge,
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        item.onTap();
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
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < tabs.length; i++) ...[
                  if (i > 0) SizedBox(width: AppSurfaceSpacing.x2),
                  _ProductTabChip(
                    key: tabs[i].tabKey,
                    label: tabs[i].label,
                    riskBadge: tabs[i].riskBadge,
                    active: tabs[i].id == activeId,
                    onTap: tabs[i].onTap,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (overflowItems.isNotEmpty) ...[
          SizedBox(width: AppSurfaceSpacing.x2),
          VitCard(
            onTap: () => _openMoreSheet(context),
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: AppSurfaceSpacing.zeroInsets.copyWith(
              left: AppSurfaceSpacing.x3,
              right: AppSurfaceSpacing.x3,
              top: AppSurfaceSpacing.x2,
              bottom: AppSurfaceSpacing.x2,
            ),
            borderColor: AppColors.borderSolid,
            child: Text(
              'Thêm',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProductTabChip extends StatelessWidget {
  const _ProductTabChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.riskBadge,
  });

  final String label;
  final String? riskBadge;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final semanticsLabel = riskBadge == null ? label : '$label, $riskBadge';
    return Semantics(
      button: true,
      selected: active,
      label: semanticsLabel,
      child: VitCard(
        onTap: onTap,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        padding: AppSurfaceSpacing.zeroInsets.copyWith(
          left: AppSurfaceSpacing.x3,
          right: AppSurfaceSpacing.x3,
          top: AppSurfaceSpacing.x2,
          bottom: AppSurfaceSpacing.x2,
        ),
        borderColor: active
            ? AppColors.primary.withValues(alpha: .45)
            : AppColors.borderSolid,
        background: active
            ? DecoratedBox(
                decoration: ShapeDecoration(
                  color: AppColors.primary.withValues(alpha: .10),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.cardRadius,
                  ),
                ),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? AppColors.primary : AppColors.text2,
                fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
              ),
            ),
            if (riskBadge != null) ...[
              SizedBox(width: AppSurfaceSpacing.x1),
              VitStatusPill(
                label: riskBadge!,
                status: VitStatusPillStatus.warning,
                size: VitStatusPillSize.sm,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
