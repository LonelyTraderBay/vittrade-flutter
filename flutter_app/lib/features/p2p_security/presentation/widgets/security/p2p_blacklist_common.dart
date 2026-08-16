part of '../../phone/pages/security/p2p_blacklist_page.dart';

class _InfoNote extends StatelessWidget {
  const _InfoNote({required this.snapshot});

  final P2PBlacklistSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PBlacklistPage.infoKey,
      radius: VitCardRadius.standard,
      borderColor: AppColors.primary20,
      padding: P2PSpacingTokens.p2pBlacklistListCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: AppSpacing.buttonCompact,
            child: Material(
              color: AppColors.primary.withValues(alpha: .12),
              borderRadius: AppRadii.smRadius,
              child: const Icon(
                Icons.shield_outlined,
                color: AppColors.primary,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.infoTitle,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.infoText,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: P2PSpacingTokens.p2pBlacklistReadableLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallReasonPill extends StatelessWidget {
  const _SmallReasonPill({required this.reason});

  final P2PBlacklistReasonDraft reason;

  @override
  Widget build(BuildContext context) {
    final color = _reasonColor(reason);
    return Material(
      color: color.withValues(alpha: .10),
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: P2PSpacingTokens.p2pBlacklistSmallReasonPadding,
        child: Text(
          reason.label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _TinyStat extends StatelessWidget {
  const _TinyStat({required this.value, required this.label, this.color});

  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.cardRadius,
      child: Padding(
        padding: P2PSpacingTokens.p2pBlacklistListTinyPadding,
        child: Column(
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, int> _reasonCounts(List<P2PBlacklistEntryDraft> entries) {
  final counts = <String, int>{};
  for (final entry in entries) {
    counts[entry.reasonId] = (counts[entry.reasonId] ?? 0) + 1;
  }
  return counts;
}

P2PBlacklistReasonDraft _findReason(
  List<P2PBlacklistReasonDraft> reasons,
  String id,
) {
  return reasons.firstWhere(
    (reason) => reason.id == id,
    orElse: () => reasons.last,
  );
}

IconData _reasonIcon(String iconKey) {
  return switch (iconKey) {
    'alert' => Icons.report_problem_outlined,
    'clock' => Icons.schedule_rounded,
    'ban' => Icons.block_rounded,
    'message' => Icons.chat_bubble_outline_rounded,
    'info' => Icons.info_outline_rounded,
    _ => Icons.block_rounded,
  };
}

Color _reasonColor(P2PBlacklistReasonDraft reason) {
  return switch (reason.toneKey) {
    'danger' => AppColors.sell,
    'warning' => AppColors.warn,
    'accent' => AppColors.accent,
    'primary' => AppColors.primary,
    _ => AppColors.text3,
  };
}

String _timeAgo(String raw) {
  final blockedAt = DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  if (blockedAt == null) return raw;
  final diff = DateTime.now().difference(blockedAt);
  final days = diff.inDays;
  if (days < 1) return 'Hôm nay';
  if (days == 1) return '1 ngày trước';
  if (days < 30) return '$days ngày trước';
  if (days < 365) return '${days ~/ 30} tháng trước';
  return '${days ~/ 365} năm trước';
}

String _shortDate(String raw) {
  final blockedAt = DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  if (blockedAt == null) return raw;
  return '${blockedAt.day}/${blockedAt.month}/${blockedAt.year}';
}
