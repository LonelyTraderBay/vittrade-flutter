import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// One numbered step (title + optional description) rendered by
/// [VitStepList].
class VitStepItem {
  const VitStepItem({required this.title, this.description, this.stepNumber});

  final String title;
  final String? description;

  /// When null, the 1-based index in [VitStepList] is used.
  final int? stepNumber;
}

/// Numbered vertical step list for guides and onboarding.
class VitStepList extends StatelessWidget {
  const VitStepList({
    super.key,
    required this.steps,
    this.accentColor = AppColors.accent,
    this.gap,
  });

  final List<VitStepItem> steps;
  final Color accentColor;
  final double? gap;

  @override
  Widget build(BuildContext context) {
    final resolvedGap = gap ?? AppSurfaceSpacing.pageRhythmStandardInnerGap;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0) SizedBox(height: resolvedGap),
          _VitStepRow(
            step: steps[i],
            displayNumber: steps[i].stepNumber ?? (i + 1),
            accentColor: accentColor,
          ),
        ],
      ],
    );
  }
}

class _VitStepRow extends StatelessWidget {
  const _VitStepRow({
    required this.step,
    required this.displayNumber,
    required this.accentColor,
  });

  final VitStepItem step;
  final int displayNumber;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: ShapeDecoration(
            color: accentColor,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.lgRadius,
            ),
          ),
          child: SizedBox.square(
            dimension: AppSurfaceSpacing.x6,
            child: Center(
              child: Text(
                '$displayNumber',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.navCenterIcon,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSurfaceSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(step.title, style: AppTextStyles.baseMedium),
              if (step.description != null) ...[
                SizedBox(height: AppSurfaceSpacing.x1),
                Text(
                  step.description!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
