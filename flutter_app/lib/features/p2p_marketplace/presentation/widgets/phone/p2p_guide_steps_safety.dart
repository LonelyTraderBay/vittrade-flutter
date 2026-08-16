part of '../../phone/pages/hub/p2p_guide_page.dart';

class _HowItWorksTab extends StatelessWidget {
  const _HowItWorksTab({
    required this.snapshot,
    required this.mode,
    required this.onModeChanged,
  });

  final P2PGuideSnapshot snapshot;
  final String mode;
  final ValueChanged<String> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final steps = mode == 'buy' ? snapshot.buySteps : snapshot.sellSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSegmentedChoice<String>(
          selected: mode,
          onChanged: onModeChanged,
          options: const [
            VitSegmentedChoiceOption(
              value: 'buy',
              label: 'Mua Crypto',
              key: P2PGuidePage.buyModeKey,
              leading: Icon(Icons.account_balance_wallet_outlined),
            ),
            VitSegmentedChoiceOption(
              value: 'sell',
              label: 'Bán Crypto',
              key: P2PGuidePage.sellModeKey,
              leading: Icon(Icons.description_outlined),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final step in steps) ...[
          _StepRow(step: step),
          if (step.id != steps.last.id) const SizedBox(height: AppSpacing.x1),
        ],
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(
          radius: VitCardRadius.large,
          borderColor: AppColors.buy20,
          padding: P2PSpacingTokens.p2pGuideCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const _RoundIcon(
                    icon: Icons.bolt_rounded,
                    color: AppColors.buy,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bắt đầu ngay!',
                          style: AppTextStyles.baseMedium,
                        ),
                        Text(
                          'Thực hiện giao dịch đầu tiên qua Escrow',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              VitCtaButton(
                key: P2PGuidePage.startKey,
                variant: VitCtaButtonVariant.success,
                onPressed: () => context.go(snapshot.marketRoute),
                child: const Text('Mua crypto ngay'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _ConceptList(),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final P2PGuideStepDraft step;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(step.toneKey);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _NumberIcon(
          step: step.step,
          icon: _guideIcon(step.iconKey),
          color: color,
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Padding(
            padding: P2PSpacingTokens.p2pGuideStepContentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    VitAccentPill(
                      label: 'Bước ${step.step}',
                      accentColor: color,
                      size: VitStatusPillSize.sm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        step.title,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  step.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SafetyTab extends StatelessWidget {
  const _SafetyTab({required this.snapshot});

  final P2PGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          borderColor: AppColors.sell20,
          padding: P2PSpacingTokens.p2pGuideCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: AppColors.sell,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Text(
                    'An toàn giao dịch',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.sell,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'VitTrade bảo vệ giao dịch của bạn qua Escrow. Hãy luôn cẩn thận và tuân thủ các nguyên tắc an toàn.',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final tip in snapshot.safetyTips) ...[
          _SafetyTipCard(tip: tip),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        VitCard(
          radius: VitCardRadius.large,
          borderColor: AppColors.sell20,
          padding: P2PSpacingTokens.p2pGuideCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.report_problem_outlined,
                    color: AppColors.sell,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Nghi ngờ lừa đảo?',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Nếu bạn nghi ngờ giao dịch có dấu hiệu lừa đảo, hãy mở tranh chấp ngay lập tức. Không giải phóng crypto cho đến khi đã nhận đủ tiền.',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              VitCtaButton(
                key: P2PGuidePage.supportKey,
                variant: VitCtaButtonVariant.danger,
                onPressed: () => context.go(snapshot.supportRoute),
                child: const Text('Liên hệ hỗ trợ khẩn cấp'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SafetyTipCard extends StatelessWidget {
  const _SafetyTipCard({required this.tip});

  final P2PGuideTipDraft tip;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tip.toneKey);
    return VitCard(
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pGuideSafetyTipPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _guideIcon(tip.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tip.title, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  tip.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.35,
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
