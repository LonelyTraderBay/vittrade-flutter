part of '../../pages/tablet/trade_tablet_order_receipt_page.dart';

class _RiskBox extends StatelessWidget {
  const _RiskBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      borderColor: color.withValues(alpha: .22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.badge.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.control.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeTabletWarningNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      borderColor: AppColors.warn.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Lệnh có thể bị khớp 1 phần hoặc hủy nếu giá thay đổi nhanh. '
              'Kiểm tra trạng thái tại Lệnh đang mở.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSupportLink extends StatelessWidget {
  const _OrderSupportLink({required this.supportRoute});

  final String supportRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TradeTabletOrderReceiptPage.supportKey,
      onTap: () => context.go(supportRoute),
      radius: VitCardRadius.tight,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      borderColor: AppColors.primary.withValues(alpha: .18),
      child: Row(
        children: [
          const Icon(
            Icons.support_agent_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Cần hỗ trợ lệnh này?',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            'Mở hồ sơ',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x1),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}
