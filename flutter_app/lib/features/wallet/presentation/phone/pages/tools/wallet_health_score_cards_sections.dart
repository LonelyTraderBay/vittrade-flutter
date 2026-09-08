part of 'wallet_health_score_page.dart';

class _ScoreSummaryCard extends StatelessWidget {
  const _ScoreSummaryCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.status,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final int score;
  final String status;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            borderColor: iconColor.withValues(alpha: .20),
            child: Icon(
              icon,
              color: iconColor,
              size: WalletSpacingTokens.walletHealthSummaryIconGlyph,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: AppTextStyles.sectionTitle.copyWith(color: iconColor),
              ),
              Text(
                status,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.item});

  final WalletSecurityChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.enabled ? _healthGreen : _healthRed;
    return VitCard(
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            radius: VitCardRadius.standard,
            borderColor: color.withValues(alpha: .20),
            child: Icon(
              item.enabled
                  ? Icons.check_circle_outline_rounded
                  : Icons.warning_amber_rounded,
              color: color,
              size: WalletSpacingTokens.walletHealthChecklistIconGlyph,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRequiredCard extends StatelessWidget {
  const _ActionRequiredCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      borderColor: _healthRed.withValues(alpha: .15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _healthRed,
            size: WalletSpacingTokens.walletHealthActionIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cần xử lý',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Sao lưu cụm từ khôi phục và bật danh sách trắng rút tiền để cải thiện điểm bảo mật.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: 1.28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetDistributionCard extends StatelessWidget {
  const _AssetDistributionCard({required this.slices});

  final List<WalletDiversificationSlice> slices;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asset Distribution',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          SizedBox(
            height: VitDensity.compact.controlHeight * 2.8,
            child: CustomPaint(
              painter: _PiePainter(slices),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: WalletSpacingTokens.walletHealthLegendSpacing,
            runSpacing: WalletSpacingTokens.walletHealthLegendRunSpacing,
            children: [
              for (final slice in slices)
                SizedBox(
                  width: WalletSpacingTokens.walletHealthLegendWidth,
                  child: Row(
                    children: [
                      // card-tile: allow-start — fixed surface, not horizontal strip tile
                      VitCard(
                        width: WalletSpacingTokens.walletHealthLegendSwatch,
                        height: _healthLegendSwatchHeight,
                        radius: VitCardRadius.standard,
                        borderColor: Color(slice.colorHex),
                        background: ColoredBox(color: Color(slice.colorHex)),
                        clip: true,
                        child: const SizedBox.expand(),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Expanded(
                        child: Text(
                          '${slice.name} ${slice.value}%',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConcentrationRiskCard extends StatelessWidget {
  const _ConcentrationRiskCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _healthAmber.withValues(alpha: .15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _healthAmber,
                size: WalletSpacingTokens.walletHealthActionIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Concentration Risk',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '42% danh mục của bạn đang ở BTC. Hãy cân đối lại để giảm rủi ro tập trung một tài sản.',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: 1.28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const _AllocationRow(
            label: 'Recommended BTC allocation',
            value: '25-30%',
            color: _healthAmber,
          ),
          const SizedBox(height: AppSpacing.x1),
          const _AllocationRow(
            label: 'Current BTC allocation',
            value: '42%',
            color: _healthRed,
          ),
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          const Icon(
            Icons.bolt_rounded,
            color: _healthAmber,
            size: WalletSpacingTokens.walletHealthActionIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              tip,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      borderColor: _healthPrimary.withValues(alpha: .15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _healthPrimary,
            size: WalletSpacingTokens.walletHealthActionIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label.toUpperCase(), accentColor: color);
  }
}
