import 'dart:async';

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

/// Pulsing loading placeholder block of fixed [width]/[height], used to
/// build skeleton loading rows/lists.
class VitSkeleton extends StatefulWidget {
  const VitSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppRadii.smRadius,
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  State<VitSkeleton> createState() => _VitSkeletonState();
}

class _VitSkeletonState extends State<VitSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _color;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    unawaited(_controller.repeat(reverse: true));
    _color = ColorTween(
      begin: AppColors.surface2,
      end: AppColors.surface3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _color,
        builder: (context, child) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: _color.value,
                shape: RoundedRectangleBorder(
                  borderRadius: widget.borderRadius,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// One skeleton list-row shape: optional avatar block plus two-line
/// leading text and two-line trailing value placeholders.
class VitSkeletonRow extends StatelessWidget {
  const VitSkeletonRow({super.key, this.showAvatar = true});

  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.rowPy,
      ),
      child: Row(
        children: [
          if (showAvatar) ...[
            const VitSkeleton(
              width: 40,
              height: 40,
              borderRadius: AppRadii.smRadius,
            ),
            const SizedBox(width: AppSpacing.x3),
          ],
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VitSkeleton(width: 150, height: 14),
                SizedBox(height: AppSpacing.x3),
                VitSkeleton(width: 92, height: 10),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              VitSkeleton(width: 70, height: 14),
              SizedBox(height: AppSpacing.x3),
              VitSkeleton(width: 48, height: 18),
            ],
          ),
        ],
      ),
    );
  }
}

/// [VitCard]-wrapped stack of [rows] repeated [VitSkeletonRow]s, divided by
/// hairlines, for list-loading states.
class VitSkeletonList extends StatelessWidget {
  const VitSkeletonList({super.key, this.rows = 5});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: 'Đang tải dữ liệu',
      child: VitCard(
        clip: true,
        child: Column(
          children: [
            for (var i = 0; i < rows; i++) ...[
              const VitSkeletonRow(),
              if (i < rows - 1)
                const Divider(
                  height: AppSpacing.dividerHairline,
                  thickness: AppSpacing.dividerHairline,
                  color: AppColors.divider,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
