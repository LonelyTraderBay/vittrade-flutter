part of '../../phone/pages/hub/launchpad_portfolio_page.dart';

class _PortfolioHero extends StatelessWidget {
  const _PortfolioHero({required this.subscriptions});

  final List<LaunchpadSubscriptionDraft> subscriptions;

  @override
  Widget build(BuildContext context) {
    final totalInvested = subscriptions.fold<double>(
      0,
      (sum, subscription) => sum + subscription.amount,
    );
    final allocatedCount = subscriptions
        .where(
          (subscription) =>
              subscription.status == LaunchpadSubscriptionStatus.allocated ||
              subscription.status ==
                  LaunchpadSubscriptionStatus.partiallyAllocated ||
              subscription.status == LaunchpadSubscriptionStatus.claimed,
        )
        .length;
    final pendingCount = subscriptions
        .where(
          (subscription) =>
              subscription.status == LaunchpadSubscriptionStatus.pending,
        )
        .length;

    return VitModuleHeroCard(
      key: LaunchpadPortfolioPage.heroKey,
      accentColor: AppModuleAccents.launchpad,
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: AppSpacing.x7,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppModuleAccents.launchpad.withValues(alpha: .12),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.lgRadius,
                      side: BorderSide(
                        color: AppModuleAccents.launchpad.withValues(
                          alpha: .28,
                        ),
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.business_center_outlined,
                    color: AppModuleAccents.launchpad,
                    size: AppSpacing.iconLg,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng đã đầu tư',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                    Text(
                      _formatUsd(totalInvested),
                      style: AppTextStyles.pageTitle.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Dự án',
                  value: '${subscriptions.length}',
                  color: AppModuleAccents.launchpad,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Đã phân bổ',
                  value: '$allocatedCount',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Đang chờ',
                  value: '$pendingCount',
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Phân bổ phụ thuộc tổng đăng ký. Token mở khóa theo lịch mở khóa từng dự án.',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              height: _launchpadPortfolioLineHeightDense,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.portfolioTextMuted,
            height: LaunchpadSpacingTokens.launchpadLineHeightTight,
          ),
        ),
      ],
    );
  }
}

class _PortfolioTabs extends StatelessWidget {
  const _PortfolioTabs({required this.activeTab, required this.onChanged});

  final _PortfolioTab activeTab;
  final ValueChanged<_PortfolioTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      key: LaunchpadPortfolioPage.tabsKey,
      variant: VitTabBarVariant.segment,
      activeKey: activeTab.id,
      onChanged: (id) {
        unawaited(HapticFeedback.selectionClick());
        final tab = _PortfolioTab.values.firstWhere((tab) => tab.id == id);
        onChanged(tab);
      },
      tabs: [
        for (final tab in _PortfolioTab.values)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: LaunchpadPortfolioPage.tabKey(tab.id),
          ),
      ],
    );
  }
}
