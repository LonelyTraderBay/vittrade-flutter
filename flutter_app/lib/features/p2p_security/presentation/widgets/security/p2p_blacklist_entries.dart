part of '../../phone/pages/security/p2p_blacklist_page.dart';

class _EntryList extends StatelessWidget {
  const _EntryList({
    required this.snapshot,
    required this.entries,
    required this.expandedId,
    required this.onToggle,
    required this.onUnblock,
  });

  final P2PBlacklistSnapshot snapshot;
  final List<P2PBlacklistEntryDraft> entries;
  final String? expandedId;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onUnblock;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return VitEmptyState(
        key: P2PBlacklistPage.emptyKey,
        icon: Icons.shield_outlined,
        title: snapshot.emptyTitle,
        message: 'Thử đổi bộ lọc hoặc thêm người dùng vào danh sách chặn.',
      );
    }

    return Column(
      children: [
        for (var index = 0; index < entries.length; index++) ...[
          _EntryCard(
            entry: entries[index],
            reason: _findReason(snapshot.reasons, entries[index].reasonId),
            expanded: expandedId == entries[index].id,
            onToggle: () => onToggle(entries[index].id),
            onUnblock: () => onUnblock(entries[index].id),
          ),
          if (index != entries.length - 1)
            const SizedBox(height: _p2pBlacklistEntryGap),
        ],
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.entry,
    required this.reason,
    required this.expanded,
    required this.onToggle,
    required this.onUnblock,
  });

  final P2PBlacklistEntryDraft entry;
  final P2PBlacklistReasonDraft reason;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    final color = _reasonColor(reason);
    return VitCard(
      key: P2PBlacklistPage.entryKey(entry.id),
      radius: VitCardRadius.large,
      borderColor: expanded ? color.withValues(alpha: .38) : null,
      clip: true,
      child: Column(
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: onToggle,
              child: Padding(
                padding: P2PSpacingTokens.p2pBlacklistListCardPadding,
                child: Row(
                  children: [
                    _Avatar(entry: entry, reason: reason),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  entry.username,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                              ),
                              if (entry.isVerified) ...[
                                const SizedBox(width: AppSpacing.x2),
                                const Icon(
                                  Icons.verified_outlined,
                                  color: AppColors.primary,
                                  size: AppSpacing.iconSm,
                                ),
                              ],
                              if (entry.badge != null) ...[
                                const SizedBox(width: AppSpacing.x2),
                                VitStatusPill(
                                  label: entry.badge == 'elite'
                                      ? 'Elite'
                                      : 'Pro',
                                  status: VitStatusPillStatus.purple,
                                  size: VitStatusPillSize.sm,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: _p2pBlacklistTightGap),
                          Row(
                            children: [
                              _SmallReasonPill(reason: reason),
                              const SizedBox(width: AppSpacing.x2),
                              Text(
                                _timeAgo(entry.blockedAt),
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.chevron_right_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.iconMd,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded)
            _ExpandedEntry(entry: entry, reason: reason, onUnblock: onUnblock),
        ],
      ),
    );
  }
}

class _ExpandedEntry extends StatelessWidget {
  const _ExpandedEntry({
    required this.entry,
    required this.reason,
    required this.onUnblock,
  });

  final P2PBlacklistEntryDraft entry;
  final P2PBlacklistReasonDraft reason;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    final color = _reasonColor(reason);
    return Column(
      children: [
        const SizedBox(
          height: AppSpacing.dividerHairline,
          child: ColoredBox(color: AppColors.divider),
        ),
        Padding(
          padding: P2PSpacingTokens.p2pBlacklistListCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                color: AppColors.surface2,
                borderRadius: AppRadii.cardRadius,
                child: Padding(
                  padding: P2PSpacingTokens.p2pBlacklistListTinyPadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _reasonIcon(reason.iconKey),
                        color: color,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          entry.reasonText,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: _p2pBlacklistSectionGap),
              Row(
                children: [
                  Expanded(
                    child: _TinyStat(
                      value: '${entry.tradesBefore}',
                      label: 'Đơn trước chặn',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _TinyStat(
                      value: '${entry.completionRate.toStringAsFixed(1)}%',
                      label: 'Tỷ lệ HT',
                      color: entry.completionRate < 50
                          ? AppColors.sell
                          : AppColors.warn,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _TinyStat(
                      value: _shortDate(entry.blockedAt),
                      label: 'Ngày chặn',
                    ),
                  ),
                ],
              ),
              if (entry.orderId != null) ...[
                const SizedBox(height: _p2pBlacklistSectionGap),
                _OrderLink(orderId: entry.orderId!),
              ],
              const SizedBox(height: _p2pBlacklistSectionGap),
              Row(
                children: [
                  Expanded(
                    child: VitCtaButton(
                      key: P2PBlacklistPage.unblockKey(entry.id),
                      variant: VitCtaButtonVariant.success,
                      height: _p2pBlacklistActionHeight,
                      onPressed: onUnblock,
                      leading: const Icon(Icons.check_circle_outline_rounded),
                      child: const Text('Bỏ chặn'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: VitCtaButton(
                      variant: VitCtaButtonVariant.ghost,
                      height: _p2pBlacklistActionHeight,
                      onPressed: () => HapticFeedback.selectionClick(),
                      leading: const Icon(
                        Icons.report_problem_outlined,
                        color: AppColors.warn,
                      ),
                      child: const Text('Báo cáo'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.entry, required this.reason});

  final P2PBlacklistEntryDraft entry;
  final P2PBlacklistReasonDraft reason;

  @override
  Widget build(BuildContext context) {
    final color = _reasonColor(reason);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: AppSpacing.x6,
          height: AppSpacing.x6,
          child: Material(
            color: AppColors.sell10,
            shape: const CircleBorder(
              side: BorderSide(
                color: AppColors.sell20,
                width: AppSpacing.dividerHairline,
              ),
            ),
            child: Center(
              child: Text(
                entry.username.characters.first.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: -AppSpacing.x1,
          bottom: -AppSpacing.x1,
          child: SizedBox(
            width: AppSpacing.iconMd,
            height: AppSpacing.iconMd,
            child: Material(
              color: color,
              shape: const CircleBorder(
                side: BorderSide(
                  color: AppColors.surface,
                  width: AppSpacing.dividerHairline,
                ),
              ),
              child: Icon(
                _reasonIcon(reason.iconKey),
                color: AppColors.onAccent,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderLink extends StatelessWidget {
  const _OrderLink({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.cardRadius,
      child: Padding(
        padding: P2PSpacingTokens.p2pBlacklistListTinyPadding,
        child: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.primary,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                'Đơn liên quan: $orderId',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
