part of '../../phone/pages/orders/p2p_order_page.dart';

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.action});

  final P2POrderQuickActionDraft action;

  @override
  Widget build(BuildContext context) {
    final color = _quickActionColor(action.id);
    return VitChoicePill(
      label: action.label,
      selected: true,
      onTap: () => context.go(action.route),
      fullWidth: true,
      padding: P2PSpacingTokens.p2pOrderQuickButtonPadding,
      accentColor: color,
      leading: Icon(_quickActionIcon(action.iconKey)),
      semanticLabel: action.label,
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.label,
    required this.value,
    this.emphasis = false,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool emphasis;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: AppSpacing.x2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: emphasis
                        ? AppTextStyles.bold
                        : AppTextStyles.medium,
                    fontFeatures: emphasis
                        ? AppTextStyles.tabularFigures
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: _p2pOrderDividerHeight,
            color: AppColors.divider,
          ),
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .10),
      borderRadius: AppRadii.inputRadius,
      child: Padding(
        padding: P2PSpacingTokens.p2pOrderSmallPillPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: P2PSpacingTokens.p2pOrderSmallPillIcon,
            ),
            const SizedBox(width: AppSpacing.x1),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: true,
      onTap: onPressed,
      padding: P2PSpacingTokens.p2pOrderSmallButtonPadding,
      accentColor: color,
      leading: Icon(icon),
      semanticLabel: label,
    );
  }
}

class _TextActionButton extends StatelessWidget {
  const _TextActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final Widget icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: false,
      onTap: onPressed,
      padding: P2PSpacingTokens.p2pOrderTextActionPadding,
      accentColor: color,
      leading: icon,
      semanticLabel: label,
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    super.key,
    required this.label,
    required this.copied,
    required this.onPressed,
  });

  final String label;
  final bool copied;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _SmallButton(
      icon: copied ? Icons.check_rounded : Icons.copy_rounded,
      label: label,
      color: copied ? AppColors.buy : AppModuleAccents.p2p,
      onPressed: onPressed,
    );
  }
}

class _InlineWarning extends StatelessWidget {
  const _InlineWarning({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warningBg,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: AppColors.warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pOrderInlineWarningPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    message,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrPatternPainter extends CustomPainter {
  const _QrPatternPainter({required this.data});

  final String data;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = AppColors.onAccent;
    final foreground = Paint()..color = AppColors.surface;
    final cell = size.width / 21;
    canvas.drawRect(Offset.zero & size, background);

    void drawFinder(int row, int col) {
      final origin = Offset(col * cell, row * cell);
      canvas.drawRect(origin & Size(cell * 7, cell * 7), foreground);
      canvas.drawRect(
        origin + Offset(cell, cell) & Size(cell * 5, cell * 5),
        background,
      );
      canvas.drawRect(
        origin + Offset(cell * 2, cell * 2) & Size(cell * 3, cell * 3),
        foreground,
      );
    }

    drawFinder(0, 0);
    drawFinder(0, 14);
    drawFinder(14, 0);

    final seed = data.codeUnits.fold<int>(0, (sum, code) => sum + code);
    for (var row = 0; row < 21; row++) {
      for (var col = 0; col < 21; col++) {
        final inFinder =
            (row < 7 && col < 7) ||
            (row < 7 && col >= 14) ||
            (row >= 14 && col < 7);
        if (inFinder) continue;
        final hash = (seed * (row * 21 + col + 1) * 31) % 100;
        if (hash < 42) {
          canvas.drawRect(
            Offset(col * cell, row * cell) & Size(cell, cell),
            foreground,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrPatternPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

IconData _timelineIcon(String iconKey) {
  return switch (iconKey) {
    'created' => Icons.receipt_long_outlined,
    'payment' => Icons.schedule_rounded,
    'confirm' => Icons.shield_outlined,
    'release' => Icons.lock_outline_rounded,
    _ => Icons.circle_outlined,
  };
}

Color _stepColor(P2POrderStepStatus status) {
  return switch (status) {
    P2POrderStepStatus.completed => AppColors.buy,
    P2POrderStepStatus.active => AppModuleAccents.p2p,
    P2POrderStepStatus.pending => AppColors.text3,
  };
}

Color _stepBackground(P2POrderStepStatus status) {
  return switch (status) {
    P2POrderStepStatus.completed => AppColors.buy10,
    P2POrderStepStatus.active => AppColors.warn10,
    P2POrderStepStatus.pending => AppColors.surface2,
  };
}

IconData _quickActionIcon(String iconKey) {
  return switch (iconKey) {
    'merchant' => Icons.groups_outlined,
    'block' => Icons.person_off_outlined,
    'guide' => Icons.menu_book_outlined,
    'support' => Icons.help_outline_rounded,
    _ => Icons.chevron_right_rounded,
  };
}

Color _quickActionColor(String id) {
  return switch (id) {
    'block' => AppColors.sell,
    'guide' => AppColors.accent,
    'support' => AppColors.buy,
    _ => AppColors.text2,
  };
}

String _formatCrypto(double value) => formatP2PCrypto(value);

String _formatVnd(int value) => formatP2PVnd(value);
