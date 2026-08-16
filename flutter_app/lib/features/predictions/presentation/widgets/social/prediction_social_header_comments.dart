part of '../../phone/pages/social/prediction_social_page.dart';

class _SocialTabBar extends StatelessWidget {
  const _SocialTabBar({required this.activeTab, required this.onChanged});

  final _SocialTab activeTab;
  final ValueChanged<_SocialTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return PredictionEnumTabBar<_SocialTab>(
      activeTab: activeTab,
      onChanged: onChanged,
      items: const [
        (PredictionSocialPage.commentsTabKey, _SocialTab.comments, 'Binh luan'),
        (PredictionSocialPage.analysisTabKey, _SocialTab.analysis, 'Phan tich'),
        (PredictionSocialPage.shareTabKey, _SocialTab.share, 'Chia se'),
      ],
    );
  }
}

class _EventInfoCard extends StatelessWidget {
  const _EventInfoCard({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.eventTitle,
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              const Icon(
                Icons.mode_comment_outlined,
                color: AppColors.text3,
                size: PredictionsSpacingTokens.predictionSocialEventIcon,
              ),
              const SizedBox(
                width: PredictionsSpacingTokens.predictionSocialEventCommentGap,
              ),
              Text(
                '${snapshot.totalComments} comments',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(
                width: PredictionsSpacingTokens.predictionSocialEventMetricGap,
              ),
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.buy,
                size: PredictionsSpacingTokens.predictionSocialEventIcon,
              ),
              const SizedBox(
                width: PredictionsSpacingTokens.predictionSocialEventBullishGap,
              ),
              Text(
                '${snapshot.bullishPercent}% Bullish',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NewCommentCard extends StatelessWidget {
  const _NewCommentCard({
    required this.controller,
    required this.selectedStance,
    required this.onStanceChanged,
  });

  final TextEditingController controller;
  final PredictionSocialStance selectedStance;
  final ValueChanged<PredictionSocialStance> onStanceChanged;

  @override
  Widget build(BuildContext context) {
    final hasComment = controller.text.trim().isNotEmpty;
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Them binh luan',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              for (final stance in PredictionSocialStance.values) ...[
                Expanded(
                  child: _StanceButton(
                    stance: stance,
                    selected: selectedStance == stance,
                    onTap: () => onStanceChanged(stance),
                  ),
                ),
                if (stance != PredictionSocialStance.neutral)
                  const SizedBox(
                    width: PredictionsSpacingTokens.predictionSocialStanceGap,
                  ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitInput(
            fieldKey: PredictionSocialPage.commentFieldKey,
            controller: controller,
            semanticLabel: 'Bình luận dự đoán',
            hintText: 'Chia se y kien cua ban...',
            textStyle: AppTextStyles.body,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCtaButton(
            density: VitDensity.compact,
            // ERR-36: handler thật thay no-op — đăng bình luận cần backend,
            // thông báo minh bạch theo pattern coming-soon sẵn có.
            onPressed: hasComment
                ? () {
                    unawaited(
                      showVitNoticeSheet(
                        context: context,
                        title: 'Sắp ra mắt',
                        message: 'Bình luận sẽ sớm ra mắt.',
                      ),
                    );
                  }
                : null,
            leading: const Icon(Icons.send_outlined),
            child: const Text('Dang binh luan'),
          ),
        ],
      ),
    );
  }
}

class _StanceButton extends StatelessWidget {
  const _StanceButton({
    required this.stance,
    required this.selected,
    required this.onTap,
  });

  final PredictionSocialStance stance;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _stanceColor(stance);
    return VitChoicePill(
      label: _stanceLabel(stance).toUpperCase(),
      selected: selected,
      onTap: onTap,
      accentColor: color,
      fullWidth: true,
      height: VitDensity.compact.controlHeight,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x2),
    );
  }
}
