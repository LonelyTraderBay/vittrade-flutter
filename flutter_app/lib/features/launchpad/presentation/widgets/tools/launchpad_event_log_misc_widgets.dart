part of '../../phone/pages/tools/launchpad_event_log_page.dart';

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.trailing,
    this.active = false,
    this.compact = false,
  });

  final String label;
  final IconData? icon;
  final IconData? trailing;
  final bool active;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppModuleAccents.launchpad : AppColors.text3;
    return VitCard(
      onTap: onTap,
      variant: active ? VitCardVariant.inner : VitCardVariant.standard,
      radius: VitCardRadius.standard,
      borderColor: active ? AppColors.primary30 : AppColors.cardBorder,
      padding: compact
          ? LaunchpadSpacingTokens.launchpadInlinePillPadding
          : LaunchpadSpacingTokens.launchpadPillPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: color,
              size: LaunchpadSpacingTokens.launchpadIconMd,
            ),
            const SizedBox(width: AppSpacing.x1),
          ],
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: active
                  ? AppTextStyles.extraBold
                  : AppTextStyles.medium,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.x1),
            Icon(
              trailing,
              color: color,
              size: LaunchpadSpacingTokens.launchpadIconMd,
            ),
          ],
        ],
      ),
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({
    super.key,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      width: LaunchpadSpacingTokens.launchpadBox18,
      height: LaunchpadSpacingTokens.launchpadBox18,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: selected ? color : AppColors.borderSolid,
      onTap: onTap,
      background: selected ? ColoredBox(color: color) : null,
      child: selected
          ? const Center(
              child: Icon(
                Icons.check_rounded,
                color: AppColors.onAccent,
                size: LaunchpadSpacingTokens.launchpadIconSm,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final LaunchpadEventLogLevel level;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: level.color.withValues(alpha: .16),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadTinyChipPadding,
        child: Text(
          level.label.toUpperCase(),
          style: AppTextStyles.micro.copyWith(
            color: level.color,
            fontWeight: AppTextStyles.heavy,
          ),
        ),
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadLiveBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ),
    );
  }
}

class _EmptyEvents extends StatelessWidget {
  const _EmptyEvents();

  @override
  Widget build(BuildContext context) {
    return const VitEmptyState(
      key: LaunchpadEventLogPage.emptyKey,
      title: 'Khong tim thay event',
      message: 'Thu thay doi bo loc hoac tu khoa tim kiem',
      icon: Icons.search_off_rounded,
    );
  }
}

extension _EventLevelUi on LaunchpadEventLogLevel {
  String get value {
    return switch (this) {
      LaunchpadEventLogLevel.info => 'info',
      LaunchpadEventLogLevel.success => 'success',
      LaunchpadEventLogLevel.warning => 'warning',
      LaunchpadEventLogLevel.error => 'error',
      LaunchpadEventLogLevel.debug => 'debug',
      LaunchpadEventLogLevel.tx => 'tx',
    };
  }

  String get label {
    return switch (this) {
      LaunchpadEventLogLevel.info => 'Info',
      LaunchpadEventLogLevel.success => 'Success',
      LaunchpadEventLogLevel.warning => 'Warning',
      LaunchpadEventLogLevel.error => 'Error',
      LaunchpadEventLogLevel.debug => 'Debug',
      LaunchpadEventLogLevel.tx => 'Transaction',
    };
  }

  Color get color {
    return switch (this) {
      LaunchpadEventLogLevel.info => AppModuleAccents.launchpad,
      LaunchpadEventLogLevel.success => AppColors.buy,
      LaunchpadEventLogLevel.warning => AppColors.warn,
      LaunchpadEventLogLevel.error => AppColors.sell,
      LaunchpadEventLogLevel.debug => AppColors.text2,
      LaunchpadEventLogLevel.tx => AppColors.accent,
    };
  }

  IconData get icon {
    return switch (this) {
      LaunchpadEventLogLevel.info => Icons.info_outline_rounded,
      LaunchpadEventLogLevel.success => Icons.check_circle_outline_rounded,
      LaunchpadEventLogLevel.warning => Icons.warning_amber_rounded,
      LaunchpadEventLogLevel.error => Icons.error_outline_rounded,
      LaunchpadEventLogLevel.debug => Icons.bug_report_outlined,
      LaunchpadEventLogLevel.tx => Icons.bolt_rounded,
    };
  }
}

IconData _formatIcon(String iconKey) {
  return switch (iconKey) {
    'json' => Icons.data_object_rounded,
    'csv' => Icons.table_chart_outlined,
    _ => Icons.description_outlined,
  };
}
