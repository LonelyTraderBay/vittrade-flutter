import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Shared underline tab switcher for the predictions module's per-page enum
/// tabs (calendar, data integration, market maker, portfolio analyzer,
/// advanced chart, risk calculator, social, tournaments).
///
/// Every predictions sub-page previously repeated the same ~25-line
/// `Material(color: AppColors.surface) + VitTabBar(variant: .underline)`
/// wrapper with only the enum type, item labels/keys, and an optional
/// bottom border varying. This widget captures that shared shell so each
/// page's private `_XxxTabBar` only supplies its `items`.
class PredictionEnumTabBar<T extends Enum> extends StatelessWidget {
  const PredictionEnumTabBar({
    super.key,
    required this.activeTab,
    required this.items,
    required this.onChanged,
    this.showBottomBorder = false,
    this.semanticsLabel,
  });

  final T activeTab;
  final List<(Key? widgetKey, T tab, String label)> items;
  final ValueChanged<T> onChanged;
  final bool showBottomBorder;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    Widget bar = VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: activeTab.name,
      onChanged: (key) => onChanged(
        items.map((item) => item.$2).firstWhere((tab) => tab.name == key),
      ),
      tabs: [
        for (final item in items)
          VitTabItem(key: item.$2.name, label: item.$3, widgetKey: item.$1),
      ],
    );

    if (semanticsLabel != null) {
      bar = Semantics(label: semanticsLabel, child: bar);
    }

    return Material(
      color: AppColors.surface,
      shape: showBottomBorder
          ? const Border(bottom: BorderSide(color: AppColors.border))
          : null,
      child: bar,
    );
  }
}
