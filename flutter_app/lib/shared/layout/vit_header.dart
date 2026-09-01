import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_top_header_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';

export 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';

/// Layout shape of a [VitHeader]: left-aligned page title, centered
/// standard title, or a fully custom [VitHeader.child].
enum VitHeaderVariant { page, standard, custom }

/// The single trailing quick-action a [VitHeader] can show via
/// [VitHeader.action] (superseded by [VitHeader.actions] for multiple items).
enum VitHeaderAction { none, bell, search, more }

/// Shared top-of-page header: optional back button, title/subtitle, and up
/// to three trailing [VitHeaderActionItem]s.
class VitHeader extends StatelessWidget {
  const VitHeader({
    super.key,
    this.variant = VitHeaderVariant.page,
    this.title,
    this.subtitle,
    this.showBack = false,
    this.trailing,
    this.actions = const [],
    this.action = VitHeaderAction.none,
    this.badgeCount = 0,
    this.transparent = false,
    this.horizontalPadding,
    this.backKey,
    this.onBack,
    this.onAction,
    this.child,
  });

  final VitHeaderVariant variant;
  final String? title;
  final String? subtitle;
  final bool showBack;
  final Widget? trailing;
  final List<VitHeaderActionItem> actions;
  final VitHeaderAction action;
  final int badgeCount;
  final bool transparent;

  /// Horizontal inset override. Null (the default) keeps
  /// [AppTopHeaderTokens.horizontalPadding]; a pane living inside a shell
  /// that already owns the outer inset passes `AppSurfaceSpacing.zero` so the
  /// header aligns with full-bleed content in the same column.
  final double? horizontalPadding;
  final Key? backKey;
  final VoidCallback? onBack;
  final VoidCallback? onAction;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    assert(
      actions.length <= 3,
      'VitHeader.actions supports up to 3 actions. Use more overflow.',
    );
    assert(
      variant == VitHeaderVariant.custom || !showBack || onBack != null,
      'VitHeader.showBack requires onBack so visible back buttons are actionable.',
    );

    if (variant == VitHeaderVariant.custom) {
      return child ?? const SizedBox.shrink();
    }

    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: transparent
            ? AppTopHeaderTokens.transparentSurfaceColor
            : AppTopHeaderTokens.surfaceColor,
        shape: transparent
            ? const Border()
            : const Border(
                bottom: BorderSide(color: AppTopHeaderTokens.dividerColor),
              ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppTopHeaderTokens.detailMinHeight,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal:
                horizontalPadding ?? AppTopHeaderTokens.horizontalPadding,
            vertical: hasSubtitle
                ? AppTopHeaderTokens.detailVerticalPaddingWithSubtitle
                : 0,
          ),
          child: variant == VitHeaderVariant.standard
              ? _StandardHeaderContent(header: this, hasSubtitle: hasSubtitle)
              : _PageHeaderContent(header: this, hasSubtitle: hasSubtitle),
        ),
      ),
    );
  }
}

class _PageHeaderContent extends StatelessWidget {
  const _PageHeaderContent({required this.header, required this.hasSubtitle});

  final VitHeader header;
  final bool hasSubtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: hasSubtitle
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        if (header.showBack) ...[
          _BackButton(buttonKey: header.backKey, onPressed: header.onBack!),
          const SizedBox(width: AppTopHeaderTokens.leadingGap),
        ],
        Expanded(child: _TitleBlock(header: header, alignCenter: false)),
        _HeaderTrailing(header: header, isPageVariant: true),
      ],
    );
  }
}

class _StandardHeaderContent extends StatelessWidget {
  const _StandardHeaderContent({
    required this.header,
    required this.hasSubtitle,
  });

  final VitHeader header;
  final bool hasSubtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: hasSubtitle
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: header.showBack
                ? _BackButton(
                    buttonKey: header.backKey,
                    onPressed: header.onBack!,
                  )
                : const SizedBox(
                    width: AppTopHeaderTokens.standardEmptyBackWidth,
                  ),
          ),
        ),
        Expanded(
          flex: 2,
          child: _TitleBlock(header: header, alignCenter: true),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: _HeaderTrailing(header: header, isPageVariant: false),
          ),
        ),
      ],
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.header, required this.alignCenter});

  final VitHeader header;
  final bool alignCenter;

  @override
  Widget build(BuildContext context) {
    final title = header.title;
    final subtitle = header.subtitle;
    final showTitleBadge =
        header.badgeCount > 0 &&
        header.action == VitHeaderAction.none &&
        header.actions.isEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignCenter
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (title != null)
          Row(
            mainAxisSize: alignCenter ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium,
                ),
              ),
              if (showTitleBadge) ...[
                const SizedBox(width: AppTopHeaderTokens.titleBadgeGap),
                _CountBadge(count: header.badgeCount),
              ],
            ],
          ),
        if (subtitle != null)
          Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption,
          ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({this.buttonKey, required this.onPressed});

  final Key? buttonKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitHeaderActionButton(
      key: buttonKey,
      type: VitHeaderActionType.back,
      tone: VitHeaderActionTone.transparent,
      onPressed: onPressed,
    );
  }
}

class _HeaderTrailing extends StatelessWidget {
  const _HeaderTrailing({required this.header, required this.isPageVariant});

  final VitHeader header;
  final bool isPageVariant;

  @override
  Widget build(BuildContext context) {
    if (header.trailing != null) return header.trailing!;
    if (header.actions.isNotEmpty) {
      return _HeaderActionRow(actions: header.actions);
    }
    if (header.action == VitHeaderAction.none) {
      return isPageVariant
          ? const SizedBox.shrink()
          : const SizedBox(width: AppTopHeaderTokens.standardEmptyActionWidth);
    }

    final type = switch (header.action) {
      VitHeaderAction.bell => VitHeaderActionType.notifications,
      VitHeaderAction.search => VitHeaderActionType.search,
      VitHeaderAction.more => VitHeaderActionType.more,
      VitHeaderAction.none => VitHeaderActionType.more,
    };

    return VitHeaderActionButton(
      type: type,
      badgeCount: header.action == VitHeaderAction.bell ? header.badgeCount : 0,
      onPressed: header.onAction,
    );
  }
}

class _HeaderActionRow extends StatelessWidget {
  const _HeaderActionRow({required this.actions});

  final List<VitHeaderActionItem> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < actions.length; index++) ...[
          if (index > 0) const SizedBox(width: AppTopHeaderTokens.actionGap),
          VitHeaderActionButton.fromItem(actions[index]),
        ],
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: AppTopHeaderTokens.badgeMinSize,
      ),
      child: SizedBox(
        height: AppTopHeaderTokens.badgeHeight,
        child: DecoratedBox(
          decoration: const ShapeDecoration(
            color: AppColors.sell,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
            shadows: [
              BoxShadow(
                color: AppColors.sell20,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppTopHeaderTokens.badgeHorizontalPadding,
            ),
            child: Center(
              child: Text(
                count > 99 ? '99+' : '$count',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
