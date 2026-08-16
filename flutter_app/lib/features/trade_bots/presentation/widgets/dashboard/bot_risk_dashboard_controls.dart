part of '../../phone/pages/dashboard/bot_risk_dashboard_page.dart';

class _SafetyControlsCard extends StatelessWidget {
  const _SafetyControlsCard({required this.controls});

  final List<TradeBotSafetyControl> controls;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      density: VitDensity.tool,
      child: Column(
        children: [
          Row(
            children: [
              const VitAccentIconBox(
                icon: Icons.security_rounded,
                color: _riskGreen,
              ),
              const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ngắt mạch tự động',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
                    Text(
                      'Tự động dừng khi vượt giới hạn',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const VitStatusPill(
                label: 'Đang bật',
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final control in controls) ...[
            VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.tight,
              padding: TradeSpacingTokens.tradeBotMetricBoxPadding,
              density: VitDensity.tool,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      control.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    control.value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
                  const VitStatusPill(
                    label: 'OK',
                    status: VitStatusPillStatus.success,
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
            ),
            if (control != controls.last)
              const SizedBox(height: TradeSpacingTokens.tradeBotCardGap),
          ],
        ],
      ),
    );
  }
}

class _EmergencyActionCard extends StatelessWidget {
  const _EmergencyActionCard({required this.runningBots, required this.onTap});

  final int runningBots;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.tight,
          padding: TradeSpacingTokens.tradeBotCompactCardPadding,
          density: VitDensity.tool,
          borderColor: _riskRed.withValues(alpha: .4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: _riskRed,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: TradeSpacingTokens.tradeBotCardGap),
              Expanded(
                child: Text(
                  'Dừng ngay lập tức tất cả $runningBots bot đang chạy. Chỉ dùng khi thị trường sập hoặc sự cố kỹ thuật.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCtaButton(
          key: BotRiskDashboardPage.emergencyButtonKey,
          density: VitDensity.tool,
          height: TradeSpacingTokens.tradeBotSheetActionHeight,
          variant: VitCtaButtonVariant.danger,
          onPressed: onTap,
          leading: const Icon(Icons.stop_circle_outlined),
          trailing: const Icon(Icons.chevron_right_rounded),
          child: const Text('Dừng khẩn cấp tất cả bot'),
        ),
      ],
    );
  }
}

class _RiskExplanationCard extends StatelessWidget {
  const _RiskExplanationCard({required this.expanded, required this.onToggle});

  final bool expanded;
  final VoidCallback onToggle;

  static const _items = [
    'Sụt giảm vốn hiện tại (30%)',
    'Lỗ trong ngày so với giới hạn (25%)',
    'Mức phơi nhiễm danh mục (20%)',
    'Xu hướng VaR (15%)',
    'Đa dạng hóa (10%)',
  ];

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: AppRadii.smRadius,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Cách tính điểm rủi ro',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            for (final item in _items) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(0, AppSpacing.x2),
                    child: const DecoratedBox(
                      decoration: ShapeDecoration(
                        color: AppColors.text3,
                        shape: CircleBorder(),
                      ),
                      child: SizedBox(
                        width: AppSpacing.x2,
                        height: AppSpacing.x2,
                      ),
                    ),
                  ),
                  const SizedBox(width: TradeSpacingTokens.tradeBotCardGap),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
              if (item != _items.last)
                const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
            ],
          ],
        ],
      ),
    );
  }
}
