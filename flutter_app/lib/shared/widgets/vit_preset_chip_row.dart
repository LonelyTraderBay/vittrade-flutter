import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_choice_pill.dart';

/// One selectable preset entry (value + label) rendered as a
/// [VitChoicePill] inside a [VitPresetChipRow].
class VitPresetChipItem<T> {
  const VitPresetChipItem({
    required this.value,
    required this.label,
    this.key,
    this.semanticLabel,
  });

  final T value;
  final String label;
  final Key? key;
  final String? semanticLabel;
}

/// Equal-width preset chip row (amount %, leverage stops, etc.).
///
/// Do **not** wrap in [VitCard] — each chip already renders its own outline.
/// For binary 2–4 option toggles (MUA/BÁN, Long/Short), use [VitSegmentedChoice].
class VitPresetChipRow<T> extends StatelessWidget {
  const VitPresetChipRow({
    super.key,
    required this.items,
    required this.onTap,
    this.selectedValue,
    this.accentColor,
    this.gap = AppSpacing.vitPresetChipRowGap,
    this.height = AppSpacing.vitPresetChipRowHeight,
    this.fullWidth = true,
    this.density = VitDensity.compact,
    this.padding,
    this.tone = VitChoicePillTone.primary,
  });

  final List<VitPresetChipItem<T>> items;
  final ValueChanged<T> onTap;
  final T? selectedValue;
  final Color? accentColor;
  final double gap;
  final double height;
  final bool fullWidth;
  final VitDensity density;
  final EdgeInsetsGeometry? padding;
  final VitChoicePillTone tone;

  /// Balance shortcut presets (25% / 50% / 75% / 100%).
  static VitPresetChipRow<int> percentBalance({
    Key? key,
    List<int> values = const [25, 50, 75, 100],
    required ValueChanged<int> onTap,
    required Key Function(int value) keyFor,
    int? selectedValue,
    Color accentColor = AppColors.primarySoft,
    double gap = AppSpacing.vitPresetChipRowGap,
    double height = AppSpacing.vitPresetChipRowHeight,
    EdgeInsetsGeometry? padding,
  }) {
    return VitPresetChipRow<int>(
      key: key,
      items: [
        for (final value in values)
          VitPresetChipItem<int>(
            key: keyFor(value),
            value: value,
            label: '$value%',
            semanticLabel: 'Use $value% of available balance',
          ),
      ],
      onTap: onTap,
      selectedValue: selectedValue,
      accentColor: accentColor,
      gap: gap,
      height: height,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          // `fullWidth: true` (mặc định, Tier S3): chip căng đều chiếm hết
          // hàng qua Expanded. `fullWidth: false`: chip ôm nội dung — tham
          // số này từng là ĐƯỜNG CHẾT vì Expanded bọc vô điều kiện
          // (2026-08-29: pane timeframe tablet + P2P tax-year đều hỏi
          // content-hug nhưng vẫn bị căng đều).
          if (fullWidth) Expanded(child: _pillFor(index)) else _pillFor(index),
          if (index != items.length - 1) SizedBox(width: gap),
        ],
      ],
    );

    return row;
  }

  VitChoicePill _pillFor(int index) => VitChoicePill(
    key: items[index].key,
    label: items[index].label,
    selected: selectedValue != null && selectedValue == items[index].value,
    onTap: () => onTap(items[index].value),
    accentColor: accentColor,
    tone: tone,
    fullWidth: fullWidth,
    height: height,
    padding: padding,
    density: density,
    semanticLabel: items[index].semanticLabel,
  );
}
