part of '../../phone/pages/bridge/launchpad_bridge_order_page.dart';

class _BridgeStatusHero extends StatelessWidget {
  const _BridgeStatusHero({required this.order});

  final LaunchpadBridgeOrderDraft order;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order.status);
    return VitCard(
      key: LaunchpadBridgeOrderPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
      padding: LaunchpadSpacingTokens.launchpadPaddingX5,
      child: Column(
        children: [
          SizedBox(
            width: LaunchpadSpacingTokens.launchpadBox64,
            height: LaunchpadSpacingTokens.launchpadBox64,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: color.withValues(alpha: .14),
                shape: const CircleBorder(),
              ),
              child: Icon(
                _statusIcon(order.status),
                color: color,
                size: LaunchpadSpacingTokens.launchpadBox30,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          Text(
            _heroTitle(order.status),
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '${order.sourceChain} -> ${order.targetChain}',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AmountColumn(
                label: 'Bán',
                value: _formatUsd(order.inputAmount),
                token: order.inputToken,
              ),
              const SizedBox(width: AppSpacing.x3),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              _AmountColumn(
                label: 'Nhận',
                value: _formatNumber(order.expectedOutput),
                token: order.outputToken,
                color: AppColors.buy,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          DecoratedBox(
            decoration: ShapeDecoration(
              color: AppColors.surface3.withValues(alpha: .72),
              shape: const StadiumBorder(),
            ),
            child: Padding(
              padding: LaunchpadSpacingTokens.launchpadPillPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: AppColors.text2,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'ETA ~${order.etaSeconds}s',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Poll #${order.pollCount}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountColumn extends StatelessWidget {
  const _AmountColumn({
    required this.label,
    required this.value,
    required this.token,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final String token;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          token,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}
