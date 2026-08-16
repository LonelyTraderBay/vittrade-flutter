part of '../../phone/pages/event/prediction_event_detail_page.dart';

class _RiskLink extends StatelessWidget {
  const _RiskLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionEventDetailPage.riskLinkKey,
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      child: SizedBox(
        height: VitDensity.compact.controlHeight,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.warn,
                size: PredictionsSpacingTokens.predictionDetailRiskIcon,
              ),
              const SizedBox(
                width: PredictionsSpacingTokens.predictionDetailRiskIconGap,
              ),
              Flexible(
                child: Text(
                  'Hiểu rủi ro trước khi giao dịch',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(
                width: PredictionsSpacingTokens.predictionDetailRiskChevronGap,
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.warn,
                size: PredictionsSpacingTokens.predictionDetailRiskChevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
