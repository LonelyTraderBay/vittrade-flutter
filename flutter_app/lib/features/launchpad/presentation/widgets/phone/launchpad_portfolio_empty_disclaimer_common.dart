part of '../../phone/pages/hub/launchpad_portfolio_page.dart';

class _EmptyPortfolio extends StatelessWidget {
  const _EmptyPortfolio({
    required this.route,
    required this.filtered,
    required this.onShowAll,
  });

  final String route;
  final bool filtered;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      icon: Icons.business_center_outlined,
      title: filtered ? 'Không có dự án trong tab này' : 'Chưa có dự án nào',
      message: filtered
          ? 'Thử xem tất cả hoặc chọn tab khác.'
          : 'Bạn chưa tham gia dự án Launchpad nào. Khám phá ngay.',
      actionLabel: filtered ? 'Xem tất cả' : 'Khám phá Launchpad',
      onAction: filtered ? onShowAll : () => context.go(route),
    );
  }
}

class _PortfolioDisclaimer extends StatelessWidget {
  const _PortfolioDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Row(
      key: LaunchpadPortfolioPage.disclaimerKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: AppColors.text3,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            'Phân bổ thực tế phụ thuộc vào tổng số đăng ký. Token mở khóa theo lịch mở khóa của từng dự án.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: LaunchpadSpacingTokens.launchpadLineHeightShort,
            ),
          ),
        ),
      ],
    );
  }
}

enum _PortfolioTab {
  all('all', 'Tất cả'),
  pending('pending', 'Đang chờ'),
  allocated('allocated', 'Đã phân bổ'),
  claimed('claimed', 'Đã nhận');

  const _PortfolioTab(this.id, this.label);

  final String id;
  final String label;
}

final class _SubscriptionStatus {
  const _SubscriptionStatus({required this.label, required this.pillStatus});

  final String label;
  final VitStatusPillStatus pillStatus;
}

List<LaunchpadSubscriptionDraft> _subscriptionsFor(
  List<LaunchpadSubscriptionDraft> subscriptions,
  _PortfolioTab tab,
) {
  return switch (tab) {
    _PortfolioTab.all => subscriptions,
    _PortfolioTab.pending =>
      subscriptions
          .where(
            (subscription) =>
                subscription.status == LaunchpadSubscriptionStatus.pending,
          )
          .toList(),
    _PortfolioTab.allocated =>
      subscriptions
          .where(
            (subscription) =>
                subscription.status == LaunchpadSubscriptionStatus.allocated ||
                subscription.status ==
                    LaunchpadSubscriptionStatus.partiallyAllocated,
          )
          .toList(),
    _PortfolioTab.claimed =>
      subscriptions
          .where(
            (subscription) =>
                subscription.status == LaunchpadSubscriptionStatus.claimed ||
                subscription.status == LaunchpadSubscriptionStatus.refunded,
          )
          .toList(),
  };
}

_SubscriptionStatus _subscriptionStatus(LaunchpadSubscriptionStatus status) {
  return switch (status) {
    LaunchpadSubscriptionStatus.pending => const _SubscriptionStatus(
      label: 'Chờ phân bổ',
      pillStatus: VitStatusPillStatus.warning,
    ),
    LaunchpadSubscriptionStatus.allocated => const _SubscriptionStatus(
      label: 'Đã phân bổ',
      pillStatus: VitStatusPillStatus.success,
    ),
    LaunchpadSubscriptionStatus.partiallyAllocated => const _SubscriptionStatus(
      label: 'Phân bổ 1 phần',
      pillStatus: VitStatusPillStatus.info,
    ),
    LaunchpadSubscriptionStatus.claimed => const _SubscriptionStatus(
      label: 'Đã nhận',
      pillStatus: VitStatusPillStatus.success,
    ),
    LaunchpadSubscriptionStatus.refunded => const _SubscriptionStatus(
      label: 'Đã hoàn tiền',
      pillStatus: VitStatusPillStatus.neutral,
    ),
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  return '\$${_withCommas(fixed)}';
}

String _formatInt(int value) => _withCommas(value.toString());

String _withCommas(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts.last);
  }
  return buffer.toString();
}
