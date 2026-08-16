part of '../../phone/pages/settings/bot_terms_of_service_page.dart';

class _TermsCta extends StatelessWidget {
  const _TermsCta({
    required this.snapshot,
    required this.agreed,
    required this.onPressed,
  });

  final TradeBotTermsSnapshot snapshot;
  final bool agreed;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: BotTermsOfServicePage.ctaKey,
      height: TradeSpacingTokens.tradeBotControlCompact,
      density: VitDensity.tool,
      onPressed: agreed ? onPressed : null,
      child: Text(
        agreed ? snapshot.enabledCta : snapshot.disabledCta,
        style: AppTextStyles.body.copyWith(
          fontWeight: AppTextStyles.bold,
          height: _termsLineTight,
        ),
      ),
    );
  }
}

class _ComplianceNote extends StatelessWidget {
  const _ComplianceNote({required this.snapshot});

  final TradeBotTermsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      constraints: const BoxConstraints(minHeight: _termsComplianceMinExtent),
      padding: TradeSpacingTokens.tradeBotCardPaddingLoose,
      density: VitDensity.tool,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: TradeSpacingTokens.tradeBotIntroIconTopPadding,
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.text3,
              size: TradeSpacingTokens.tradeBotMediumIcon,
            ),
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.complianceTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: _termsLineCaption,
                  ),
                ),
                const SizedBox(height: _termsTinySpace),
                Text(
                  snapshot.complianceDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: _termsLineReadable,
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
