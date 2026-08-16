part of '../../phone/pages/hub/launchpad_page.dart';

class _StakingEntry extends StatelessWidget {
  const _StakingEntry({required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadPage.stakingKey,
      radius: VitCardRadius.standard,
      borderColor: AppColors.buy20,
      onTap: () => context.go(route),
      padding: VitDensity.compact.cardPadding,
      child: Row(
        children: [
          const SizedBox.square(
            dimension: LaunchpadSpacingTokens.launchpadBox48,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.buy10,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
              ),
              child: Icon(
                Icons.savings_outlined,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Launchpool Staking',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Stake token để nhận phần thưởng dự án mới',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _ToolSection extends StatelessWidget {
  const _ToolSection({super.key, required this.title, required this.tools});

  final String title;
  final List<LaunchpadToolDraft> tools;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: title,
      accentColor: AppModuleAccents.launchpad,
      density: VitDensity.compact,
      children: [
        GridView.count(
          crossAxisCount: LaunchpadSpacingTokens.launchpadGridColumns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.x3,
          crossAxisSpacing: AppSpacing.x3,
          childAspectRatio: LaunchpadSpacingTokens.launchpadGridAspectTile,
          padding: AppSpacing.zeroInsets,
          children: [
            for (final tool in tools)
              _ToolTile(key: LaunchpadPage.toolKey(tool.id), tool: tool),
          ],
        ),
      ],
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({super.key, required this.tool});

  final LaunchpadToolDraft tool;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      borderColor: tool.accent.resolve().withValues(alpha: .18),
      onTap: () => context.go(tool.route),
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: AppSpacing.x6,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: tool.accent.resolve().withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
              ),
              child: Icon(
                _toolIcon(tool.iconKey),
                color: tool.accent.resolve(),
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            tool.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: _launchpadLineHeightShort,
            ),
          ),
          Text(
            tool.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.chartLabelXs.copyWith(
              color: AppColors.text3,
              height: _launchpadLineHeightShort,
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyWarning extends StatelessWidget {
  const _SafetyWarning();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: LaunchpadPage.safetyKey,
      decoration: const ShapeDecoration(
        color: AppColors.sell10,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.sell20),
        ),
      ),
      child: Padding(
        padding: VitDensity.compact.cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.sell,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cảnh báo an toàn',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Chỉ tham gia qua app chính thức. Không gửi token cho bất kỳ ai yêu cầu. Kiểm tra contract address trước khi tương tác.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: _launchpadLineHeightReadable,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
