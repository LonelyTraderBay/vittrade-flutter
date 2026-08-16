part of '../../phone/pages/tools/risk_management_demo_page.dart';

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return const VitTradeComplianceHero(
      title: 'Risk Management Foundation',
      description:
          '3 công cụ quản lý rủi ro chuyên nghiệp giúp bảo vệ vốn và tối ưu '
          'hóa lợi nhuận. Đây là foundation quan trọng nhất cho enterprise '
          'trading platform.',
      icon: Icons.shield_rounded,
      accentColor: _riskPrimary,
      titleMaxLines: 2,
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature, required this.onTap});

  final TradeRiskFeature feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(feature.colorHex);
    return VitCard(
      key: RiskManagementDemoPage.featureKey(feature.id),
      onTap: onTap,
      padding: TradeSpacingTokens.tradeToolRiskIntroPadding,
      radius: VitCardRadius.tight,
      child: Row(
        children: [
          _IconTile(
            icon: _iconForFeature(feature),
            color: color,
            size: TradeSpacingTokens.tradeToolIconTileMd,
          ),
          const SizedBox(width: _riskCardSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  feature.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: _riskSpace),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }

  IconData _iconForFeature(TradeRiskFeature feature) {
    return switch (feature.id) {
      'positions' => Icons.check_circle_rounded,
      'calculator' => Icons.calculate_rounded,
      _ => Icons.trending_up_rounded,
    };
  }
}

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard();

  static const _benefits = [
    (
      Icons.track_changes_rounded,
      'Quản lý rủi ro tốt hơn',
      'Không bị over-leverage, bảo vệ tài khoản',
    ),
    (
      Icons.bar_chart_rounded,
      'Theo dõi P&L real-time',
      'Biết đang lời hay lỗ mọi lúc',
    ),
    (
      Icons.balance_rounded,
      'R:R ratio tối ưu',
      'Đảm bảo tiềm năng lời > rủi ro',
    ),
    (
      Icons.security_rounded,
      'Stop loss tự động',
      'OCO orders bảo vệ vị thế 24/7',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TradeSpacingTokens.tradeToolRiskIntroPadding,
      radius: VitCardRadius.tight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Lợi ích chính',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _riskSpace),
          for (final benefit in _benefits) ...[
            _BenefitItem(
              icon: benefit.$1,
              title: benefit.$2,
              description: benefit.$3,
            ),
            if (benefit != _benefits.last) const SizedBox(height: _riskSpace),
          ],
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: _riskPrimary,
          size: TradeSpacingTokens.tradeToolBodyIcon,
        ),
        const SizedBox(width: _riskSpace),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              const SizedBox(height: _riskTinySpace),
              Text(
                description,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.items});

  final List<TradeRiskStatusItem> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TradeSpacingTokens.tradeToolRiskIntroPadding,
      radius: VitCardRadius.tight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Implementation Status',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _riskSpace),
          for (final item in items) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                VitStatusPill(
                  label: item.complete ? 'Complete' : 'Pending',
                  icon: item.complete
                      ? Icons.check_rounded
                      : Icons.schedule_rounded,
                  status: item.complete
                      ? VitStatusPillStatus.success
                      : VitStatusPillStatus.warning,
                  size: VitStatusPillSize.sm,
                ),
              ],
            ),
            if (item != items.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}
