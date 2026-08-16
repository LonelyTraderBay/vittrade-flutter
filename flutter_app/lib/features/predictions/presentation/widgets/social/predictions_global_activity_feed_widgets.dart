part of '../../phone/pages/social/predictions_global_activity_page.dart';

class _ActivityList extends StatelessWidget {
  const _ActivityList({required this.snapshot});

  final PredictionGlobalActivitySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < snapshot.activities.length; index += 1)
          _ActivityRow(
            key: PredictionsGlobalActivityPage.activityKey(
              snapshot.activities[index].id,
            ),
            activity: snapshot.activities[index],
            event: snapshot.eventFor(snapshot.activities[index].eventId),
            last: index == snapshot.activities.length - 1,
          ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    super.key,
    required this.activity,
    required this.event,
    required this.last,
  });

  final PredictionGlobalActivityDraft activity;
  final PredictionEventDraft event;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final isBuy = activity.action == PredictionGlobalActivityAction.bought;
    final sideColor = isBuy ? AppColors.buy : AppColors.sell;
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                vertical: AppSpacing.x2,
              ),
              child: Row(
                children: [
                  Material(
                    color: AppColors.surface3,
                    shape: const CircleBorder(),
                    child: SizedBox.square(
                      dimension: _activityAvatarExtent,
                      child: Center(
                        child: Text(
                          activity.avatar,
                          style: AppTextStyles.avatarMd,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpacing.x1,
                          runSpacing: AppSpacing.x1,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              activity.user,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            Text(
                              isBuy ? 'bought' : 'sold',
                              style: AppTextStyles.caption.copyWith(
                                color: sideColor,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            _OutcomeBadge(
                              label: activity.outcome,
                              color: activity.outcome == 'Yes'
                                  ? AppColors.buy
                                  : AppColors.sell,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          event.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          '${_formatWhole(activity.shares)} shares @ \$${activity.price.toStringAsFixed(2)}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  SizedBox(
                    width: _activityAmountExtent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatAmount(activity.amount),
                          textAlign: TextAlign.right,
                          style: AppTextStyles.caption.copyWith(
                            color: sideColor,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          activity.timestamp,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!last)
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
          ],
        ),
      ),
    );
  }
}

class _OutcomeBadge extends StatelessWidget {
  const _OutcomeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

String _formatAmount(double value) =>
    VitFormat.compactSuffix(value, prefix: r'$');

String _formatWhole(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i += 1) {
    final fromEnd = text.length - i;
    buffer.write(text[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
