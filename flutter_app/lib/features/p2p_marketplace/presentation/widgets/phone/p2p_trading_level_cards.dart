part of '../../phone/pages/hub/p2p_trading_level_page.dart';

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.snapshot, required this.level});

  final P2PTradingLevelSnapshot snapshot;
  final P2PTradingLevelDraft level;

  @override
  Widget build(BuildContext context) {
    final currentLevel = snapshot.userLevel.currentLevel;
    final current = level.id == currentLevel;
    final passed = level.id < currentLevel;
    final locked = level.id > currentLevel;
    final accent = _levelColor(level);

    return VitCard(
      key: P2PTradingLevelPage.levelKey(level.id),
      padding: AppSpacing.zeroInsets,
      clip: true,
      borderColor: current ? accent : AppColors.divider,
      child: Opacity(
        opacity: locked ? 0.62 : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: current
                  ? accent.withValues(alpha: 0.10)
                  : passed
                  ? accent.withValues(alpha: 0.05)
                  : AppColors.surface2,
              child: Padding(
                padding: P2PSpacingTokens.p2pTradingLevelCardHeaderPadding,
                child: Row(
                  children: [
                    _LevelIconBadge(
                      level: level,
                      size: P2PSpacingTokens.p2pTradingLevelLevelBadgeSize,
                      locked: locked,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Lv.${level.id} ${level.nameVi}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.baseMedium.copyWith(
                                    color: AppColors.text1,
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x2),
                              if (current)
                                const VitStatusPill(
                                  label: 'Hiện tại',
                                  status: VitStatusPillStatus.success,
                                  size: VitStatusPillSize.sm,
                                )
                              else if (passed)
                                const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: AppColors.buy,
                                  size: AppSpacing.iconSm,
                                )
                              else
                                const VitStatusPill(
                                  label: 'Chưa đạt',
                                  status: VitStatusPillStatus.neutral,
                                  size: VitStatusPillSize.sm,
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x1),
                          Row(
                            children: [
                              Icon(
                                Icons.bolt_rounded,
                                color: locked ? AppColors.text3 : accent,
                                size: AppSpacing.iconSm,
                              ),
                              const SizedBox(width: AppSpacing.x1),
                              Text(
                                'Phí ${_formatFee(level.fee)}',
                                style: AppTextStyles.caption.copyWith(
                                  color: locked ? AppColors.text3 : accent,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              if (!locked && level.id > 1) ...[
                                const SizedBox(width: AppSpacing.x2),
                                VitStatusPill(
                                  label:
                                      '-${_discountFromBasic(snapshot, level)}%',
                                  status: level.id == 3
                                      ? VitStatusPillStatus.purple
                                      : VitStatusPillStatus.info,
                                  size: VitStatusPillSize.sm,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.iconMd,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: P2PSpacingTokens.p2pTradingLevelCardBodyPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _LimitTile(
                          label: 'Hạn mức/ngày',
                          value: _formatLimit(level.dailyLimit),
                          accent: current ? accent : AppColors.text1,
                          highlighted: current,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: _LimitTile(
                          label: 'Hạn mức/đơn',
                          value: _formatLimit(level.perOrderLimit),
                          accent: current ? accent : AppColors.text1,
                          highlighted: current,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Text(
                    'Yêu cầu:',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  for (final requirement in level.requirements) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: locked ? AppColors.text3 : AppColors.buy,
                          size: P2PSpacingTokens.p2pTradingLevelRequirementIcon,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Text(
                            requirement,
                            style: AppTextStyles.caption.copyWith(
                              color: locked ? AppColors.text3 : AppColors.text2,
                              height: P2PSpacingTokens
                                  .p2pTradingLevelRequirementLineHeight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                  ],
                  if (locked && level.id == currentLevel + 1) ...[
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    const Divider(
                      color: AppColors.divider,
                      height: AppSpacing.dividerHairline,
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    VitCtaButton(
                      key: P2PTradingLevelPage.upgradeButtonKey,
                      variant: VitCtaButtonVariant.warning,
                      height:
                          P2PSpacingTokens.p2pTradingLevelUpgradeButtonHeight,
                      leading: const Icon(Icons.trending_up_rounded),
                      onPressed: () =>
                          _upgradeComingSoon(context, level.nameVi),
                      child: Text('Nâng cấp lên ${level.nameVi}'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _upgradeComingSoon(BuildContext context, String levelName) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: 'Nâng cấp lên $levelName sẽ sớm ra mắt',
      ),
    );
  }
}

class _LevelIconBadge extends StatelessWidget {
  const _LevelIconBadge({
    required this.level,
    required this.size,
    this.locked = false,
  });

  final P2PTradingLevelDraft level;
  final double size;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final accent = _levelColor(level);
    return SizedBox.square(
      dimension: size,
      child: Material(
        color: locked ? AppColors.surface2 : accent,
        elevation: locked ? 0 : P2PSpacingTokens.p2pTradingLevelBadgeElevation,
        shadowColor: accent.withValues(alpha: 0.26),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
        clipBehavior: Clip.antiAlias,
        child: Center(
          child: Icon(
            _levelIcon(level.id),
            color: locked ? AppColors.text3 : AppColors.navCenterIcon,
            size: size * P2PSpacingTokens.p2pTradingLevelBadgeIconScale,
          ),
        ),
      ),
    );
  }
}

class _LimitTile extends StatelessWidget {
  const _LimitTile({
    required this.label,
    required this.value,
    required this.accent,
    required this.highlighted,
  });

  final String label;
  final String value;
  final Color accent;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: highlighted
          ? accent.withValues(alpha: 0.20)
          : AppColors.divider,
      padding: P2PSpacingTokens.p2pTradingLevelLimitPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.stacked_line_chart_rounded,
                color: AppColors.text3,
                size: P2PSpacingTokens.p2pTradingLevelInlineIcon,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: accent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Color _levelColor(P2PTradingLevelDraft level) {
  return switch (level.id) {
    1 => AppColors.text3,
    2 => AppColors.primary,
    3 => AppColors.accent,
    _ => AppColors.warn,
  };
}

IconData _levelIcon(int id) {
  return switch (id) {
    1 => Icons.shield_outlined,
    2 => Icons.trending_up_rounded,
    3 => Icons.workspace_premium_outlined,
    _ => Icons.workspace_premium_rounded,
  };
}

String _formatFee(double fee) {
  final decimals = fee == 0.1 ? 1 : 2;
  return '+${fee.toStringAsFixed(decimals)}%';
}

String _formatLimit(int value) {
  if (value == 0) return '∞';
  return _formatCompact(value);
}

String _formatCompact(int value) {
  if (value >= 1000000000) {
    final formatted = value / 1000000000;
    return '${formatted.toStringAsFixed(formatted >= 10 ? 0 : 2)}B';
  }
  if (value >= 1000000) {
    final formatted = value / 1000000;
    return '${formatted.toStringAsFixed(formatted >= 10 ? 0 : 1)}M';
  }
  return value.toString();
}

String _formatVnd(int value) => formatP2PVnd(value);

int _discountFromBasic(
  P2PTradingLevelSnapshot snapshot,
  P2PTradingLevelDraft level,
) {
  final baseFee = snapshot.levels.first.fee;
  return (((baseFee - level.fee) / baseFee) * 100).round();
}
