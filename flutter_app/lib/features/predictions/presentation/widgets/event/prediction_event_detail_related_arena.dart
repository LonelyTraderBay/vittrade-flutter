part of '../../phone/pages/event/prediction_event_detail_page.dart';

class _RelatedMarketsSection extends StatelessWidget {
  const _RelatedMarketsSection({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.relatedEvents.isEmpty) return const SizedBox.shrink();
    return VitPageSection(
      label: 'Related Markets',
      accentColor: _predictionPurple,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (
                var index = 0;
                index < snapshot.relatedEvents.length;
                index += 1
              ) ...[
                if (index > 0)
                  const SizedBox(
                    width: PredictionsSpacingTokens.predictionDetailRelatedGap,
                  ),
                _RelatedMarketCard(
                  event: snapshot.relatedEvents[index],
                  onTap: () => context.go(
                    AppRoutePaths.marketsPredictionEvent(
                      snapshot.relatedEvents[index].id,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RelatedMarketCard extends StatelessWidget {
  const _RelatedMarketCard({required this.event, required this.onTap});

  final PredictionEventDraft event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final top = event.outcomes.first;
    return SizedBox(
      key: PredictionEventDetailPage.relatedKey(event.id),
      width: PredictionsSpacingTokens.predictionDetailRelatedCardWidth,
      child: VitCard(
        onTap: onTap,
        density: VitDensity.compact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TinyBadge(
              label: event.category,
              color: _predictionPrimary,
              background: _predictionPrimary.withValues(alpha: .13),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Row(
              children: [
                SizedBox.square(
                  dimension:
                      PredictionsSpacingTokens.predictionDetailRelatedDot,
                  child: Material(
                    color: top.tone.resolve(),
                    shape: const CircleBorder(),
                  ),
                ),
                const SizedBox(
                  width: PredictionsSpacingTokens.predictionDetailRelatedDotGap,
                ),
                Text(
                  '${top.chance}%',
                  style: AppTextStyles.body.copyWith(
                    color: top.tone.resolve(),
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(
                  width:
                      PredictionsSpacingTokens.predictionDetailRelatedLabelGap,
                ),
                Text(
                  top.label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    _formatVolume(event.volume24h),
                    textAlign: TextAlign.end,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArenaBridgeSection extends StatelessWidget {
  const _ArenaBridgeSection({required this.snapshot, required this.onCreate});

  final PredictionEventDetailSnapshot snapshot;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox.square(
                dimension:
                    PredictionsSpacingTokens.predictionDetailArenaIconBox,
                child: Material(
                  color: AppColors.warn10,
                  borderRadius: AppRadii.mdRadius,
                  child: Icon(
                    Icons.sports_esports_rounded,
                    color: AppColors.warn,
                    size: PredictionsSpacingTokens.predictionDetailArenaIcon,
                  ),
                ),
              ),
              const SizedBox(
                width: PredictionsSpacingTokens.predictionDetailArenaHeaderGap,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Open Arena trên cùng chủ đề',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const Wrap(
                      spacing: PredictionsSpacingTokens
                          .predictionDetailArenaBadgeGap,
                      children: [
                        _ArenaBadge('Arena Points only'),
                        _ArenaBadge('Event context only'),
                        _ArenaBadge('Không liên quan Wallet'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (
            var index = 0;
            index < snapshot.arenaRooms.length;
            index += 1
          ) ...[
            _ArenaRoomRow(room: snapshot.arenaRooms[index]),
            if (index != snapshot.arenaRooms.length - 1)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
          VitCard(
            key: PredictionEventDetailPage.arenaCreateKey,
            onTap: onCreate,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            borderColor: AppColors.warningBorder,
            background: const ColoredBox(color: AppColors.warn08),
            clip: true,
            padding:
                PredictionsSpacingTokens.predictionDetailArenaCreatePadding,
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.warn,
                  size:
                      PredictionsSpacingTokens.predictionDetailArenaCreateIcon,
                ),
                const SizedBox(
                  width:
                      PredictionsSpacingTokens.predictionDetailArenaCreateGap,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tạo Arena từ event này',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.warn,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        'Event chỉ là bối cảnh, không liên kết ví hay P/L.',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const _ArenaBadge('Arena Points only'),
                const SizedBox(
                  width: PredictionsSpacingTokens
                      .predictionDetailArenaCreateBadgeGap,
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.warn,
                  size: PredictionsSpacingTokens
                      .predictionDetailArenaCreateChevron,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArenaRoomRow extends StatelessWidget {
  const _ArenaRoomRow({required this.room});

  final PredictionArenaRoomDraft room;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.mdRadius,
        side: BorderSide(color: AppColors.borderSolid),
      ),
      child: Padding(
        padding: PredictionsSpacingTokens.predictionDetailArenaRoomPadding,
        child: Row(
          children: [
            const Icon(
              Icons.gamepad_outlined,
              color: AppColors.warn,
              size: PredictionsSpacingTokens.predictionDetailArenaRoomIcon,
            ),
            const SizedBox(
              width: PredictionsSpacingTokens.predictionDetailArenaRoomGap,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    '${room.slots} · ${room.points} Arena Points',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            _TinyBadge(
              label: room.badge,
              color: AppColors.warn,
              background: AppColors.warn10,
            ),
          ],
        ),
      ),
    );
  }
}

class _ArenaBadge extends StatelessWidget {
  const _ArenaBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warn10,
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: PredictionsSpacingTokens.predictionDetailArenaBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.badge.copyWith(color: AppColors.warn),
        ),
      ),
    );
  }
}
