part of '../phone/pages/cross_module_analytics_page.dart';

class _ArenaAnalyticsDisclosure extends StatelessWidget {
  const _ArenaAnalyticsDisclosure();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.bolt_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Open Arena metrics are not included in financial analytics as Arena uses points-only system. See Arena leaderboard for trust and performance metrics.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: CrossModuleSpacingTokens.crossModuleLineHeightBody,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsInfoCard extends StatelessWidget {
  const _AnalyticsInfoCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Metrics calculated independently per module. Cross-module comparison helps identify best strategies.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: CrossModuleSpacingTokens.crossModuleLineHeightBody,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
