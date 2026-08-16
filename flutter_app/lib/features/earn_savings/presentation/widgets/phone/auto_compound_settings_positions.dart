part of '../../phone/pages/savings/auto_compound_settings_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.positions});

  final List<AutoCompoundPositionDraft> positions;

  @override
  Widget build(BuildContext context) {
    final active = positions.where((position) => position.autoCompound).length;
    final totalCompounded = positions.fold<double>(
      0,
      (sum, position) =>
          sum + _usdValue(position.asset, position.totalCompounded),
    );
    final totalEvents = positions.fold<int>(
      0,
      (sum, position) => sum + position.compoundCount,
    );

    return VitCard(
      key: AutoCompoundSettingsPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.autorenew_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Auto-Compound Overview',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: 'Đang bật',
                  value: '$active/${positions.length}',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryStat(
                  label: 'Đã compound (USD)',
                  value: _formatUsd(totalCompounded),
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryStat(
                  label: 'Tổng lần',
                  value: '$totalEvents',
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.position,
    required this.onToggle,
    required this.onSettings,
  });

  final AutoCompoundPositionDraft position;
  final VoidCallback onToggle;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final effectiveApy = position.autoCompound
        ? position.apy + position.estimatedBoost / 100
        : position.apy;
    final accent = _assetColor(position.asset);

    return VitCard(
      key: AutoCompoundSettingsPage.positionKey(position.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _AssetBadge(asset: position.asset, color: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(position.product, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      children: [
                        Text(
                          '${_formatAmount(position.amount)} ${position.asset}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        Text(
                          '${effectiveApy.toStringAsFixed(2)}% APY',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.buy,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _ToggleSwitch(
                key: AutoCompoundSettingsPage.toggleKey(position.id),
                on: position.autoCompound,
                onTap: onToggle,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          if (position.autoCompound)
            _CompoundDetails(position: position)
          else
            const _DisabledWarning(),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: position.autoCompound ? AppColors.buy : AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  position.autoCompound
                      ? '+${(position.estimatedBoost / 100).toStringAsFixed(2)}% APY từ compound'
                      : 'Bật compound để tăng APY',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
              VitCtaButton(
                key: AutoCompoundSettingsPage.settingsButtonKey(position.id),
                onPressed: onSettings,
                variant: VitCtaButtonVariant.secondary,
                fullWidth: false,
                height: AppSpacing.buttonCompact,
                padding: EarnSpacingTokens.earnCardPaddingX3X2,
                leading: const Icon(Icons.settings_outlined),
                child: const Text('Cài đặt'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompoundDetails extends StatelessWidget {
  const _CompoundDetails({required this.position});

  final AutoCompoundPositionDraft position;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  _frequencyLabel(position.compoundFrequency),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                'Ngưỡng: ${_formatAmount(position.compoundThreshold)} ${position.asset}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đã compound: ${_formatAmount(position.totalCompounded)} ${position.asset}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Text(
                '${position.compoundCount} lần',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          if (position.lastCompounded != '—') ...[
            const SizedBox(height: AppSpacing.x1),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Gần nhất: ${position.lastCompounded}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DisabledWarning extends StatelessWidget {
  const _DisabledWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Auto-compound đang tắt — lãi sẽ tích luỹ riêng, không cộng vào gốc',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
