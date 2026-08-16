part of '../../phone/pages/hub/launchpad_page.dart';

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.activeCount});

  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      key: LaunchpadPage.heroKey,
      accentColor: AppModuleAccents.launchpad,
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: AppSpacing.x7,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppModuleAccents.launchpad.withValues(alpha: .12),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.lgRadius,
                      side: BorderSide(
                        color: AppModuleAccents.launchpad.withValues(
                          alpha: .28,
                        ),
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.rocket_launch_outlined,
                    color: AppModuleAccents.launchpad,
                    size: AppSpacing.iconLg,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khám phá dự án token mới',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.extraBold,
                      ),
                    ),
                    Text(
                      '$activeCount dự án đang diễn ra',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Hiệu suất quá khứ không đảm bảo kết quả tương lai. Nghiên cứu kỹ trước khi tham gia.',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              height: _launchpadLineHeightDense,
            ),
          ),
        ],
      ),
    );
  }
}
