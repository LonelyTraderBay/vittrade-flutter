part of '../../phone/pages/hub/p2p_trading_level_page.dart';

class _CurrentLevelHero extends StatelessWidget {
  const _CurrentLevelHero({required this.snapshot});

  final P2PTradingLevelSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final user = snapshot.userLevel;
    final level = snapshot.currentLevel;
    final accent = _levelColor(level);
    final dailyRatio = user.dailyUsed / user.dailyLimit;

    return VitCard(
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: accent.withValues(alpha: 0.12),
            child: Padding(
              padding: P2PSpacingTokens.p2pTradingLevelHeroHeaderPadding,
              child: Row(
                children: [
                  _LevelIconBadge(
                    level: level,
                    size: P2PSpacingTokens.p2pTradingLevelHeroBadgeSize,
                  ),
                  const SizedBox(width: AppSpacing.x3),
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
                                style: AppTextStyles.sectionTitle.copyWith(
                                  color: AppColors.text1,
                                  height: AppTextStyles.sectionTitle.height,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x2),
                            const VitStatusPill(
                              label: 'Hiện tại',
                              status: VitStatusPillStatus.success,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmCompactInnerGap,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.bolt_rounded,
                              color: accent,
                              size: AppSpacing.iconSm,
                            ),
                            const SizedBox(width: AppSpacing.x1),
                            Flexible(
                              child: Text(
                                'Phí giao dịch ${_formatFee(user.fee)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body.copyWith(
                                  color: accent,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: P2PSpacingTokens.p2pTradingLevelHeroBodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _HeroMetricCard(
                        icon: Icons.groups_2_outlined,
                        label: 'Giao dịch hoàn tất',
                        value: '${user.completedOrders}',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _HeroMetricCard(
                        icon: Icons.bar_chart_rounded,
                        label: 'Volume tích lũy',
                        value: _formatCompact(user.accumulatedVolume),
                        subvalue: '${_formatVnd(user.accumulatedVolume)} đ',
                        color: AppColors.buy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                const Divider(
                  color: AppColors.divider,
                  height: AppSpacing.dividerHairline,
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Hạn mức ngày',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    VitStatusPill(
                      label: '${snapshot.dailyUsagePercent}%',
                      status: VitStatusPillStatus.purple,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                VitProgressBar(
                  progress: dailyRatio,
                  color: accent,
                  height: P2PSpacingTokens.p2pTradingLevelDailyTrackHeight,
                  borderRadius: AppRadii.smRadius,
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Đã dùng: ',
                          children: [
                            TextSpan(
                              text: '${_formatVnd(user.dailyUsed)} đ',
                              style: AppTextStyles.caption.copyWith(
                                color: accent,
                                fontWeight: AppTextStyles.bold,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ],
                        ),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ),
                    Text(
                      'Tối đa: ${_formatVnd(user.dailyLimit)} đ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetricCard extends StatelessWidget {
  const _HeroMetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.subvalue,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subvalue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: color.withValues(alpha: 0.24),
      background: ColoredBox(color: color.withValues(alpha: 0.08)),
      padding: P2PSpacingTokens.p2pTradingLevelMetricPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: P2PSpacingTokens.p2pTradingLevelMetricIconSize,
                child: Material(
                  color: color.withValues(alpha: 0.14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: color,
                      size: P2PSpacingTokens.p2pTradingLevelMetricGlyphSize,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                    height: P2PSpacingTokens.p2pTradingLevelMicroLineHeight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: P2PSpacingTokens.p2pTradingLevelTitleLineHeight,
            ),
          ),
          if (subvalue != null)
            Text(
              subvalue!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
        ],
      ),
    );
  }
}

class _NextLevelProgress extends StatelessWidget {
  const _NextLevelProgress({required this.snapshot});

  final P2PTradingLevelSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final nextLevel = snapshot.userLevel.currentLevel + 1;
    final progress = snapshot.userLevel.nextLevelProgress;
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: AppColors.accent30,
      padding: P2PSpacingTokens.p2pTradingLevelNextCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.accent,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Tiến trình lên Lv.$nextLevel',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.accent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitProgressBar(
            progress: progress,
            color: AppColors.accent,
            height: P2PSpacingTokens.p2pTradingLevelNextTrackHeight,
            borderRadius: AppRadii.smRadius,
          ),
        ],
      ),
    );
  }
}
