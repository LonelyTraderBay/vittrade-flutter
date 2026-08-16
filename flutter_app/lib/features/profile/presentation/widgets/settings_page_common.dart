part of '../phone/pages/settings_page.dart';

class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard({required this.rows});

  final List<ProfileInfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SettingsPage.appInfoKey,
      density: VitDensity.compact,
      radius: VitCardRadius.large,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'TH\u00D4NG TIN \u1EE8NG D\u1EE4NG',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final row in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                const SizedBox(
                  width: ProfileSpacingTokens.settingsAppInfoValueGap,
                ),
                Text(
                  row.value,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ],
            ),
            if (row != rows.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}
