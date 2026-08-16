part of '../phone/pages/referral_rules_page.dart';

class _TermsList extends StatelessWidget {
  const _TermsList({required this.snapshot});

  final ReferralRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRulesPage.termsKey,
      padding: ReferralSpacingTokens.referralCardPadding,
      child: Column(
        children: [
          for (var i = 0; i < snapshot.terms.length; i++) ...[
            Row(
              key: ReferralRulesPage.termKey(i),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox.square(
                  dimension: AppSpacing.x5,
                  child: DecoratedBox(
                    decoration: const ShapeDecoration(
                      color: AppColors.surface2,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.xlRadius,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                          height: ReferralSpacingTokens.referralLineHeightTight,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    snapshot.terms[i],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ],
            ),
            if (i < snapshot.terms.length - 1)
              const SizedBox(height: AppSpacing.rowGap),
          ],
        ],
      ),
    );
  }
}

class _FaqList extends StatelessWidget {
  const _FaqList({
    required this.snapshot,
    required this.openIndex,
    required this.onToggle,
  });

  final ReferralRulesSnapshot snapshot;
  final int? openIndex;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ReferralRulesPage.faqKey,
      children: [
        for (var index = 0; index < snapshot.faqs.length; index++) ...[
          KeyedSubtree(
            key: ReferralRulesPage.faqToggleKey(index),
            child: VitFaqAccordion(
              question: snapshot.faqs[index].question,
              answer: snapshot.faqs[index].answer,
              expanded: openIndex == index,
              onTap: () => onToggle(index),
              accentColor: AppColors.accent,
            ),
          ),
          if (index < snapshot.faqs.length - 1)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.snapshot});

  final ReferralRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitBanner(
      key: ReferralRulesPage.disclaimerKey,
      variant: VitBannerVariant.warning,
      icon: Icons.info_outline_rounded,
      message: 'Lưu ý chương trình',
      detail: snapshot.disclaimer,
    );
  }
}

String _formatUsd(double value) => VitFormat.usd(value);
