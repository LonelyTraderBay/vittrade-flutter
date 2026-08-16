part of '../../phone/pages/security/p2p_security_center_page.dart';

class _WhitelistAction extends StatelessWidget {
  const _WhitelistAction({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: _p2pSecurityCompactPadding,
      onTap: onTap,
      child: Row(
        children: [
          _IconBadge(icon: icon, color: AppModuleAccents.p2p),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: _p2pSecurityCompactLine,
                  ),
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

class _SecurityScoreCard extends StatelessWidget {
  const _SecurityScoreCard({required this.snapshot});

  final P2PSecurityCenterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.score / snapshot.maxScore;

    return VitCard(
      key: P2PSecurityCenterPage.scoreKey,
      radius: VitCardRadius.large,
      padding: _p2pSecurityCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Điểm bảo mật',
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      snapshot.scoreSubtitle,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                label: snapshot.scoreLabel,
                color: AppColors.buy,
                prominent: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Center(
            child: SizedBox(
              width: _p2pSecurityScoreBox,
              height: _p2pSecurityScoreBox,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.square(
                    dimension: _p2pSecurityScoreTrack,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth:
                          P2PSpacingTokens.p2pSecurityCenterScoreStroke,
                      strokeCap: StrokeCap.round,
                      backgroundColor: AppColors.surface2,
                      color: AppColors.buy,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${snapshot.score}',
                        style: AppTextStyles.heroNumber.copyWith(
                          color: AppColors.buy,
                          height: _p2pSecurityNumberLine,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        '/ ${snapshot.maxScore}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Material(
            type: MaterialType.transparency,
            color: AppColors.buy10,
            borderRadius: AppRadii.mdRadius,
            child: Padding(
              padding: P2PSpacingTokens.p2pSecurityCenterNoticePadding,
              child: Text(
                snapshot.scoreBody,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: _p2pSecurityBodyLine,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityFeatures extends StatelessWidget {
  const _SecurityFeatures({required this.features, required this.onOpen});

  final List<P2PSecurityFeatureDraft> features;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSecurityCenterPage.featuresKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Tính năng bảo mật',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
        ),
        VitCard(
          radius: VitCardRadius.large,
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              for (var index = 0; index < features.length; index++) ...[
                _SecurityFeatureRow(
                  feature: features[index],
                  onTap: () => onOpen(features[index].route),
                ),
                if (index != features.length - 1)
                  const Divider(
                    height: _p2pSecurityDividerExtent,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SecurityFeatureRow extends StatelessWidget {
  const _SecurityFeatureRow({required this.feature, required this.onTap});

  final P2PSecurityFeatureDraft feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(feature.status);

    return VitCard(
      key: P2PSecurityCenterPage.featureKey(feature.id),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: AppSpacing.zeroInsets,
      child: Padding(
        padding: _p2pSecurityCompactPadding,
        child: Row(
          children: [
            _IconBadge(icon: _featureIcon(feature.iconKey), color: color),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.label,
                    style: AppTextStyles.baseMedium.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _statusLabel(feature.status),
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: color,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (feature.scoreDelta > 0) ...[
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          '+ ${feature.scoreDelta} điểm',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ],
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
      ),
    );
  }
}
