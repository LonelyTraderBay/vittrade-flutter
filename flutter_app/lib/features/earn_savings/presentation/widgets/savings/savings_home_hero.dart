part of '../../phone/pages/savings/savings_page.dart';

class _SavingsHero extends StatelessWidget {
  const _SavingsHero({required this.snapshot});

  final SavingsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _HeroKpi(
                  label: 'Tổng tiền gửi (USD)',
                  value: snapshot.totalDepositedUsd,
                  caption: snapshot.gainLabel.isEmpty
                      ? 'Chưa có vị thế'
                      : '${snapshot.gainLabel} lãi tích lũy',
                  valueColor: AppColors.text1,
                ),
              ),
              const SizedBox(
                width: 1,
                height: AppSpacing.x6,
                child: ColoredBox(color: AppColors.border),
              ),
              Expanded(
                child: Padding(
                  padding: EarnSpacingTokens.earnHeroSecondaryPadding,
                  child: _HeroKpi(
                    label: 'APY ước tính',
                    value: _savingsApyEstimateRange(snapshot.products),
                    caption: 'Tham khảo, có thể thay đổi',
                    valueColor: AppModuleAccents.earn,
                  ),
                ),
              ),
              VitIconButton(
                key: SavingsPage.portfolioButtonKey,
                icon: Icons.account_balance_wallet_outlined,
                tooltip: 'Mở danh mục tiết kiệm',
                onPressed: () => context.go(snapshot.portfolioRoute),
                variant: VitIconButtonVariant.transparent,
                size: VitIconButtonSize.md,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap),
          Row(
            children: [
              Expanded(
                child: _HeroAction(
                  label: 'Danh mục',
                  icon: Icons.wallet_outlined,
                  primary: true,
                  onTap: () => context.go(snapshot.portfolioRoute),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Expanded(
                child: _HeroAction(
                  label: 'Gửi',
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Expanded(
                child: _HeroAction(
                  label: 'Rút',
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroKpi extends StatelessWidget {
  const _HeroKpi({
    required this.label,
    required this.value,
    required this.caption,
    required this.valueColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

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
          style: AppTextStyles.heroNumber.copyWith(
            color: valueColor,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          caption,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    required this.label,
    required this.icon,
    this.primary = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      variant: primary
          ? VitCtaButtonVariant.primary
          : VitCtaButtonVariant.secondary,
      height: AppSpacing.buttonCompact,
      fullWidth: true,
      leading: Icon(icon),
      onPressed: onTap,
      child: Text(label),
    );
  }
}

const _visibleSavingsToolIds = {
  'analytics',
  'history',
  'goals',
  'ladder',
  'backtest',
  'smart-suggestions',
  'what-if',
  'autopilot',
};

const _savingsDcaOverflowTool = EarnHubTool(
  id: 'dca',
  label: 'DCA',
  route: AppRoutePaths.earnSavingsDca,
  iconKey: 'dca',
);

class _SavingsToolsSection extends StatelessWidget {
  const _SavingsToolsSection({required this.tools, required this.onNavigate});

  final List<EarnHubTool> tools;
  final ValueChanged<String> onNavigate;

  List<EarnHubTool> get _visibleTools => tools
      .where((tool) => _visibleSavingsToolIds.contains(tool.id))
      .toList(growable: false);

  List<EarnHubTool> get _overflowTools => [
    ...tools.where((tool) => !_visibleSavingsToolIds.contains(tool.id)),
    _savingsDcaOverflowTool,
  ];

  void _openOverflowSheet(BuildContext context) {
    final rootContext = context;
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.bg,
        builder: (sheetContext) {
          return VitSheetPanel(
            key: SavingsPage.moreToolsSheetKey,
            title: 'Thêm công cụ tiết kiệm',
            child: VitActionTileGrid(
              density: VitDensity.compact,
              crossAxisSpacing: AppSpacing.x3,
              mainAxisSpacing: AppSpacing.x3,
              physics: const ClampingScrollPhysics(),
              itemCount: _overflowTools.length,
              itemBuilder: (context, index, density) {
                final tool = _overflowTools[index];
                return VitServiceTile(
                  key: _savingsToolKey(tool.id),
                  density: density,
                  icon: _savingsToolIcon(tool.iconKey),
                  label: tool.label,
                  accentColor: AppModuleAccents.earn,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    rootContext.go(tool.route);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleTools = _visibleTools;
    final itemCount = visibleTools.length + 1;
    return VitPageSection(
      key: SavingsPage.toolsSectionKey,
      label: 'Công cụ tiết kiệm',
      headerIcon: Icons.grid_view_rounded,
      headerIconColor: AppModuleAccents.earn,
      accentColor: AppModuleAccents.earn,
      headerVariant: VitSectionHeaderVariant.plain,
      innerGap: AppSpacing.pageRhythmCompactInnerGap,
      children: [
        VitActionTileGrid(
          density: VitDensity.compact,
          itemCount: itemCount,
          itemBuilder: (context, index, density) {
            if (index == visibleTools.length) {
              return VitServiceTile(
                key: SavingsPage.moreToolsKey,
                density: density,
                icon: Icons.more_horiz_rounded,
                label: 'Thêm',
                accentColor: AppColors.text3,
                onTap: () => _openOverflowSheet(context),
              );
            }
            final tool = visibleTools[index];
            return VitServiceTile(
              key: _savingsToolKey(tool.id),
              density: density,
              icon: _savingsToolIcon(tool.iconKey),
              label: tool.label,
              accentColor: AppModuleAccents.earn,
              onTap: () {
                unawaited(HapticFeedback.selectionClick());
                onNavigate(tool.route);
              },
            );
          },
        ),
      ],
    );
  }
}

Key? _savingsToolKey(String id) {
  return switch (id) {
    'dca' => SavingsPage.dcaInsightKey,
    'export' => SavingsPage.exportInsightKey,
    'backtest' => SavingsPage.backtestInsightKey,
    'autopilot' => SavingsPage.autopilotInsightKey,
    'ladder' => SavingsPage.ladderInsightKey,
    'what-if' => SavingsPage.whatIfInsightKey,
    'smart-suggestions' => SavingsPage.smartSuggestionsInsightKey,
    'guide' => SavingsPage.guideButtonKey,
    _ => null,
  };
}

IconData _savingsToolIcon(String iconKey) {
  return switch (iconKey) {
    'analytics' => Icons.analytics_outlined,
    'autopilot' => Icons.auto_awesome_outlined,
    'backtest' => Icons.science_outlined,
    'comparison' => Icons.compare_arrows_rounded,
    'dca' => Icons.sync_alt_rounded,
    'export' => Icons.file_download_outlined,
    'faq' => Icons.help_outline_rounded,
    'goals' => Icons.flag_outlined,
    'guide' => Icons.menu_book_outlined,
    'history' => Icons.history_rounded,
    'ladder' => Icons.stacked_line_chart_rounded,
    'notifications' => Icons.notifications_active_outlined,
    'rebalance' => Icons.tune_rounded,
    'recommendations' => Icons.tips_and_updates_outlined,
    'smart-suggestions' => Icons.lightbulb_outline_rounded,
    'what-if' => Icons.query_stats_rounded,
    _ => Icons.hub_outlined,
  };
}

class _YieldDisclaimer extends StatelessWidget {
  const _YieldDisclaimer();

  @override
  Widget build(BuildContext context) {
    return const VitRiskDisclaimerNote(
      message:
          'APY là ước tính tham khảo và có thể thay đổi. Giá tài sản và APY có thể biến động; rút trước hạn có thể mất lãi tích lũy.',
    );
  }
}
