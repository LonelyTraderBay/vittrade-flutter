part of '../../phone/pages/tools/launchpad_limit_orders_page.dart';

class _OrderPreview extends StatelessWidget {
  const _OrderPreview({
    required this.side,
    required this.token,
    required this.targetPrice,
    required this.amount,
    required this.expiryDays,
    required this.partialFill,
  });

  final LaunchpadLimitOrderSide side;
  final String token;
  final String targetPrice;
  final String amount;
  final String expiryDays;
  final bool partialFill;

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(targetPrice) ?? 0;
    final size = double.tryParse(amount) ?? 0;
    final sideLabel = side == LaunchpadLimitOrderSide.buy ? 'BUY' : 'SELL';
    return DecoratedBox(
      key: LaunchpadLimitOrdersPage.previewKey,
      decoration: ShapeDecoration(
        color: AppColors.primary.withValues(alpha: .10),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: AppColors.primary20),
          borderRadius: AppRadii.cardRadius,
        ),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadPaddingX4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Preview',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Row(
              children: [
                _PreviewMetric(label: 'Type', value: '$sideLabel $token'),
                _PreviewMetric(
                  label: 'Total Value',
                  value: '\$${(price * size).toStringAsFixed(2)}',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Row(
              children: [
                _PreviewMetric(label: 'Expires', value: '$expiryDays days'),
                _PreviewMetric(
                  label: 'Partial',
                  value: partialFill ? 'Yes' : 'No',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return const VitCard(
      child: VitEmptyState(
        title: 'No active orders',
        message: 'Create a limit order to get started',
        icon: Icons.schedule_rounded,
      ),
    );
  }
}
