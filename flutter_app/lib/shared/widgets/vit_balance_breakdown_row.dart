import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_status_pill.dart';

/// One tappable balance summary entry (label/value/icon/route) rendered by
/// [VitBalanceBreakdownRow].
class VitBalanceBreakdownItem {
  const VitBalanceBreakdownItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.tooltip,
    required this.route,
  });

  final String label;
  final String value;
  final IconData icon;
  final String tooltip;
  final String route;
}

/// A row of tappable balance summaries (e.g. Spot/Earn/Funding), each
/// showing a labeled pill and a formatted value inside a shared inner card.
class VitBalanceBreakdownRow extends StatelessWidget {
  const VitBalanceBreakdownRow({
    super.key,
    required this.items,
    required this.onNavigate,
  });

  final List<VitBalanceBreakdownItem> items;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: VitDensity.compact.cardPadding,
      borderColor: AppColors.onAccent.withValues(alpha: .08),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Expanded(
              child: Semantics(
                button: true,
                label: '${items[i].label}: mở ${items[i].label}',
                child: InkWell(
                  onTap: () => onNavigate(items[i].route),
                  borderRadius: AppRadii.inputRadius,
                  child: Tooltip(
                    message: items[i].tooltip,
                    child: Column(
                      children: [
                        VitStatusPill(
                          label: items[i].label,
                          status: VitStatusPillStatus.neutral,
                          icon: items[i].icon,
                          size: VitStatusPillSize.sm,
                        ),
                        SizedBox(height: AppSurfaceSpacing.x1),
                        Text(
                          items[i].value,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (i != items.length - 1) SizedBox(width: AppSurfaceSpacing.x1),
          ],
        ],
      ),
    );
  }
}
