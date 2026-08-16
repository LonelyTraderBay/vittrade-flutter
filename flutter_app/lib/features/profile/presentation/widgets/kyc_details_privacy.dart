part of '../phone/pages/kyc_page.dart';

class _DetailsBlock extends StatelessWidget {
  const _DetailsBlock({
    required this.title,
    required this.lines,
    this.done = true,
  });

  final String title;
  final List<String> lines;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.badge.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final line in lines) ...[
          Row(
            children: [
              if (title.startsWith('T')) ...[
                Icon(
                  Icons.check_circle_rounded,
                  color: done ? _kycGreen : AppColors.text3,
                  size: ProfileSpacingTokens.kycDetailIcon,
                ),
                const SizedBox(width: ProfileSpacingTokens.kycDetailIconGap),
              ] else
                Text(
                  '\u2022 ',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text1),
                ),
              Expanded(
                child: Text(
                  line,
                  style: AppTextStyles.caption.copyWith(
                    color: done ? AppColors.text1 : AppColors.text3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
        ],
      ],
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: KYCPage.privacyCardKey,
      density: VitDensity.compact,
      borderColor: _kycPrimary.withValues(alpha: .24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _kycPrimary,
            size: ProfileSpacingTokens.kycPrivacyIcon,
          ),
          const SizedBox(width: ProfileSpacingTokens.kycPrivacyGapHorizontal),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'B\u1EA3o m\u1EADt th\u00F4ng tin c\u00E1 nh\u00E2n',
                  style: AppTextStyles.caption.copyWith(
                    color: _kycPrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Th\u00F4ng tin KYC \u0111\u01B0\u1EE3c m\u00E3 h\u00F3a AES-256. Ch\u00FAng t\u00F4i kh\u00F4ng chia\n'
                  's\u1EBB v\u1EDBi b\u00EAn th\u1EE9 ba.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
