import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';

import 'package:vit_trade_flutter/shared/widgets/vit_choice_pill.dart';

/// Thin wrapper over [VitChoicePill] for the common "single filter toggle
/// with an explicit accent color" case used by markets/news/arena/launchpad
/// filter bars and category rows.
class VitFilterChip extends StatelessWidget {
  const VitFilterChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    required this.color,
    this.count,
    this.semanticCountSuffix,
    this.height,
    this.padding,
    this.leading,
    this.semanticLabel,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;
  final int? count;
  final String? semanticCountSuffix;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Widget? leading;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final resolvedLabel = count == null ? label : '$label ($count)';
    final suffix = semanticCountSuffix == null ? '' : ' $semanticCountSuffix';
    final resolvedSemanticLabel =
        semanticLabel ?? (count == null ? label : '$label, $count$suffix');

    return VitChoicePill(
      label: resolvedLabel,
      selected: active,
      onTap: onTap,
      accentColor: color,
      height: height,
      padding:
          padding ??
          EdgeInsetsDirectional.symmetric(horizontal: AppSurfaceSpacing.x3),
      leading: leading,
      semanticLabel: resolvedSemanticLabel,
    );
  }
}
