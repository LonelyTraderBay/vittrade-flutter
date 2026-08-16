part of '../../phone/pages/hub/active_copies_page.dart';

class _ActiveCopyList extends StatelessWidget {
  const _ActiveCopyList({
    required this.copies,
    required this.expandedCopyId,
    required this.onToggle,
    required this.onViewDetails,
    required this.onConfigure,
    required this.onStop,
  });

  final List<TradeActiveCopy> copies;
  final String? expandedCopyId;
  final ValueChanged<String> onToggle;
  final ValueChanged<TradeActiveCopy> onViewDetails;
  final ValueChanged<TradeActiveCopy> onConfigure;
  final ValueChanged<TradeActiveCopy> onStop;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        children: [
          for (var i = 0; i < copies.length; i++) ...[
            _ActiveCopyCard(
              key: ActiveCopiesPage.copyKey(copies[i].id),
              copy: copies[i],
              expanded: expandedCopyId == copies[i].id,
              onToggle: () => onToggle(copies[i].id),
              onViewDetails: () => onViewDetails(copies[i]),
              onConfigure: () => onConfigure(copies[i]),
              onStop: copies[i].status == TradeActiveCopyStatus.coolingOff
                  ? null
                  : () => onStop(copies[i]),
            ),
            if (i < copies.length - 1)
              const Divider(
                height: AppSpacing.dividerHairline,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _PortfolioOverview extends StatelessWidget {
  const _PortfolioOverview({required this.snapshot});

  final TradeActiveCopyPortfolio snapshot;

  @override
  Widget build(BuildContext context) {
    final positive = snapshot.totalPnl >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    final labelColor = positive ? AppColors.buy20 : AppColors.sellDeep;

    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: AppColors.cardBorder,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          Row(
            children: [
              Expanded(
                child: _PortfolioMetric(
                  label: 'Vốn đầu tư',
                  value: _formatUsd(snapshot.totalCapital),
                ),
              ),
              Expanded(
                child: _PortfolioMetric(
                  label: 'Giá trị hiện tại',
                  value: _formatUsd(snapshot.totalValue),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${snapshot.activeCopies} active',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.tight,
            density: VitDensity.tool,
            borderColor: color,
            child: Row(
              children: [
                Icon(
                  positive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: color,
                  size: TradeSpacingTokens.activeCopiesPnlIcon,
                ),
                const SizedBox(width: WalletSpacingTokens.walletAssetSmallGap),
                Text(
                  'P/L tổng',
                  style: AppTextStyles.micro.copyWith(
                    color: labelColor,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                const Expanded(child: SizedBox.shrink()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatSignedUsd(snapshot.totalPnl),
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      _formatPercent(snapshot.totalPnlPct),
                      style: AppTextStyles.micro.copyWith(
                        color: labelColor,
                        fontFeatures: AppTextStyles.tabularFigures,
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

class _PortfolioMetric extends StatelessWidget {
  const _PortfolioMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EmptyCopiesState extends StatelessWidget {
  const _EmptyCopiesState({required this.history, required this.onExplore});

  final bool history;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      title: history ? 'Chưa có lịch sử copy' : 'Chưa có copy nào đang chạy',
      message: history
          ? 'Lịch sử copy sẽ hiển thị ở đây.'
          : 'Bắt đầu copy từ trader chuyên nghiệp để tự động hóa giao dịch của bạn.',
      icon: history ? Icons.history_rounded : Icons.groups_rounded,
      actionLabel: history ? null : 'Khám phá traders',
      onAction: history ? null : onExplore,
    );
  }
}
