part of '../../phone/pages/staking/staking_risk_disclosure_page.dart';

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.snapshot});

  final StakingRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      key: StakingRiskDisclosurePage.warningKey,
      constraints: const BoxConstraints(
        minHeight: _stakingRiskWarningMinHeight,
      ),
      child: Material(
        color: AppColors.sell10,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.cardLargeRadius,
          side: BorderSide(
            color: AppColors.sell20,
            width: _stakingRiskBorderWidth,
          ),
        ),
        child: Padding(
          padding: EarnSpacingTokens.earnPaddingX4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.sell,
                size: _stakingRiskWarningIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.warningTitle,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      snapshot.warningBody,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: _stakingRiskBodyLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RiskTabs extends StatelessWidget {
  const _RiskTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<StakingRiskDisclosureTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: StakingRiskDisclosurePage.tabKey(tab.id),
          ),
      ],
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final StakingRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingRiskDisclosurePage.overviewKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(
          title: snapshot.summaryTitle,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: AppColors.primary,
          density: VitDensity.compact,
          titleColor: AppColors.text2,
          titleHeight: _stakingRiskCompactLineHeight,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _RiskSummaryCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitSectionHeader(
          title: snapshot.productSectionTitle,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: AppColors.primary,
          density: VitDensity.compact,
          titleColor: AppColors.text2,
          titleHeight: _stakingRiskCompactLineHeight,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final product in snapshot.products) ...[
          _RiskProductCard(product: product),
          if (product != snapshot.products.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.large,
          padding: _stakingRiskCardPadding,
          child: Text(
            snapshot.disclaimer,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: _stakingRiskNoticeLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _RiskSummaryCard extends StatelessWidget {
  const _RiskSummaryCard({required this.snapshot});

  final StakingRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: _stakingRiskCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.summaryBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: _stakingRiskSummaryLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              for (final count in snapshot.riskCounts) ...[
                Expanded(child: _RiskCountTile(count: count)),
                if (count != snapshot.riskCounts.last)
                  const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskCountTile extends StatelessWidget {
  const _RiskCountTile({required this.count});

  final StakingRiskCountDraft count;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(count.level);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _stakingRiskCountMinHeight),
      child: Material(
        color: _riskTint(count.level),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.lgRadius,
          side: BorderSide(color: color.withValues(alpha: .28)),
        ),
        child: Padding(
          padding: EarnSpacingTokens.earnCardPaddingX3X4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${count.count}',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: _stakingRiskCompactLineHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                count.label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RiskProductCard extends StatelessWidget {
  const _RiskProductCard({required this.product});

  final StakingRiskProductDraft product;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: StakingRiskDisclosurePage.productKey(product.name),
      radius: VitCardRadius.large,
      constraints: BoxConstraints(
        minHeight: product.risks.length > 3
            ? _stakingRiskProductMinHeightTall
            : _stakingRiskProductMinHeight,
      ),
      padding: _stakingRiskCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _RiskLevelBadge(level: product.level, prefix: true),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final risk in product.risks)
                Material(
                  borderRadius: AppRadii.mdRadius,
                  color: AppColors.surface3,
                  child: Padding(
                    padding: EarnSpacingTokens.earnCardPaddingX3X2,
                    child: Text(
                      risk,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: _stakingRiskCompactLineHeight,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
