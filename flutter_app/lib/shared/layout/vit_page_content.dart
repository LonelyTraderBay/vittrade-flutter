import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_section_header.dart';

/// Top padding preset for [VitPageContent].
enum VitContentPadding { compact, defaultPadding, relaxed, none }

/// Vertical gap preset between [VitPageContent]/[VitPageSection] children.
enum VitContentGap { tight, defaultGap, relaxed, loose }

double _resolveContentGap({
  required VitContentGap gap,
  VitDensity? density,
  double? customGap,
}) {
  if (customGap != null) return customGap;
  if (density != null) return density.pageContentGap;
  switch (gap) {
    case VitContentGap.tight:
      return AppSpacing.pageContentGapTight;
    case VitContentGap.defaultGap:
      return AppSpacing.pageContentGapDefault;
    case VitContentGap.relaxed:
      return AppSpacing.pageContentGapRelaxed;
    case VitContentGap.loose:
      return AppSpacing.pageContentGapLoose;
  }
}

/// Standard page body column: horizontal content padding plus a
/// consistently gapped, optionally growing/full-bleed list of [children].
class VitPageContent extends StatelessWidget {
  const VitPageContent({
    super.key,
    required this.children,
    this.padding = VitContentPadding.defaultPadding,
    this.gap = VitContentGap.defaultGap,
    this.density,
    this.rhythm,
    this.customGap,
    this.grow = false,
    this.fullBleed = false,
  });

  final List<Widget> children;
  final VitContentPadding padding;
  final VitContentGap gap;
  final VitDensity? density;
  final VitPageRhythm? rhythm;
  final double? customGap;
  final bool grow;
  final bool fullBleed;

  double get _topPadding {
    if (density != null) return density!.pageContentTopPadding;
    switch (padding) {
      case VitContentPadding.compact:
        return AppSpacing.pageContentTopCompact;
      case VitContentPadding.defaultPadding:
        return AppSpacing.pageContentTopDefault;
      case VitContentPadding.relaxed:
        return AppSpacing.pageContentTopRelaxed;
      case VitContentPadding.none:
        return AppSpacing.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsetsDirectional.only(
        start: fullBleed ? AppSpacing.zero : AppSpacing.contentPad,
        end: fullBleed ? AppSpacing.zero : AppSpacing.contentPad,
        top: _topPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withGaps(
          children,
          _sectionGap(customGap, rhythm, gap, density),
        ),
      ),
    );

    if (!grow) return content;
    return Expanded(child: content);
  }
}

/// A labeled sub-section inside [VitPageContent]: an optional
/// [VitSectionHeader] (with icon/action) followed by gapped [children].
class VitPageSection extends StatelessWidget {
  const VitPageSection({
    super.key,
    required this.children,
    this.label,
    this.headerIcon,
    this.headerIconColor,
    this.headerVariant = VitSectionHeaderVariant.accentBar,
    this.headerDensity = VitDensity.compact,
    this.actionLabel,
    this.onAction,
    this.actionKey,
    this.actionSemanticLabel,
    this.actionShowChevron = true,
    this.accentColor = AppColors.primary,
    this.gap = VitContentGap.tight,
    this.density,
    this.rhythm,
    this.innerGap,
    this.customGap,
    this.headerTrailing,
  });

  final List<Widget> children;
  final String? label;
  final IconData? headerIcon;
  final Color? headerIconColor;
  final VitSectionHeaderVariant headerVariant;
  final VitDensity headerDensity;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Key? actionKey;
  final String? actionSemanticLabel;
  final bool actionShowChevron;
  final Color accentColor;
  final VitContentGap gap;
  final VitDensity? density;
  final VitPageRhythm? rhythm;
  final double? innerGap;
  final double? customGap;

  /// Optional widget rendered alongside the section header (e.g. a status
  /// pill/badge). When non-null, the header is wrapped in a
  /// `Row([Expanded(header), gap, headerTrailing])`; when null, the header
  /// renders bare (unchanged behavior).
  final Widget? headerTrailing;

  double get _labelBottomGap =>
      innerGap ?? rhythm?.innerGap ?? AppSpacing.pageRhythmStandardInnerGap;

  Widget _buildHeader() {
    final header = VitSectionHeader(
      title: label!,
      icon: headerIcon,
      iconColor: headerIconColor,
      variant: headerVariant,
      accentColor: accentColor,
      density: headerDensity,
      actionLabel: actionLabel,
      onAction: onAction,
      actionKey: actionKey,
      actionSemanticLabel: actionSemanticLabel,
      actionShowChevron: actionShowChevron,
      bottomGap: _labelBottomGap,
    );
    if (headerTrailing == null) return header;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: header),
        const SizedBox(width: AppSpacing.x2),
        headerTrailing!,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) _buildHeader(),
        ..._withGaps(children, _sectionGap(customGap, rhythm, gap, density)),
      ],
    );
  }
}

/// Luật 8pt 12dp tablet (2026-09-01): khi surface tablet active, section
/// gap của tier enum đọc TabletSpacingTokens (12) thay vì AppSpacing của
/// phone (13) — phone đường cũ nguyên vẹn.
double _sectionGap(
  double? customGap,
  VitPageRhythm? rhythm,
  VitContentGap gap,
  VitDensity? density,
) {
  if (customGap != null) return customGap;
  if (rhythm != null) {
    return TabletSpacingTokens.tabletSurfaceActive
        ? switch (rhythm) {
            // Luật 8pt 12dp: section gap tablet = 12 cho mọi tier dọc
            // (compact giữ 8 khi scaffold chủ đích compact — map đủ 5
            // tier, phone đọc enum như cũ).
            VitPageRhythm.compact => TabletSpacingTokens.x3,
            VitPageRhythm.standard ||
            VitPageRhythm.form ||
            VitPageRhythm.relaxed =>
              TabletSpacingTokens.pageRhythmStandardSectionGap,
            VitPageRhythm.flush => TabletSpacingTokens.zero,
          }
        : rhythm.sectionGap;
  }
  return _resolveContentGap(gap: gap, density: density, customGap: null);
}

List<Widget> _withGaps(List<Widget> children, double gap) {
  if (children.isEmpty) return const [];
  return [
    for (var i = 0; i < children.length; i++) ...[
      if (i > 0) SizedBox(height: gap),
      children[i],
    ],
  ];
}
