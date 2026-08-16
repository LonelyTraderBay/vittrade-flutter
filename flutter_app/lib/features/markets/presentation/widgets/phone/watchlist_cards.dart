part of '../../phone/pages/hub/watchlist_page.dart';

class _WatchlistCard extends StatelessWidget {
  const _WatchlistCard({
    required this.item,
    required this.onPairTap,
    required this.onTradeTap,
    required this.onNoteTap,
    required this.onRemoveTap,
  });

  final _WatchlistItem item;
  final VoidCallback onPairTap;
  final VoidCallback onTradeTap;
  final VoidCallback onNoteTap;
  final VoidCallback onRemoveTap;

  @override
  Widget build(BuildContext context) {
    final pair = item.pair;
    final entry = item.entry;
    final positive = pair.change24h >= 0;
    final changeColor = positive ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: WatchlistPage.cardKey(pair.id),
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              key: WatchlistPage.pairLinkKey(pair.id),
              onTap: onPairTap,
              borderRadius: AppRadii.inputRadius,
              child: Row(
                children: [
                  _AssetAvatar(pair: pair),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pair.baseAsset,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.baseMedium,
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          pair.symbol,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatUsd(pair.price),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      VitAccentPill(
                        label: _formatPercent(pair.change24h),
                        accentColor: changeColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          SizedBox(
            height: _watchlistSparklineExtent,
            child: VitSparkline(values: pair.sparklineData, color: changeColor),
          ),
          if (entry.note != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            _WatchlistNoteRow(note: entry.note!),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: WatchlistPage.tradeKey(pair.id),
                  onPressed: onTradeTap,
                  density: VitDensity.compact,
                  height: VitDensity.compact.controlHeight,
                  child: const Text('Giao dịch'),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitCtaButton(
                key: WatchlistPage.noteKey(entry.id),
                onPressed: onNoteTap,
                variant: VitCtaButtonVariant.ghost,
                fullWidth: false,
                density: VitDensity.compact,
                height: VitDensity.compact.controlHeight,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x3,
                ),
                child: Text(
                  entry.note == null ? 'Thêm ghi chú' : 'Sửa ghi chú',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitIconButton(
                key: WatchlistPage.removeKey(entry.id),
                icon: Icons.delete_outline_rounded,
                tooltip: 'Xóa khỏi danh sách',
                onPressed: onRemoveTap,
                variant: VitIconButtonVariant.danger,
                size: VitIconButtonSize.md,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetAvatar extends StatelessWidget {
  const _AssetAvatar({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: pair.baseAsset,
      accentColor: AppAssetColors.forSymbol(pair.baseAsset),
      size: MarketsSpacingTokens.watchlistAvatar,
      radius: AppRadii.pillRadius,
    );
  }
}

class _WatchlistNoteRow extends StatelessWidget {
  const _WatchlistNoteRow({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _marketPrimary.withValues(alpha: 0.07),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.inputRadius,
        side: BorderSide(color: _marketPrimary.withValues(alpha: 0.14)),
      ),
      child: SizedBox(
        height: VitDensity.compact.controlHeight,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.x3,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.edit_note_rounded,
                color: _marketPrimary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: _marketPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
