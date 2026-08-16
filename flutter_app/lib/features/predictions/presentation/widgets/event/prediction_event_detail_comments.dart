part of '../../phone/pages/event/prediction_event_detail_page.dart';

class _CommentsContent extends StatelessWidget {
  const _CommentsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: AppColors.warn08,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: AppColors.warningBorder),
            borderRadius: AppRadii.mdRadius,
          ),
          child: Padding(
            padding:
                PredictionsSpacingTokens.predictionDetailCommentWarningPadding,
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warn,
                  size: PredictionsSpacingTokens
                      .predictionDetailCommentWarningIcon,
                ),
                const SizedBox(
                  width: PredictionsSpacingTokens
                      .predictionDetailCommentWarningGap,
                ),
                Expanded(
                  child: Text(
                    'Beware of external links. Do not share personal or financial information.',
                    style: AppTextStyles.micro.copyWith(color: AppColors.warn),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        const _CommentRow(
          name: 'MacroAlpha',
          side: 'Yes',
          text: 'Strong ETF flow and liquidity backdrop support this market.',
          likes: 18,
        ),
        const _CommentRow(
          name: 'RiskDesk',
          side: 'No',
          text: 'Watch macro rates and exchange liquidity before sizing up.',
          likes: 9,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        SizedBox(
          height: VitDensity.compact.controlHeight,
          child: Material(
            color: AppColors.surface2,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: AppColors.borderSolid),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Padding(
              padding:
                  PredictionsSpacingTokens.predictionDetailCommentInputPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add a comment...',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  Text(
                    'Post',
                    style: AppTextStyles.caption.copyWith(
                      color: _predictionPrimary,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow({
    required this.name,
    required this.side,
    required this.text,
    required this.likes,
  });

  final String name;
  final String side;
  final String text;
  final int likes;

  @override
  Widget build(BuildContext context) {
    final color = side == 'Yes' ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: PredictionsSpacingTokens.predictionDetailCommentRowPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius:
                PredictionsSpacingTokens.predictionDetailCommentAvatarRadius,
            backgroundColor: AppColors.surface2,
            child: Text(
              name[0],
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(
            width: PredictionsSpacingTokens.predictionDetailCommentAvatarGap,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing:
                      PredictionsSpacingTokens.predictionDetailCommentHeaderGap,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _TinyBadge(
                      label: side,
                      color: color,
                      background: color.withValues(alpha: .12),
                    ),
                    Text(
                      '4m ago',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x1),
                Row(
                  children: [
                    const Icon(
                      Icons.thumb_up_alt_outlined,
                      color: AppColors.text3,
                      size: PredictionsSpacingTokens
                          .predictionDetailCommentLikeIcon,
                    ),
                    const SizedBox(
                      width: PredictionsSpacingTokens
                          .predictionDetailCommentLikeGap,
                    ),
                    Text(
                      '$likes',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(
                      width: PredictionsSpacingTokens
                          .predictionDetailCommentReportGap,
                    ),
                    Text(
                      'Báo cáo',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
