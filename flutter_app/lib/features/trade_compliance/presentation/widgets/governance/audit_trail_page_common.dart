part of '../../phone/pages/governance/audit_trail_page.dart';

class _AuditEntryCard extends StatelessWidget {
  const _AuditEntryCard({required this.entry});

  final TradeAuditEntry entry;

  @override
  Widget build(BuildContext context) {
    final style = _styleForCategory(entry.category);
    return VitCard(
      radius: VitCardRadius.tight,
      constraints: const BoxConstraints(minHeight: AppSpacing.buttonHero),
      padding: TradeSpacingTokens.tradeToolCardPadding,
      borderColor: _auditBorder.withValues(alpha: .76),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            width: TradeSpacingTokens.tradeToolIconTileSm,
            height: TradeSpacingTokens.tradeToolIconTileSm,
            alignment: Alignment.center,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.tight,
            borderColor: style.color.withValues(alpha: .28),
            child: Icon(style.icon, color: style.color, size: 19),
          ),
          const SizedBox(width: TradeSpacingTokens.tradeToolPageTopGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.action,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: TradeSpacingTokens.tradeToolInlineGap,
                    ),
                    _CategoryBadge(entry: entry, color: style.color),
                  ],
                ),
                const SizedBox(height: TradeSpacingTokens.tradeToolInlineGap),
                Text(
                  entry.details,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: TradeSpacingTokens.tradeToolTinyGap),
                Text(
                  _metadata(entry),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: TradeSpacingTokens.tradeToolTinyGap),
                Text(
                  'ID: ${entry.id}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _metadata(TradeAuditEntry entry) {
    final parts = [
      entry.timestampLabel,
      if (entry.user != null) entry.user!,
      if (entry.ipAddress != null) entry.ipAddress!,
    ];
    return parts.join('  \u2022  ');
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.entry, required this.color});

  final TradeAuditEntry entry;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: entry.categoryLabel,
      accentColor: color,
      size: VitStatusPillSize.sm,
    );
  }
}

class _ExportActions extends StatelessWidget {
  const _ExportActions({required this.formats});

  final List<String> formats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final format in formats) ...[
          Expanded(
            child: VitCtaButton(
              key: AuditTrailPage.exportKey(format),
              onPressed: () => _showComingSoon(
                context,
                'Xuất nhật ký kiểm toán sẽ sớm ra mắt',
              ),
              variant: VitCtaButtonVariant.secondary,
              height: 40,
              leading: const Icon(Icons.download_rounded, size: 14),
              child: Text(
                format,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
          if (format != formats.last)
            const SizedBox(width: TradeSpacingTokens.tradeToolCardGap),
        ],
      ],
    );
  }
}

_AuditCategoryStyle _styleForCategory(TradeAuditCategory category) {
  return switch (category) {
    TradeAuditCategory.trade => const _AuditCategoryStyle(
      color: _auditGreen,
      icon: Icons.trending_up_rounded,
    ),
    TradeAuditCategory.compliance => const _AuditCategoryStyle(
      color: _auditPrimary,
      icon: Icons.description_outlined,
    ),
    TradeAuditCategory.clientAction => const _AuditCategoryStyle(
      color: _auditAmber,
      icon: Icons.person_outline_rounded,
    ),
    TradeAuditCategory.system => const _AuditCategoryStyle(
      color: AppColors.text3,
      icon: Icons.schedule_rounded,
    ),
  };
}

final class _AuditCategoryStyle {
  const _AuditCategoryStyle({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}

void _showComingSoon(BuildContext context, String message) {
  unawaited(HapticFeedback.selectionClick());
  unawaited(
    showVitNoticeSheet(
      context: context,
      title: 'Sắp ra mắt',
      message: message,
      variant: VitBannerVariant.info,
    ),
  );
}
