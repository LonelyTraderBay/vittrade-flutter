import 'dart:async';

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
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
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AppSurfaceSpacing.x4,
        vertical: AppSurfaceSpacing.rowPy,
      ),
      child: Row(
        children: [
          if (showAvatar) ...[
            const VitSkeleton(
              width: 40,
              height: 40,
              borderRadius: AppRadii.smRadius,
            ),
            SizedBox(width: AppSurfaceSpacing.x3),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VitSkeleton(width: 150, height: 14),
                SizedBox(height: AppSurfaceSpacing.x3),
                const VitSkeleton(width: 92, height: 10),
              ],
            ),
          ),
          SizedBox(width: AppSurfaceSpacing.x3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const VitSkeleton(width: 70, height: 14),
              SizedBox(height: AppSurfaceSpacing.x3),
              const VitSkeleton(width: 48, height: 18),
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
                Divider(
                  height: AppSurfaceSpacing.dividerHairline,
                  thickness: AppSurfaceSpacing.dividerHairline,
                  color: AppColors.divider,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
