part of '../../phone/pages/client_money/investor_compensation_page.dart';

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      borderColor: _compAmber.withValues(alpha: .35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _compAmber,
            size: AppSpacing.statusPillIconSizeLg,
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _compAmber,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Eligibility extends StatelessWidget {
  const _Eligibility({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        VitPageSection(
          label: 'Who Is Eligible?',
          density: VitDensity.tool,
          children: [
            VitCard(
              density: VitDensity.tool,
              radius: VitCardRadius.tight,
              borderColor: _compBorder.withValues(alpha: .72),
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.none,
                fullBleed: true,
                density: VitDensity.tool,
                children: [
                  const _EligibilityHeading('Eligible Customers:'),
                  for (final item in snapshot.eligibleCustomers)
                    _Bullet(text: item, color: _compGreen),
                  const _EligibilityHeading('Not Eligible:'),
                  for (final item in snapshot.ineligibleCustomers)
                    _Bullet(text: item, color: _compRed),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ClaimGuide extends StatelessWidget {
  const _ClaimGuide({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        VitPageSection(
          label: 'How to Make a Claim',
          density: VitDensity.tool,
          children: [
            for (final step in snapshot.claimSteps) _ClaimStep(step: step),
          ],
        ),
        VitCtaButton(
          density: VitDensity.tool,
          onPressed: () =>
              _showComingSoon(context, 'Mở trang FSCS sẽ sớm ra mắt'),
          leading: const Icon(Icons.open_in_new_rounded),
          child: const Text('Visit FSCS Website'),
        ),
      ],
    );
  }
}

class _ClaimStep extends StatelessWidget {
  const _ClaimStep({required this.step});

  final TradeInvestorCompensationClaimStep step;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _compBorder.withValues(alpha: .72),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            borderColor: _compPrimary.withValues(alpha: .24),
            alignment: Alignment.center,
            child: Text(
              '${step.step}',
              style: AppTextStyles.baseMedium.copyWith(color: _compPrimary),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  step.description,
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

class _EligibilityHeading extends StatelessWidget {
  const _EligibilityHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          color == _compGreen
              ? Icons.check_circle_outline
              : Icons.error_outline_rounded,
          color: color,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _FaqButton extends StatelessWidget {
  const _FaqButton();

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: InvestorCompensationPage.faqKey,
      density: VitDensity.tool,
      variant: VitCtaButtonVariant.secondary,
      onPressed: () =>
          _showComingSoon(context, 'Câu hỏi thường gặp FSCS sẽ sớm ra mắt'),
      leading: const Icon(Icons.help_outline_rounded),
      trailing: const Icon(Icons.chevron_right_rounded),
      child: const Text('FSCS FAQs'),
    );
  }
}

void _showComingSoon(BuildContext context, String message) {
  unawaited(HapticFeedback.selectionClick());
  unawaited(
    showVitNoticeSheet(
      context: context,
      title: 'Sắp ra mắt',
      message: message,
      variant: VitBannerVariant.info,
    ),
  );
}
