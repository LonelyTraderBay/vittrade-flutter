import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_gradients.dart';
import 'package:vit_trade_flutter/app/theme/app_input_states.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

/// Visual treatment of a [VitCard]'s background and border.
enum VitCardVariant { standard, hero, inner, ghost }

/// Corner radius preset for a [VitCard].
enum VitCardRadius {
  /// 16px — standard card surface.
  standard,

  /// 24px — hero/large card surface.
  large,

  /// 8px — tight/dense card or control surface (Trade Command Center v2).
  tight,
}

/// Vertical alignment of [VitCard] content inside a fixed-height surface.
///
/// Use [center] whenever [VitCard.height] or [VitCard.constraints.minHeight]
/// is set so tile cards stay optically balanced without per-page Column hacks.
enum VitCardContentAlign {
  /// Default — content stacks from the top (scroll/detail cards).
  start,

  /// Centers content vertically inside a fixed or minimum-height card.
  center,
}

/// Base surface primitive for card-shaped content app-wide: variant-driven
/// background/border, optional tap handling, padding, and sizing.
class VitCard extends StatelessWidget {
  const VitCard({
    super.key,
    required this.child,
    this.variant = VitCardVariant.standard,
    this.radius = VitCardRadius.standard,
    this.padding,
    this.density,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.borderColor,
    this.background,
    this.clip = false,
    this.onTap,
    this.contentAlign = VitCardContentAlign.start,
  });

  final Widget child;
  final VitCardVariant variant;
  final VitCardRadius radius;
  final EdgeInsetsGeometry? padding;
  final VitDensity? density;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final Color? borderColor;
  final Widget? background;
  final bool clip;
  final VoidCallback? onTap;
  final VitCardContentAlign contentAlign;

  bool get _centersContent {
    if (contentAlign != VitCardContentAlign.center) {
      return false;
    }
    if (height != null) {
      return true;
    }
    final minHeight = constraints?.minHeight;
    return minHeight != null && minHeight > 0;
  }

  BorderRadius get _borderRadius {
    switch (radius) {
      case VitCardRadius.standard:
        return AppRadii.cardRadius;
      case VitCardRadius.large:
        return AppRadii.cardLargeRadius;
      case VitCardRadius.tight:
        return AppRadii.smRadius;
    }
  }

  ShapeDecoration get _decoration {
    final resolvedBorder = borderColor;
    switch (variant) {
      case VitCardVariant.hero:
        return ShapeDecoration(
          gradient: AppGradients.portfolio,
          shape: RoundedRectangleBorder(
            borderRadius: _borderRadius,
            side: BorderSide(
              color: resolvedBorder ?? AppColors.portfolioBorder,
            ),
          ),
          shadows: const [
            BoxShadow(
              color: AppColors.primary08,
              blurRadius: AppSpacing.ctaElevationBlur,
              spreadRadius: AppSpacing.ctaElevationSpread,
              offset: Offset(0, AppSpacing.ctaElevationYOffset),
            ),
          ],
        );
      case VitCardVariant.inner:
      case VitCardVariant.ghost:
        return ShapeDecoration(
          color: variant == VitCardVariant.inner
              ? AppColors.surface2
              : AppColors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: _borderRadius,
            side: resolvedBorder == null
                ? BorderSide.none
                : BorderSide(color: resolvedBorder),
          ),
        );
      case VitCardVariant.standard:
        return ShapeDecoration(
          color: AppColors.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: _borderRadius,
            side: BorderSide(color: resolvedBorder ?? AppColors.cardBorder),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = child;
    if (_centersContent) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [content],
      );
    }
    final resolvedPadding = padding ?? density?.cardPadding;
    if (resolvedPadding != null) {
      content = Padding(padding: resolvedPadding, child: content);
    }
    if (background != null) {
      content = Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(child: background!),
          content,
        ],
      );
    }

    Widget decorated = DecoratedBox(
      decoration: _decoration,
      child: Material(
        type: MaterialType.transparency,
        child: onTap == null
            ? content
            : InkWell(
                onTap: onTap,
                borderRadius: _borderRadius,
                hoverColor: AppInputStates.hoverOverlay,
                focusColor: AppInputStates.focusOverlay,
                child: content,
              ),
      ),
    );

    if (clip) {
      decorated = ClipRRect(
        borderRadius: _borderRadius,
        clipBehavior: Clip.antiAlias,
        child: decorated,
      );
    }
    if (alignment != null) {
      decorated = Align(alignment: alignment!, child: decorated);
    }
    if (constraints != null) {
      decorated = ConstrainedBox(constraints: constraints!, child: decorated);
    }
    if (width != null || height != null) {
      decorated = SizedBox(width: width, height: height, child: decorated);
    }
    if (margin != null) {
      decorated = Padding(padding: margin!, child: decorated);
    }

    return decorated;
  }
}

/// Small ghost-tinted inner stat tile, typically holding a metric label and
/// value inside a parent [VitCard].
class VitCardStat extends StatelessWidget {
  const VitCardStat({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.all(AppSpacing.x3),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.portfolioBtnGhost,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
