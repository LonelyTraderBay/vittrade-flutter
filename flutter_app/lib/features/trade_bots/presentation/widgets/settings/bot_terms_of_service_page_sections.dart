part of '../../phone/pages/settings/bot_terms_of_service_page.dart';

class _TermsCard extends StatelessWidget {
  const _TermsCard({required this.snapshot, required this.controller});

  final TradeBotTermsSnapshot snapshot;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: _termsCardExtent,
      borderColor: AppColors.cardBorder,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: ClipRRect(
        borderRadius: AppRadii.smRadius,
        child: SingleChildScrollView(
          key: BotTermsOfServicePage.termsScrollKey,
          controller: controller,
          padding: TradeSpacingTokens.tradeBotTermsScrollPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.title,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  height: _termsLineShort,
                ),
              ),
              const SizedBox(height: _termsSpace),
              Text(
                snapshot.lastUpdatedLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: _termsLineTight,
                ),
              ),
              const SizedBox(height: _termsSpace),
              for (final section in snapshot.sections) ...[
                _TermsSection(section: section),
                if (section != snapshot.sections.last)
                  const SizedBox(height: _termsSpace),
              ],
              const Divider(
                color: AppColors.borderSolid,
                height: AppSpacing.x6,
              ),
              Center(
                child: Text(
                  '-- End of Terms --',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({required this.section});

  final TradeBotTermsSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            height: _termsLineShort,
          ),
        ),
        const SizedBox(height: _termsSpace),
        if (section.warningTitle != null && section.warningBody != null) ...[
          _CriticalWarning(section: section),
          const SizedBox(height: _termsSpace),
        ],
        for (final paragraph in section.paragraphs) ...[
          Text(
            paragraph,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              height: _termsLineLegal,
            ),
          ),
          if (paragraph != section.paragraphs.last)
            const SizedBox(height: _termsSpace),
        ],
        if (section.bullets.isNotEmpty) ...[
          const SizedBox(height: _termsSpace),
          for (final bullet in section.bullets)
            Padding(
              padding: TradeSpacingTokens.tradeBotTermsBulletPadding,
              child: Text(
                '- $bullet',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  height: _termsLineReadable,
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _CriticalWarning extends StatelessWidget {
  const _CriticalWarning({required this.section});

  final TradeBotTermsSection section;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: TradeSpacingTokens.tradeBotTermsWarningPadding,
      borderColor: _termsRed.withValues(alpha: .35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: TradeSpacingTokens.tradeBotIntroIconTopPadding,
            child: Icon(
              Icons.warning_amber_rounded,
              color: _termsRed,
              size: TradeSpacingTokens.tradeBotMediumIcon,
            ),
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotDisclosureGap),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.caption.copyWith(
                  color: _termsRed,
                  height: _termsLineReadable,
                ),
                children: [
                  TextSpan(
                    text: '${section.warningTitle} ',
                    style: AppTextStyles.caption.copyWith(
                      color: _termsRed,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(text: section.warningBody),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollWarning extends StatelessWidget {
  const _ScrollWarning({required this.snapshot});

  final TradeBotTermsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      constraints: const BoxConstraints(minHeight: _termsWarningMinExtent),
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      density: VitDensity.tool,
      borderColor: _termsAmber.withValues(alpha: .32),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _termsAmber,
            size: TradeSpacingTokens.tradeBotCheckboxIcon,
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotDisclosureGap),
          Expanded(
            child: Text(
              snapshot.scrollWarning,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: _termsLineBody,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgreementCard extends StatelessWidget {
  const _AgreementCard({
    required this.snapshot,
    required this.enabled,
    required this.agreed,
    required this.onTap,
  });

  final TradeBotTermsSnapshot snapshot;
  final bool enabled;
  final bool agreed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : .5,
      // card-tile: allow-start — fixed surface, not horizontal strip tile
      child: VitCard(
        key: BotTermsOfServicePage.agreementKey,
        onTap: enabled ? onTap : null,
        radius: VitCardRadius.tight,
        constraints: const BoxConstraints(minHeight: _termsAgreementMinExtent),
        padding: TradeSpacingTokens.tradeBotAgreementPadding,
        density: VitDensity.tool,
        variant: enabled ? VitCardVariant.inner : VitCardVariant.standard,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: TradeSpacingTokens.tradeBotAgreementIconMargin,
              child: Icon(
                agreed
                    ? Icons.check_circle_outline_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: agreed ? AppColors.primary : AppColors.borderSolid,
                size: TradeSpacingTokens.tradeBotCheckbox,
              ),
            ),
            const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.agreementTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: _termsLineBody,
                    ),
                  ),
                  const SizedBox(height: _termsTinySpace),
                  Text(
                    snapshot.agreementDescription,
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
      ),
    );
  }
}
