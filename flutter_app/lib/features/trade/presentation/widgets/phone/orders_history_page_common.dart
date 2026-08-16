part of '../../phone/pages/hub/orders_history_page.dart';

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final TradeOrderType type;

  @override
  Widget build(BuildContext context) {
    final label = switch (type) {
      TradeOrderType.market => 'Market',
      TradeOrderType.limit => 'Limit',
      TradeOrderType.stop => 'Stop',
    };
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: AppSpacing.buttonCompact),
      child: VitAccentPill(label: label, accentColor: AppColors.text2),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.activeTab});

  final String activeTab;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      density: VitDensity.tool,
      icon: Icons.access_time_rounded,
      title: activeTab == 'open'
          ? 'Không có lệnh đang mở'
          : 'Chưa có lịch sử giao dịch',
      secondaryMessage: activeTab == 'open'
          ? 'Giá thị trường có thể thay đổi trước khi lệnh khớp.'
          : null,
    );
  }
}

({String label, Color color, IconData icon}) _statusPresentation(
  TradeOrderStatus status,
) {
  return switch (status) {
    TradeOrderStatus.open => (
      label: 'Đang mở',
      color: _tradePrimary,
      icon: Icons.access_time_rounded,
    ),
    TradeOrderStatus.partial => (
      label: 'Khớp 1 phần',
      color: AppColors.warn,
      icon: Icons.trending_up_rounded,
    ),
    TradeOrderStatus.filled => (
      label: 'Đã khớp',
      color: AppColors.buy,
      icon: Icons.check_circle_rounded,
    ),
    TradeOrderStatus.cancelled => (
      label: 'Đã hủy',
      color: AppColors.text3,
      icon: Icons.cancel_rounded,
    ),
  };
}

String _formatMoney(double value) =>
    VitFormat.usd(value).replaceFirst('\$', '');
