part of 'dca_multi_asset_page.dart';

class _DCAMultiAssetPageState extends ConsumerState<DCAMultiAssetPage> {
  late final TextEditingController _budgetController;
  late final TextEditingController _thresholdController;
  _MultiAssetTab _activeTab = _MultiAssetTab.setup;
  DcaMultiAssetFrequency _frequency = DcaMultiAssetFrequency.monthly;
  bool _rebalanceEnabled = true;
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController();
    _thresholdController = TextEditingController();
  }

  // GD4 bẫy 14: seed từ snapshot giờ đã async — không còn đọc trong
  // initState(); dựng controller rỗng ở initState(), rồi seed một lần duy
  // nhất trong nhánh data: của .when() (xem build()).
  void _initializeFromSnapshot(DcaMultiAssetSnapshot snapshot) {
    if (_controllersInitialized) return;
    _budgetController.text = snapshot.totalBudgetUsd.toString();
    _thresholdController.text = snapshot.rebalanceThresholdPercent
        .toStringAsFixed(0);
    _frequency = snapshot.activeFrequency;
    _rebalanceEnabled = snapshot.rebalanceEnabled;
    _controllersInitialized = true;
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dcaMultiAssetAsync = ref.watch(dcaMultiAssetProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel:
          'Thiết lập DCA đa tài sản – phân bổ ngân sách, tần suất và tự động cân bằng',
      semanticIdentifier: 'SC-177',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Multi-Asset DCA',
          subtitle: 'Đầu tư có kỷ luật · đa tài sản',
          showBack: true,
          onBack: _close,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopTabs(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: dcaMultiAssetAsync.when(
                loading: () => const VitSkeletonList(),
                error: (error, stackTrace) => VitErrorState(
                  title: 'Không tải được DCA đa tài sản',
                  message: 'Thử lại sau hoặc quay lại màn DCA.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(dcaMultiAssetProvider),
                ),
                data: (snapshot) {
                  _initializeFromSnapshot(snapshot);
                  return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: VitInsetScrollView(
                      key: DCAMultiAssetPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      bottomInset: scrollEndPadding,
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        density: VitDensity.compact,
                        children: [
                          if (_activeTab == _MultiAssetTab.setup)
                            ..._buildSetup(snapshot),
                          if (_activeTab == _MultiAssetTab.assets)
                            ..._buildAssets(snapshot),
                          if (_activeTab == _MultiAssetTab.performance)
                            ..._buildPerformance(snapshot),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSetup(DcaMultiAssetSnapshot snapshot) {
    return [
      _BudgetCard(
        controller: _budgetController,
        frequency: _frequency,
        onFrequencyChanged: (frequency) {
          unawaited(HapticFeedback.selectionClick());
          setState(() => _frequency = frequency);
        },
      ),
      VitPageSection(
        label: 'Phân bổ tài sản',
        children: [
          for (var i = 0; i < snapshot.allocations.length; i++)
            _AllocationSetupCard(
              key: DCAMultiAssetPage.assetKey(snapshot.allocations[i].symbol),
              asset: snapshot.allocations[i],
              accent: _assetColor(i),
              onDelete: _showDeleteNotice,
            ),
        ],
      ),
      VitCtaButton(
        key: DCAMultiAssetPage.addAssetKey,
        onPressed: _showAddAssetNotice,
        variant: VitCtaButtonVariant.ghost,
        leading: const Icon(Icons.add_rounded),
        child: const Text('Add Asset'),
      ),
      _RebalancingCard(
        enabled: _rebalanceEnabled,
        controller: _thresholdController,
        onToggle: () {
          unawaited(HapticFeedback.selectionClick());
          setState(() => _rebalanceEnabled = !_rebalanceEnabled);
        },
      ),
      const _InfoCallout(
        icon: Icons.info_outline_rounded,
        text:
            'Multi-asset DCA giúp đa dạng hóa danh mục. Tự động phân bổ theo tỷ lệ mục tiêu mỗi kỳ.',
      ),
      const VitHighRiskStatePanel(
        state: VitHighRiskUiState.riskReview,
        title: 'Multi-asset DCA setup state review',
        message:
            'Budget, frequency, target allocations, asset removal notice, rebalance threshold, and disabled automation state remain visible before saving multi-asset DCA settings.',
        contractId: 'SC-177',
      ),
    ];
  }

  List<Widget> _buildAssets(DcaMultiAssetSnapshot snapshot) {
    return [
      _PortfolioOverviewCard(snapshot: snapshot),
      VitPageSection(
        label: 'Chi tiết tài sản',
        children: [
          for (var i = 0; i < snapshot.allocations.length; i++)
            _AssetDetailCard(
              asset: snapshot.allocations[i],
              accent: _assetColor(i),
            ),
        ],
      ),
      if (snapshot.needsRebalance && _rebalanceEnabled)
        const _WarningCallout(
          icon: Icons.tune_rounded,
          title: 'Rebalancing Required',
          text:
              'Some allocations deviate from target. Next purchase will rebalance automatically.',
        ),
      const VitHighRiskStatePanel(
        state: VitHighRiskUiState.riskReview,
        title: 'Multi-asset portfolio state review',
        message:
            'Portfolio value, per-asset allocation, rebalance requirement, and automatic rebalance toggle remain visible before the next DCA execution.',
        contractId: 'SC-177',
      ),
    ];
  }

  List<Widget> _buildPerformance(DcaMultiAssetSnapshot snapshot) {
    final ranked = [...snapshot.allocations]
      ..sort((a, b) => b.returnPercent.compareTo(a.returnPercent));

    return [
      _GrowthCard(points: snapshot.performance),
      VitPageSection(
        label: 'Asset Performance',
        children: [
          for (var i = 0; i < ranked.length; i++)
            _PerformanceRankRow(
              rank: i + 1,
              asset: ranked[i],
              accent: _assetColor(
                snapshot.allocations.indexWhere(
                  (asset) => asset.id == ranked[i].id,
                ),
              ),
            ),
        ],
      ),
      _DiversificationCard(assetCount: snapshot.allocations.length),
      const VitHighRiskStatePanel(
        state: VitHighRiskUiState.riskReview,
        title: 'Multi-asset performance state review',
        message:
            'Growth chart, ranked asset returns, diversification count, and performance context remain visible before adjusting DCA allocation strategy.',
        contractId: 'SC-177',
      ),
    ];
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }

  void _showAddAssetNotice() {
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: 'Thêm tài sản sẽ sớm ra mắt.',
      ),
    );
  }

  void _showDeleteNotice() {
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: 'Xoá tài sản sẽ sớm ra mắt.',
      ),
    );
  }
}

class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.activeTab, required this.onChanged});

  final _MultiAssetTab activeTab;
  final ValueChanged<_MultiAssetTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitScrollableTabHeader.surfaceDivider(
      tabBar: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_MultiAssetTab.values.byName(key)),
        tabs: [
          VitTabItem(
            key: _MultiAssetTab.setup.name,
            label: 'Cài đặt',
            widgetKey: DCAMultiAssetPage.tabKey(_MultiAssetTab.setup.name),
          ),
          VitTabItem(
            key: _MultiAssetTab.assets.name,
            label: 'Tài sản',
            widgetKey: DCAMultiAssetPage.tabKey(_MultiAssetTab.assets.name),
          ),
          VitTabItem(
            key: _MultiAssetTab.performance.name,
            label: 'Hiệu suất',
            widgetKey: DCAMultiAssetPage.tabKey(
              _MultiAssetTab.performance.name,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.controller,
    required this.frequency,
    required this.onFrequencyChanged,
  });

  final TextEditingController controller;
  final DcaMultiAssetFrequency frequency;
  final ValueChanged<DcaMultiAssetFrequency> onFrequencyChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('Total Budget per Period'),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitInput(
            controller: controller,
            fieldKey: DCAMultiAssetPage.budgetFieldKey,
            keyboardType: TextInputType.number,
            prefix: const Icon(Icons.attach_money_rounded),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Frequency',
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _FrequencyButton(
                  label: 'Weekly',
                  active: frequency == DcaMultiAssetFrequency.weekly,
                  onPressed: () =>
                      onFrequencyChanged(DcaMultiAssetFrequency.weekly),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _FrequencyButton(
                  label: 'Monthly',
                  active: frequency == DcaMultiAssetFrequency.monthly,
                  onPressed: () =>
                      onFrequencyChanged(DcaMultiAssetFrequency.monthly),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FrequencyButton extends StatelessWidget {
  const _FrequencyButton({
    required this.label,
    required this.active,
    required this.onPressed,
  });

  final String label;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onPressed,
      fullWidth: true,
      semanticLabel: label,
    );
  }
}

class _AllocationSetupCard extends StatelessWidget {
  const _AllocationSetupCard({
    super.key,
    required this.asset,
    required this.accent,
    required this.onDelete,
  });

  final DcaMultiAssetAllocation asset;
  final Color accent;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.symbol,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      asset.assetName,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              DcaDeleteButton(onPressed: onDelete),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _MetricText(
                  label: 'Target %',
                  value: _formatPercent(asset.targetPercent),
                ),
              ),
              Expanded(
                child: _MetricText(
                  label: 'Amount per Period',
                  value: _formatUsd(asset.amountPerPeriodUsd),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _PercentBar(
            label: 'Current Allocation',
            valueLabel: _formatPercent(asset.currentPercent),
            percent: asset.currentPercent,
            color: (asset.currentPercent - asset.targetPercent).abs() <= 2
                ? AppColors.buy
                : AppColors.primary,
          ),
        ],
      ),
    );
  }
}
