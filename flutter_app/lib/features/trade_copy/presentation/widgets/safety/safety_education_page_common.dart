part of '../../phone/pages/safety/safety_education_page.dart';

class _SeveritySection extends StatelessWidget {
  const _SeveritySection({
    required this.title,
    required this.color,
    required this.flags,
  });

  final String title;
  final Color color;
  final List<TradeSafetyRedFlag> flags;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            for (final flag in flags) ...[
              VitCard(
                density: VitDensity.tool,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.tight,
                borderColor: color.withValues(alpha: .65),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flag.flag,
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    Text(
                      flag.explanation,
                      style: AppTextStyles.micro.copyWith(color: color),
                    ),
                  ],
                ),
              ),
              if (flag != flags.last)
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            ],
          ],
        ),
      ],
    );
  }
}

class _VerificationTab extends StatelessWidget {
  const _VerificationTab({required this.tiers});

  final List<TradeSafetyVerificationTier> tiers;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        const _InfoPanel(
          text:
              'Verification là cơ chế bảo vệ user. Provider verified đã qua kiểm tra KYC và performance audit.',
          color: _safetyPrimary,
        ),
        Text(
          'Verification Tiers',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        for (final tier in tiers) _TierCard(tier: tier),
      ],
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({required this.tier});

  final TradeSafetyVerificationTier tier;

  @override
  Widget build(BuildContext context) {
    final color = Color(tier.colorHex);
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: color,
                size: TradeSpacingTokens.tradeBotSmallIcon,
              ),
              const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
              Text(
                tier.tier,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final req in tier.requirements) ...[
            Text(
              '• $req',
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
            if (req != tier.requirements.last)
              const SizedBox(height: AppSpacing.x1),
          ],
        ],
      ),
    );
  }
}

class _ReportTab extends StatelessWidget {
  const _ReportTab({required this.reasons});

  final List<String> reasons;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        _InfoPanel(
          text:
              'Khi nào nên report?\n${reasons.map((item) => '• $item').join('\n')}',
          color: AppColors.sell,
        ),
        VitCard(
          radius: VitCardRadius.tight,
          density: VitDensity.tool,
          borderColor: AppColors.cardBorder,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Report Provider',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const _ReportField(label: 'Provider ID hoặc tên'),
              const _ReportField(label: 'Lý do report'),
              const _ReportField(
                label: 'Mô tả chi tiết',
                height: TradeSpacingTokens.tradeBotControlTall,
              ),
              VitCtaButton(
                onPressed: () => _submitReport(context),
                variant: VitCtaButtonVariant.danger,
                density: VitDensity.tool,
                child: Text(
                  'Submit Report',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submitReport(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Submit Report',
        message: 'Gửi báo cáo sẽ sớm ra mắt',
      ),
    );
  }
}

class _ReportField extends StatelessWidget {
  const _ReportField({
    required this.label,
    this.height = TradeSpacingTokens.tradeBotDisputeEvidenceHeight,
  });

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x1),
        SizedBox(
          height: height,
          child: const VitCardStat(
            padding: AppSpacing.zeroInsets,
            child: SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      density: VitDensity.tool,
      title: 'Review safety guidance',
      message: text,
    );
  }
}

String _severityTitle(String severity) {
  switch (severity) {
    case 'critical':
      return 'Critical (Tuyệt đối không copy)';
    case 'warning':
      return 'Warning (Cần thận trọng)';
    default:
      return 'Caution (Kiểm tra kỹ)';
  }
}

Color _severityColor(String severity) {
  switch (severity) {
    case 'critical':
      return AppColors.sell;
    case 'warning':
      return AppColors.warn;
    default:
      return _safetyPrimary;
  }
}
