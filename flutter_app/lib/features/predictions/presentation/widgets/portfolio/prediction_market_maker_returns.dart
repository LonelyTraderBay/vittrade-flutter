part of '../../phone/pages/portfolio/prediction_market_maker_page.dart';

class _EstimatedReturns extends StatelessWidget {
  const _EstimatedReturns({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      density: VitDensity.compact,
      child: Row(
        children: [
          Expanded(
            child: _OverviewMetric(
              label: 'Daily Fees',
              value: _formatMoney(amount * .0012),
              valueColor: AppColors.buy,
              small: true,
            ),
          ),
          const Expanded(
            child: _OverviewMetric(
              label: 'Est. APR',
              value: '~22.5%',
              valueColor: AppColors.buy,
              small: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddLiquidityButton extends StatelessWidget {
  const _AddLiquidityButton({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: PredictionMarketMakerPage.addLiquidityKey,
      // ERR-36: handler thật thay no-op — flow thanh khoản đầy đủ chưa mở,
      // thông báo minh bạch theo pattern coming-soon sẵn có của feature.
      onPressed: enabled
          ? () {
              unawaited(
                showVitNoticeSheet(
                  context: context,
                  title: 'Sắp ra mắt',
                  message: 'Thêm thanh khoản sẽ sớm ra mắt.',
                ),
              );
            }
          : null,
      density: VitDensity.compact,
      leading: const Icon(Icons.add_rounded),
      child: const Text('Them thanh khoan'),
    );
  }
}

class _LiquidityWarning extends StatelessWidget {
  const _LiquidityWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: PredictionsSpacingTokens.predictionMarketMakerWarningIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Cung cap thanh khoan co rui ro impermanent loss. APR khong co dinh va phu thuoc vao volume giao dich. Khong dam bao loi nhuan.',
              style: AppTextStyles.numericMicro.copyWith(
                color: AppColors.text2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
