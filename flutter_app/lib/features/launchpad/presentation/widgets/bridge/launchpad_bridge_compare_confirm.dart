part of '../../phone/pages/bridge/launchpad_bridge_compare_page.dart';

class _RiskDisclosure extends StatelessWidget {
  const _RiskDisclosure();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: LaunchpadBridgeComparePage.riskKey,
      decoration: const ShapeDecoration(
        color: AppColors.warn08,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.lgRadius,
          side: BorderSide(color: AppColors.warningBorder),
        ),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadPaddingX4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                'Lưu ý rủi ro đầu tư',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedRouteFooter extends StatelessWidget {
  const _SelectedRouteFooter({
    required this.route,
    required this.outputToken,
    required this.onConfirm,
  });

  final LaunchpadBridgeRouteOptionDraft route;
  final String outputToken;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return VitStickyFooter(
      key: LaunchpadBridgeComparePage.footerKey,
      backgroundColor: AppColors.surface.withValues(alpha: .94),
      child: Column(
        children: [
          Row(
            children: [
              _ProviderBadge(
                label: route.providerIcon,
                accent: route.accent.resolve(),
                size: LaunchpadSpacingTokens.launchpadIcon7xl,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.provider,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '${_formatNumber(route.outputAmount)} $outputToken · ${route.totalFeeUsd} fee · ${route.estimatedTime}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            onPressed: onConfirm,
            child: const Text('Chọn route này'),
          ),
        ],
      ),
    );
  }
}
