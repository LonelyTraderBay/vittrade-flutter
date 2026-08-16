part of '../../phone/pages/social/prediction_social_page.dart';

class _CommentsSection extends StatelessWidget {
  const _CommentsSection({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: '${snapshot.totalComments} binh luan',
      accentColor: _predictionPrimary,
      density: VitDensity.compact,
      children: [
        for (final comment in snapshot.comments) _CommentCard(comment: comment),
      ],
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({required this.comment, this.reply = false});

  final PredictionSocialCommentDraft comment;
  final bool reply;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (reply)
          const SizedBox(
            width: PredictionsSpacingTokens.predictionSocialReplyIndent,
          ),
        Expanded(
          child: VitCard(
            borderColor: comment.isPinned
                ? AppColors.primary15
                : AppColors.border,
            density: VitDensity.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TierAvatar(tier: comment.userTier),
                    const SizedBox(
                      width: PredictionsSpacingTokens
                          .predictionSocialCommentHeaderGap,
                    ),
                    Expanded(child: _CommentUser(comment: comment)),
                    const Icon(
                      Icons.more_horiz_rounded,
                      color: AppColors.text3,
                      size: PredictionsSpacingTokens
                          .predictionSocialCommentMoreIcon,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  comment.content,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                _CommentActions(comment: comment, reply: reply),
                if (comment.replies.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  for (final child in comment.replies)
                    _CommentCard(comment: child, reply: true),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CommentUser extends StatelessWidget {
  const _CommentUser({required this.comment});

  final PredictionSocialCommentDraft comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: PredictionsSpacingTokens.predictionSocialUserBadgeGap,
          runSpacing: PredictionsSpacingTokens.predictionSocialUserBadgeRunGap,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              comment.userName,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
            _SmallBadge(
              label: _tierLabel(comment.userTier),
              color: _tierColor(comment.userTier),
            ),
            if (comment.isPinned)
              const _SmallBadge(label: 'PINNED', color: _predictionPrimary),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              color: AppColors.text3,
              size: PredictionsSpacingTokens.predictionSocialTimeIcon,
            ),
            const SizedBox(
              width: PredictionsSpacingTokens.predictionSocialTimeIconGap,
            ),
            Flexible(
              child: Text(
                comment.createdAtLabel,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            const SizedBox(
              width: PredictionsSpacingTokens.predictionSocialStanceBadgeGap,
            ),
            _SmallBadge(
              label: _stanceLabel(comment.stance).toUpperCase(),
              color: _stanceColor(comment.stance),
            ),
          ],
        ),
      ],
    );
  }
}

class _CommentActions extends StatelessWidget {
  const _CommentActions({required this.comment, required this.reply});

  final PredictionSocialCommentDraft comment;
  final bool reply;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionPill(
          icon: Icons.thumb_up_alt_outlined,
          label: '${comment.upvotes}',
          color: AppColors.buy,
        ),
        const SizedBox(
          width: PredictionsSpacingTokens.predictionSocialActionGap,
        ),
        _ActionPill(
          icon: Icons.thumb_down_alt_outlined,
          label: '${comment.downvotes}',
          color: AppColors.sell,
        ),
        if (!reply) ...[
          const SizedBox(
            width: PredictionsSpacingTokens.predictionSocialActionGap,
          ),
          const _ActionPill(
            icon: Icons.mode_comment_outlined,
            label: 'Tra loi',
          ),
        ],
        const SizedBox(
          width: PredictionsSpacingTokens.predictionSocialActionReportGap,
        ),
        const _ActionPill(
          icon: Icons.flag_outlined,
          label: 'Bao cao',
          flat: true,
        ),
      ],
    );
  }
}

class _TierAvatar extends StatelessWidget {
  const _TierAvatar({required this.tier});

  final PredictionSocialTier tier;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _tierColor(tier),
      shape: const CircleBorder(),
      child: const SizedBox.square(
        dimension: PredictionsSpacingTokens.predictionSocialAvatar,
        child: Icon(
          Icons.person_outline_rounded,
          color: AppColors.onAccent,
          size: PredictionsSpacingTokens.predictionSocialAvatarIcon,
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .16),
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionSocialSmallBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.label,
    this.color = AppColors.text3,
    this.flat = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool flat;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: flat ? AppColors.transparent : AppColors.bg,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionSocialActionPillPadding,
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: PredictionsSpacingTokens.predictionSocialActionIcon,
            ),
            const SizedBox(
              width: PredictionsSpacingTokens.predictionSocialActionIconGap,
            ),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: flat ? AppColors.text3 : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentDisclaimer extends StatelessWidget {
  const _CommentDisclaimer();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary15,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _predictionPrimary,
            size: PredictionsSpacingTokens.predictionSocialDisclosureIcon,
          ),
          const SizedBox(
            width: PredictionsSpacingTokens.predictionSocialDisclosureGap,
          ),
          Expanded(
            child: Text(
              'Y kien nguoi dung chi mang tinh tham khao. Khong phai loi khuyen dau tu. Tu chiu trach nhiem quyet dinh.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
