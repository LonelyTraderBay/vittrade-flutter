part of 'prediction_event_detail_tablet_page.dart';

// ---------------------------------------------------------------------------
// Thị trường liên quan + cầu nối Arena + liên kết nhanh + rủi ro.
// ---------------------------------------------------------------------------

class _Sc211RelatedMarketsSection extends StatelessWidget {
  const _Sc211RelatedMarketsSection({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.relatedEvents.isEmpty) return const SizedBox.shrink();
    return VitPageSection(
      label: 'Thị trường liên quan',
      innerGap: TabletSpacingTokens.x4,
      accentColor: AppColors.accent,
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
                if (index > 0) const SizedBox(width: TabletSpacingTokens.x4),
                _Sc211RelatedMarketCard(
                  event: snapshot.relatedEvents[index],
                  onTap: () => context.push(
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

class _Sc211RelatedMarketCard extends StatelessWidget {
  const _Sc211RelatedMarketCard({required this.event, required this.onTap});

  final PredictionEventDraft event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final top = event.outcomes.first;
    return SizedBox(
      key: PredictionEventDetailTabletPage.relatedKey(event.id),
      width:
          TabletSpacingTokens.x7 +
          TabletSpacingTokens.x7 +
          TabletSpacingTokens.x7,
      child: VitCard(
        onTap: onTap,
        density: VitDensity.compact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Sc211TinyBadge(
              label: event.category,
              color: AppColors.primary,
              background: AppColors.primary.withValues(alpha: .13),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            Row(
              children: [
                SizedBox.square(
                  dimension: TabletSpacingTokens.iconSm,
                  child: Material(
                    color: top.tone.resolve(),
                    shape: const CircleBorder(),
                  ),
                ),
                const SizedBox(width: TabletSpacingTokens.x1),
                Text(
                  VitFormat.percent(top.chance, fractionDigits: 0),
                  style: AppTextStyles.body.copyWith(
                    color: top.tone.resolve(),
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(width: TabletSpacingTokens.x1),
                Text(
                  top.label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(width: TabletSpacingTokens.x2),
                Expanded(
                  child: Text(
                    VitFormat.compactSuffix(event.volume24h, prefix: r'$'),
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

class _Sc211ArenaBridgeSection extends StatelessWidget {
  const _Sc211ArenaBridgeSection({
    required this.snapshot,
    required this.onCreate,
  });

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
                dimension: TabletSpacingTokens.accentIconBoxSize,
                child: Material(
                  color: AppColors.warn10,
                  borderRadius: AppRadii.smRadius,
                  child: Icon(
                    Icons.sports_esports_rounded,
                    color: AppColors.warn,
                    size: TabletSpacingTokens.iconMd,
                  ),
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mở Arena trên cùng chủ đề',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const Wrap(
                      spacing: TabletSpacingTokens.x2,
                      children: [
                        _Sc211ArenaBadge('Chỉ dùng Arena Points'),
                        _Sc211ArenaBadge('Chỉ bối cảnh sự kiện'),
                        _Sc211ArenaBadge('Không liên quan Wallet'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          for (
            var index = 0;
            index < snapshot.arenaRooms.length;
            index += 1
          ) ...[
            _Sc211ArenaRoomRow(room: snapshot.arenaRooms[index]),
            if (index != snapshot.arenaRooms.length - 1)
              const SizedBox(height: TabletSpacingTokens.x3),
          ],
          VitCard(
            key: PredictionEventDetailTabletPage.arenaCreateKey,
            onTap: onCreate,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            borderColor: AppColors.warningBorder,
            background: const ColoredBox(color: AppColors.warn08),
            clip: true,
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Row(
              children: [
                const SizedBox.square(
                  dimension: TabletSpacingTokens.iconSm,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.warn,
                    size: TabletSpacingTokens.iconSm,
                  ),
                ),
                const SizedBox(width: TabletSpacingTokens.x3),
                // Panel workspace ~232dp nội dung: badge nằm DƯỚI dòng phụ
                // thay vì ghim cột phải như bản một cột 840dp (re-compose,
                // không copy khung ngang của trang cũ).
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tạo Arena từ sự kiện này',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.warn,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: TabletSpacingTokens.x1),
                      Text(
                        'Sự kiện chỉ là bối cảnh, không liên kết ví hay P/L.',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: TabletSpacingTokens.x2),
                      const _Sc211ArenaBadge('Chỉ dùng Arena Points'),
                    ],
                  ),
                ),
                const SizedBox(width: TabletSpacingTokens.x2),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.warn,
                  size: TabletSpacingTokens.iconMd,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc211ArenaRoomRow extends StatelessWidget {
  const _Sc211ArenaRoomRow({required this.room});

  final PredictionArenaRoomDraft room;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Row(
        children: [
          const SizedBox.square(
            dimension: TabletSpacingTokens.iconSm,
            child: Icon(
              Icons.gamepad_outlined,
              color: AppColors.warn,
              size: TabletSpacingTokens.iconSm,
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
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
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(
                  '${room.slots} · ${VitFormat.count(room.points)} Arena Points',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _Sc211TinyBadge(
            label: room.badge,
            color: AppColors.warn,
            background: AppColors.warn10,
          ),
        ],
      ),
    );
  }
}

class _Sc211ArenaBadge extends StatelessWidget {
  const _Sc211ArenaBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warn10,
      borderRadius: AppRadii.badgeRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TabletSpacingTokens.x2,
          vertical: TabletSpacingTokens.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.badge.copyWith(color: AppColors.warn),
        ),
      ),
    );
  }
}

class _Sc211QuickLinks extends StatelessWidget {
  const _Sc211QuickLinks({required this.onRewards, required this.onActivity});

  final VoidCallback onRewards;
  final VoidCallback onActivity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Sc211QuickLinkCard(
            key: PredictionEventDetailTabletPage.dailyRewardsKey,
            icon: Icons.card_giftcard_rounded,
            color: AppColors.warn,
            title: 'Phần thưởng hàng ngày',
            subtitle: 'Cấp thanh khoản để kiếm thưởng',
            onTap: onRewards,
          ),
        ),
        const SizedBox(width: TabletSpacingTokens.x4),
        Expanded(
          child: _Sc211QuickLinkCard(
            key: PredictionEventDetailTabletPage.globalActivityKey,
            icon: Icons.timeline_rounded,
            color: AppColors.accent,
            title: 'Hoạt động toàn cục',
            subtitle: 'Bảng tin giao dịch trực tiếp',
            onTap: onActivity,
          ),
        ),
      ],
    );
  }
}

class _Sc211QuickLinkCard extends StatelessWidget {
  const _Sc211QuickLinkCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Row(
        children: [
          SizedBox.square(
            dimension: TabletSpacingTokens.iconMd,
            child: Icon(icon, color: color, size: TabletSpacingTokens.iconMd),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc211RiskLink extends StatelessWidget {
  const _Sc211RiskLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionEventDetailTabletPage.riskLinkKey,
      onTap: onTap,
      variant: VitCardVariant.ghost,
      padding: TabletSpacingTokens.zeroInsets,
      radius: VitCardRadius.standard,
      child: SizedBox(
        height: TabletSpacingTokens.buttonCompact,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox.square(
                dimension: TabletSpacingTokens.iconSm,
                child: Icon(
                  Icons.shield_outlined,
                  color: AppColors.warn,
                  size: TabletSpacingTokens.iconSm,
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x1),
              Flexible(
                child: Text(
                  'Hiểu rủi ro trước khi giao dịch',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x1),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.warn,
                size: TabletSpacingTokens.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _sc211FormatDate(DateTime value) {
  const months = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
  ];
  return '${value.day}/${months[value.month - 1]}/${value.year}';
}
