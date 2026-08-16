part of '../../phone/pages/hub/copy_trading_card_demo.dart';

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      radius: VitCardRadius.large,
      padding: TradeSpacingTokens.tradeBotCopyDemoPanelPadding,
      borderColor: borderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: TradeSpacingTokens.tradeBotClientMoneyDocumentGlyph,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: iconColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          ...children,
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.score,
    required this.status,
    this.selected = false,
  });

  final String label;
  final int score;
  final TradeCopyCardCompliance status;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Expanded(
      child: VitCard(
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        padding: TradeSpacingTokens.tradeBotCopyDemoCompactPadding,
        borderColor: selected ? color : null,
        background: ColoredBox(color: _statusTintColor(status)),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              '$score',
              style: AppTextStyles.sectionTitle.copyWith(color: color),
            ),
            Text(
              '/100',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text2,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _ComplianceIcon extends StatelessWidget {
  const _ComplianceIcon({required this.status});

  final TradeCopyCardCompliance status;

  @override
  Widget build(BuildContext context) {
    final icon = switch (status) {
      TradeCopyCardCompliance.pass => Icons.check_circle_outline_rounded,
      TradeCopyCardCompliance.warn => Icons.error_outline_rounded,
      TradeCopyCardCompliance.fail => Icons.cancel_outlined,
    };
    return Center(
      child: Icon(
        icon,
        color: _statusColor(status),
        size: TradeSpacingTokens.tradeBotMediumIcon,
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.status, required this.label});

  final TradeCopyCardCompliance status;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ComplianceIcon(status: status),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text, this.compact = false});

  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: compact
          ? TradeSpacingTokens.tradeBotCopyDemoCompactLinePadding
          : TradeSpacingTokens.tradeBotCopyDemoLinePadding,
      child: Text(
        '- $text',
        style: AppTextStyles.caption.copyWith(color: AppColors.text2),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TradeSpacingTokens.tradeBotCopyDemoLinePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.buy,
            size:
                TradeSpacingTokens.tradeBotSmallIcon +
                AppSpacing.hairlineStroke,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(TradeCopyCardCompliance status) {
  return switch (status) {
    TradeCopyCardCompliance.pass => AppColors.buy,
    TradeCopyCardCompliance.warn => AppColors.warn,
    TradeCopyCardCompliance.fail => AppColors.sell,
  };
}

Color _statusTintColor(TradeCopyCardCompliance status) {
  return switch (status) {
    TradeCopyCardCompliance.pass => AppColors.buy15,
    TradeCopyCardCompliance.warn => AppColors.warn15,
    TradeCopyCardCompliance.fail => AppColors.sell15,
  };
}
