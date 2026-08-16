part of '../../phone/pages/flow/copy_confirmation_page.dart';

class _CoolingOffCard extends StatelessWidget {
  const _CoolingOffCard({required this.hours});

  final int hours;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: _confirmationPrimary,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: _confirmationPrimary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Sau khi xác nhận, bạn có $hours giờ cooling-off để review lại quyết định trước khi copy chính thức kích hoạt.',
              style: AppTextStyles.caption.copyWith(
                color: _confirmationPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextStepsCard extends StatelessWidget {
  const _NextStepsCard({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Khóa vốn \$${snapshot.configuration.copyCapital.toStringAsFixed(0)} trong tài khoản copy',
      '${snapshot.coolingOffHours}h cooling-off period',
      'Copy tự động bắt đầu sao chép lệnh của provider',
      'Theo dõi real-time P/L và dừng copy bất cứ lúc nào',
    ];
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Điều gì xảy ra tiếp theo?',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (var index = 0; index < steps.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: AppSpacing.x3,
                  backgroundColor: _confirmationPrimary.withValues(alpha: .16),
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: _confirmationPrimary,
                      fontWeight: AppTextStyles.extraBold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    steps[index],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ],
            ),
            if (index != steps.length - 1)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

String _copyModeLabel(TradeCopyConfigurationMode mode) {
  return switch (mode) {
    TradeCopyConfigurationMode.mirror => 'Mirror Copy',
    TradeCopyConfigurationMode.fixed => 'Fixed 50%',
    TradeCopyConfigurationMode.smart => 'Smart Copy',
  };
}

String _riskLabel(TradeCopyRiskLevel risk) {
  return switch (risk) {
    TradeCopyRiskLevel.low => 'Low',
    TradeCopyRiskLevel.medium => 'Medium',
    TradeCopyRiskLevel.high => 'High',
  };
}
