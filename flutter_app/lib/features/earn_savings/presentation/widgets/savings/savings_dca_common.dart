part of '../../phone/pages/savings/savings_dca_page.dart';

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: asset,
      accentColor: color,
      size: AppSpacing.x6,
      radius: AppRadii.mdRadius,
      border: true,
      maxChars: 3,
      fillAlpha: .12,
      borderAlpha: .35,
      textStyle: _microBold.copyWith(color: color),
    );
  }
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' || 'USD' => AppColors.buy,
    'ETH' => AppColors.accent,
    'SOL' => AppColors.warn,
    _ => AppColors.primary,
  };
}

Color _executionColor(SavingsDcaExecutionStatus status) {
  return switch (status) {
    SavingsDcaExecutionStatus.success => AppColors.buy,
    SavingsDcaExecutionStatus.failed => AppColors.sell,
    SavingsDcaExecutionStatus.pending => AppColors.warn,
  };
}

IconData _executionIcon(SavingsDcaExecutionStatus status) {
  return switch (status) {
    SavingsDcaExecutionStatus.success => Icons.check_circle_outline_rounded,
    SavingsDcaExecutionStatus.failed => Icons.error_outline_rounded,
    SavingsDcaExecutionStatus.pending => Icons.schedule_rounded,
  };
}

String _executionLabel(SavingsDcaExecutionStatus status) {
  return switch (status) {
    SavingsDcaExecutionStatus.success => 'Thành công',
    SavingsDcaExecutionStatus.failed => 'Thất bại',
    SavingsDcaExecutionStatus.pending => 'Đang xử lý',
  };
}
