import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';

/// Bottom-padding treatment for [VitPageLayout]: `defaultPage` reserves
/// loose bottom spacing, `flush` removes it (e.g. for sticky-footer pages).
enum VitPageVariant { defaultPage, flush }

/// Full-page [Scaffold] wrapper: app background, semantics label/identifier,
/// and variant-driven bottom padding around [child].
class VitPageLayout extends StatelessWidget {
  const VitPageLayout({
    super.key,
    required this.child,
    this.variant = VitPageVariant.defaultPage,
    this.semanticLabel,
    this.semanticIdentifier,
  });

  final Widget child;
  final VitPageVariant variant;

  /// Screen-reader-announced page title. Should be a real description (e.g.
  /// "Đăng nhập"), not an internal screen code — a screen reader speaks
  /// this text aloud. See A11Y-1,
  /// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
  final String? semanticLabel;

  /// Internal screen code (e.g. `SC-007`) for tooling/debugging — mapped to
  /// [Semantics.identifier], which assistive tech does NOT announce. Use
  /// this instead of stuffing the code into [semanticLabel].
  final String? semanticIdentifier;

  Color get _background {
    switch (variant) {
      case VitPageVariant.defaultPage:
      case VitPageVariant.flush:
        return AppColors.bg;
    }
  }

  double get _bottomPadding {
    switch (variant) {
      case VitPageVariant.flush:
        return AppSurfaceSpacing.zero;
      case VitPageVariant.defaultPage:
        return AppSurfaceSpacing.pageEndBreathing;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      resizeToAvoidBottomInset: false,
      body: Semantics(
        container: true,
        label: semanticLabel,
        identifier: semanticIdentifier,
        child: ColoredBox(
          color: _background,
          child: SizedBox.expand(
            child: Padding(
              padding: EdgeInsetsDirectional.only(bottom: _bottomPadding),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom-pinned footer surface with a top divider and standard padding,
/// typically holding a primary CTA below scrollable page content.
class VitStickyFooter extends StatelessWidget {
  const VitStickyFooter({
    super.key,
    required this.child,
    this.showBorder = true,
    this.backgroundColor = AppColors.surface,
  });

  final Widget child;
  final bool showBorder;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: showBorder
            ? const Border(top: BorderSide(color: AppColors.divider))
            : const Border(),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          AppSurfaceSpacing.contentPad,
          AppSurfaceSpacing.pageContentTopRelaxed,
          AppSurfaceSpacing.contentPad,
          AppSurfaceSpacing.contentPad,
        ),
        child: child,
      ),
    );
  }
}
