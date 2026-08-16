part of '../phone/pages/topic_hub_page.dart';

class _PredictionEventCard extends StatelessWidget {
  const _PredictionEventCard({required this.event});

  final DiscoveryPredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TopicHubPage.predictionKey(event.id),
      onTap: () => context.go(event.route),
      padding: LaunchpadSpacingTokens.discoveryCardPadding,
      borderColor: AppModuleAccents.predictions.withValues(alpha: .16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const DiscoveryModuleBadge(
                label: 'Thị trường dự đoán',
                icon: Icons.track_changes_rounded,
                color: AppModuleAccents.predictions,
              ),
              if (event.isTrending) ...[
                const SizedBox(width: AppSpacing.x3),
                Flexible(
                  child: Text(
                    'Đang nổi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppModuleAccents.arena,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            event.title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              height: LaunchpadSpacingTokens.discoveryPredictionTitleLineHeight,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Text(
                '${event.topOutcome} ${event.chance}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Text(
                  'KL ${event.volumeLabel}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const DiscoveryInlineCta(
                label: 'Xem thị trường',
                color: AppModuleAccents.predictions,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArenaRoomCard extends StatelessWidget {
  const _ArenaRoomCard({required this.room});

  final DiscoveryArenaRoomDraft room;

  @override
  Widget build(BuildContext context) {
    final statusColor = room.statusLabel == 'Trực tiếp'
        ? AppColors.buy
        : AppModuleAccents.arena;
    return VitCard(
      key: TopicHubPage.roomKey(room.id),
      onTap: () => context.go(room.route),
      padding: LaunchpadSpacingTokens.discoveryCardPadding,
      borderColor: AppModuleAccents.arena.withValues(alpha: .16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const DiscoveryModuleBadge(
                label: 'Chỉ điểm Arena',
                icon: Icons.stars_rounded,
                color: AppModuleAccents.arena,
              ),
              const SizedBox(width: AppSpacing.x3),
              _StatusMini(label: room.statusLabel, color: statusColor),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            room.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Text(
                '${room.entryPoints} điểm',
                style: AppTextStyles.micro.copyWith(
                  color: AppModuleAccents.arena,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Text(
                  '${room.slotsFilled}/${room.slotsTotal} (${room.fillPercent}%) · ${room.creatorName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const DiscoveryInlineCta(
                label: 'Xem phòng',
                color: AppModuleAccents.arena,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArenaModeCard extends StatelessWidget {
  const _ArenaModeCard({required this.mode});

  final DiscoveryArenaModeDraft mode;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TopicHubPage.modeKey(mode.id),
      onTap: () => context.go(mode.route),
      padding: LaunchpadSpacingTokens.discoveryCardPadding,
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.bolt_rounded,
            color: AppModuleAccents.arena,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        mode.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (mode.fairPlay) ...[
                      const SizedBox(width: AppSpacing.x2),
                      const Icon(
                        Icons.shield_rounded,
                        color: AppColors.buy,
                        size: 12,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${mode.activeChallenges} thách đấu · ${mode.cloneCount} bản sao',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const DiscoveryInlineCta(
            label: 'Xem chế độ',
            color: AppModuleAccents.arena,
          ),
        ],
      ),
    );
  }
}

class _CreatorChip extends StatelessWidget {
  const _CreatorChip({required this.creator});

  final DiscoveryCreatorDraft creator;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TopicHubPage.creatorKey(creator.id),
      onTap: () => context.go(creator.route),
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      padding: LaunchpadSpacingTokens.discoveryPillPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DiscoveryInitialsAvatar(
            initials: creator.initials,
            size: LaunchpadSpacingTokens.discoveryCreatorAvatarBox,
            fillAlpha: .16,
            radius: AppRadii.smRadius,
            textStyle: AppTextStyles.micro,
          ),
          const SizedBox(width: AppSpacing.x3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                creator.name,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                'Uy tín ${creator.trustScore}%',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreateRoomCard extends StatelessWidget {
  const _CreateRoomCard({required this.snapshot});

  final TopicHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TopicHubPage.createRoomKey,
      padding: LaunchpadSpacingTokens.discoveryCardPadding,
      borderColor: AppModuleAccents.arena.withValues(alpha: .22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const VitAccentIconBox(
                icon: Icons.bolt_rounded,
                color: AppModuleAccents.arena,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tạo room Arena theo chủ đề',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Tạo thách đấu Arena Points liên quan đến ${snapshot.selectedTopic.label}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              VitCtaButton(
                onPressed: () => context.go(snapshot.createArenaRoute),
                fullWidth: false,
                height: AppSpacing.buttonCompact,
                padding: LaunchpadSpacingTokens.discoveryChipHorizontalPadding,
                child: const Text('Tạo room'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Padding(
            padding: LaunchpadSpacingTokens.discoveryLeftIndentedCopyPadding,
            child: Text(
              'Chủ đề chỉ là bối cảnh. Room Arena không ảnh hưởng vị thế Prediction Markets.',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TopicHubPage.disclosureKey,
      variant: VitCardVariant.inner,
      padding: LaunchpadSpacingTokens.discoveryCardPadding,
      child: VitRiskDisclaimerNote(
        message:
            'Lưu ý: Thị trường dự đoán sử dụng USDT thật (vị thế thực). Thách đấu Arena chỉ dùng Điểm Arena (không phải tài sản tài chính). Trung tâm chủ đề là trang khám phá, hai module hoàn toàn riêng biệt.\n$notes',
      ),
    );
  }
}
