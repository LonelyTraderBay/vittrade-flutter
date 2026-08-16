part of '../../phone/pages/settings/bot_risk_disclosure_page.dart';

class _AcknowledgmentCard extends StatelessWidget {
  const _AcknowledgmentCard({
    required this.snapshot,
    required this.acknowledged,
    required this.onTap,
  });

  final TradeBotRiskDisclosureSnapshot snapshot;
  final bool acknowledged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: BotRiskDisclosurePage.acknowledgmentKey,
      onTap: onTap,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: acknowledged ? _botRiskRed : AppColors.borderSolid,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            acknowledged
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: acknowledged ? _botRiskRed : AppColors.text3,
            size: AppSpacing.x4,
          ),
          const SizedBox(width: _riskSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.acknowledgmentTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _riskTinySpace),
                Text(
                  snapshot.acknowledgmentDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: _riskLineTight,
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

class _RiskCta extends StatelessWidget {
  const _RiskCta({
    required this.snapshot,
    required this.acknowledged,
    required this.onPressed,
  });

  final TradeBotRiskDisclosureSnapshot snapshot;
  final bool acknowledged;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: BotRiskDisclosurePage.ctaKey,
      height: _riskActionHeight,
      density: VitDensity.tool,
      variant: VitCtaButtonVariant.danger,
      onPressed: acknowledged ? onPressed : null,
      child: Text(acknowledged ? snapshot.enabledCta : snapshot.disabledCta),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.helpTitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _riskTinySpace),
          Text(
            snapshot.helpDescription,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: _riskLineTight,
            ),
          ),
          const SizedBox(height: _riskSpace),
          Text(
            snapshot.helpCta,
            style: AppTextStyles.caption.copyWith(
              color: _botRiskPrimary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  const _BulletText(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('â€¢', style: AppTextStyles.caption.copyWith(color: color)),
        const SizedBox(width: _riskTinySpace),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: color,
              height: _riskLineTight,
            ),
          ),
        ),
      ],
    );
  }
}

Color _colorForKind(TradeBotRiskKind kind) {
  return switch (kind) {
    TradeBotRiskKind.market => _botRiskRed,
    TradeBotRiskKind.leverage => _botRiskAmber,
    TradeBotRiskKind.liquidity => _botRiskPurple,
    TradeBotRiskKind.technical => _botRiskRed,
    TradeBotRiskKind.timing => _botRiskPrimary,
    TradeBotRiskKind.regulatory => _botRiskGreen,
  };
}

IconData _iconForKind(TradeBotRiskKind kind) {
  return switch (kind) {
    TradeBotRiskKind.market => Icons.trending_down_rounded,
    TradeBotRiskKind.leverage => Icons.bolt_rounded,
    TradeBotRiskKind.liquidity => Icons.attach_money_rounded,
    TradeBotRiskKind.technical => Icons.warning_amber_rounded,
    TradeBotRiskKind.timing => Icons.schedule_rounded,
    TradeBotRiskKind.regulatory => Icons.shield_outlined,
  };
}
