import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// One segment (value/label/accent) rendered inside a [VitSegmentedChoice].
class VitSegmentedChoiceOption<T> {
  const VitSegmentedChoiceOption({
    required this.value,
    required this.label,
    this.accentColor,
    this.key,
    this.activeKey,
    this.leading,
    this.semanticLabel,
  });

  final T value;
  final String label;
  final Color? accentColor;
  final Key? key;
  final Key? activeKey;
  final Widget? leading;
  final String? semanticLabel;
}

/// Segmented control for buy/sell and similar binary choices.
///
/// Default [borderless] layout renders independent pills with no outer track
/// rim — only the selected segment shows accent fill + outline.
class VitSegmentedChoice<T> extends StatelessWidget {
  const VitSegmentedChoice({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.height,
    this.density = VitDensity.compact,
    this.enabled = true,
    this.borderRadius = AppRadii.inputRadius,
    this.gap,
    this.borderless = true,
    this.trackColor = AppColors.surface2,
    this.borderColor = AppColors.cardBorder,
    this.padding,
  });

  final List<VitSegmentedChoiceOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final double? height;
  final VitDensity density;
  final bool enabled;
  final BorderRadius borderRadius;
  final double? gap;
  final bool borderless;
  final Color trackColor;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;

  bool get _interactive => enabled;

  /// Binary buy/sell toggle (MUA/BÁN) with standard accent colors.
  static VitSegmentedChoice<bool> buySell({
    Key? key,
    required bool isBuy,
    required ValueChanged<bool> onChanged,
    Key? buyKey,
    Key? sellKey,
    Key? buyActiveKey,
    Key? sellActiveKey,
    double? height,
    VitDensity density = VitDensity.compact,
    BorderRadius borderRadius = AppRadii.inputRadius,
  }) {
    return VitSegmentedChoice<bool>(
      key: key,
      selected: isBuy,
      onChanged: onChanged,
      height: height,
      density: density,
      borderRadius: borderRadius,
      options: [
        VitSegmentedChoiceOption(
          key: buyKey,
          activeKey: buyActiveKey,
          value: true,
          label: 'MUA',
          accentColor: AppColors.buy,
          semanticLabel: 'Chọn mua',
        ),
        VitSegmentedChoiceOption(
          key: sellKey,
          activeKey: sellActiveKey,
          value: false,
          label: 'BÁN',
          accentColor: AppColors.sell,
          semanticLabel: 'Chọn bán',
        ),
      ],
    );
  }

  /// Semantic 2–4 option row using a single primary accent (e.g. order tabs).
  static VitSegmentedChoice<T> withPrimaryAccent<T>({
    Key? key,
    required List<VitSegmentedChoiceOption<T>> options,
    required T selected,
    required ValueChanged<T> onChanged,
    Color accentColor = AppColors.primarySoft,
    double? height,
    VitDensity density = VitDensity.compact,
    BorderRadius borderRadius = AppRadii.inputRadius,
  }) {
    assert(options.length >= 2 && options.length <= 4);
    return VitSegmentedChoice<T>(
      key: key,
      selected: selected,
      onChanged: onChanged,
      height: height,
      density: density,
      borderRadius: borderRadius,
      options: [
        for (final option in options)
          VitSegmentedChoiceOption<T>(
            key: option.key,
            activeKey: option.activeKey,
            value: option.value,
            label: option.label,
            accentColor: option.accentColor ?? accentColor,
            leading: option.leading,
            semanticLabel: option.semanticLabel,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      options.length >= 2 && options.length <= 4,
      'VitSegmentedChoice supports 2–4 options',
    );

    final resolvedHeight = height ?? density.controlHeight;
    final resolvedGap = gap ?? AppSurfaceSpacing.x1;
    final resolvedPadding =
        padding ?? AppSurfaceSpacing.vitChoicePillCompactPadding;
    final segments = [
      for (var i = 0; i < options.length; i++) ...[
        if (i > 0) SizedBox(width: borderless ? resolvedGap : 0),
        Expanded(
          child: KeyedSubtree(
            key: options[i].key,
            child: _buildSegment(options[i], padding: resolvedPadding),
          ),
        ),
      ],
    ];

    if (borderless) {
      return SizedBox(
        height: resolvedHeight,
        child: Row(children: segments),
      );
    }

    return SizedBox(
      height: resolvedHeight,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: trackColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide(color: borderColor),
          ),
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Row(
            children: [
              for (var i = 0; i < options.length; i++) ...[
                if (i > 0)
                  ColoredBox(
                    color: borderColor,
                    child: const SizedBox(width: 1),
                  ),
                Expanded(
                  child: KeyedSubtree(
                    key: options[i].key,
                    child: _buildSegment(options[i], padding: resolvedPadding),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegment(
    VitSegmentedChoiceOption<T> option, {
    required EdgeInsetsGeometry padding,
  }) {
    final isSelected = option.value == selected;
    final accent = option.accentColor ?? AppColors.primarySoft;
    final foreground = !_interactive
        ? AppColors.text3
        : isSelected
        ? accent
        : AppColors.text2;
    final fill = isSelected
        ? accent.withValues(alpha: .14)
        : AppColors.transparent;
    final segmentBorder = !_interactive
        ? AppColors.controlBorderDisabled
        : isSelected
        ? accent.withValues(alpha: .48)
        : borderless
        ? AppColors.portfolioBtnGhostBorder
        : AppColors.transparent;

    final labelText = Text(
      option.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: AppTextStyles.caption.copyWith(
        color: foreground,
        fontWeight: AppTextStyles.bold,
      ),
    );

    final row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (option.leading != null) ...[
          IconTheme(
            data: IconThemeData(
              color: foreground,
              size: AppSurfaceSpacing.iconSm,
            ),
            child: option.leading!,
          ),
          SizedBox(width: AppSurfaceSpacing.x1),
        ],
        Flexible(child: labelText),
      ],
    );

    return Semantics(
      label: option.semanticLabel ?? option.label,
      button: true,
      selected: isSelected,
      enabled: _interactive,
      child: Material(
        color: AppColors.transparent,
        child: Ink(
          decoration: ShapeDecoration(
            color: fill,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: BorderSide(color: segmentBorder),
            ),
          ),
          child: InkWell(
            key: isSelected ? option.activeKey : null,
            onTap: _interactive ? () => onChanged(option.value) : null,
            borderRadius: borderRadius,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: padding,
                child: Center(child: row),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
