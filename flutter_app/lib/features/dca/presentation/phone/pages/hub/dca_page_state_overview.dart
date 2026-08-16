part of 'dca_page.dart';

class _DCAPageState extends ConsumerState<DCAPage> {
  _DcaTab _activeTab = _DcaTab.plans;
  bool _createSheetOpen = false;

  @override
  Widget build(BuildContext context) {
    final dcaDashboardAsync = ref.watch(dcaDashboardProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Mua tự động (DCA) – đầu tư định kỳ có kỷ luật',
      semanticIdentifier: 'SC-169',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'Mua tự động (DCA)',
            subtitle: 'Đầu tư có kỷ luật · mua định kỳ tự động',
            showBack: true,
            onBack: _close,
          ),
          child: dcaDashboardAsync.when(
            loading: () =>
                const VitSkeletonList(key: DCAPage.loadingKey, rows: 4),
            error: (error, stackTrace) => VitErrorState(
              key: DCAPage.errorKey,
              title: 'Không tải được kế hoạch DCA',
              message: 'Thử lại sau hoặc quay lại màn giao dịch.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(dcaDashboardProvider),
            ),
            data: (snapshot) {
              final showOfflineBanner =
                  snapshot.screenState == DcaScreenState.offline &&
                  snapshot.plans.isNotEmpty;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showOfflineBanner)
                    const Padding(
                      key: DCAPage.offlineKey,
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.contentPad,
                        AppSpacing.x3,
                        AppSpacing.contentPad,
                        0,
                      ),
                      child: VitOfflineBanner(
                        message: 'Đang ngoại tuyến',
                        detail: 'Hiển thị kế hoạch DCA đã lưu gần nhất.',
                      ),
                    ),
                  Expanded(
                    child: Stack(
                      children: [
                        ScrollConfiguration(
                          behavior: ScrollConfiguration.of(
                            context,
                          ).copyWith(scrollbars: false),
                          child: VitInsetScrollView(
                            key: DCAPage.contentKey,
                            physics: const ClampingScrollPhysics(),
                            bottomInset: scrollEndPadding,
                            child: VitPageContent(
                              rhythm: VitPageRhythm.standard,
                              padding: VitContentPadding.compact,
                              density: VitDensity.compact,
                              children: switch (snapshot.screenState) {
                                DcaScreenState.loading => [
                                  const VitSkeletonList(
                                    key: DCAPage.loadingKey,
                                    rows: 4,
                                  ),
                                ],
                                DcaScreenState.error => [
                                  VitErrorState(
                                    key: DCAPage.errorKey,
                                    title: 'Không tải được kế hoạch DCA',
                                    message:
                                        'Thử lại sau hoặc quay lại màn giao dịch.',
                                    actionLabel: 'Thử lại',
                                    onAction: _close,
                                  ),
                                ],
                                DcaScreenState.empty => [
                                  VitEmptyState(
                                    key: DCAPage.emptyKey,
                                    icon: Icons.sync_rounded,
                                    title: 'Chưa có kế hoạch DCA',
                                    message:
                                        'Tạo kế hoạch mua định kỳ để đầu tư có kỷ luật.',
                                    actionLabel: 'Tạo kế hoạch',
                                    actionKey: DCAPage.overviewCreateKey,
                                    onAction: _openCreateSheet,
                                  ),
                                ],
                                DcaScreenState.offline
                                    when snapshot.plans.isEmpty =>
                                  [
                                    const VitEmptyState(
                                      key: DCAPage.offlineKey,
                                      icon: Icons.wifi_off_rounded,
                                      title: 'Đang ngoại tuyến',
                                      message:
                                          'Kết nối lại để xem kế hoạch DCA mới nhất.',
                                    ),
                                  ],
                                _ => [
                                  _DcaOverviewCard(
                                    snapshot: snapshot,
                                    onCreate: _openCreateSheet,
                                    onPauseAll: _showPausedState,
                                    onChart: () => setState(
                                      () => _activeTab = _DcaTab.history,
                                    ),
                                    onHistory: () => setState(
                                      () => _activeTab = _DcaTab.history,
                                    ),
                                  ),
                                  _DcaTabs(
                                    active: _activeTab,
                                    planCount: snapshot.plans.length,
                                    onChanged: (tab) =>
                                        setState(() => _activeTab = tab),
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 180),
                                    child: _activeTab == _DcaTab.plans
                                        ? _PlansList(
                                            key: const ValueKey('plans'),
                                            plans: snapshot.plans,
                                            onPause: _showPausedState,
                                            onCreate: _openCreateSheet,
                                          )
                                        : _HistoryPanel(
                                            key: const ValueKey('history'),
                                            snapshot: snapshot,
                                          ),
                                  ),
                                  _AdvancedTools(
                                    tools: snapshot.tools,
                                    onOpen: _go,
                                  ),
                                  const VitHighRiskStatePanel(
                                    state: VitHighRiskUiState.riskReview,
                                    title: 'Xem lại kế hoạch DCA',
                                    message:
                                        'Tạo, tạm dừng và chỉnh lịch mua đều cần xem lại trước khi áp dụng.',
                                    contractId: 'SC-169',
                                  ),
                                ],
                              },
                            ),
                          ),
                        ),
                        if (_createSheetOpen)
                          _CreatePlanSheet(
                            bottomInset: scrollEndPadding,
                            onClose: _closeCreateSheet,
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _go(String route) {
    unawaited(HapticFeedback.selectionClick());
    context.go(route);
  }

  void _openCreateSheet() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _createSheetOpen = true);
  }

  void _closeCreateSheet() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _createSheetOpen = false);
  }

  void _showPausedState() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _activeTab = _DcaTab.plans);
  }

  void _close() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.trade,
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}

class _DcaOverviewCard extends StatelessWidget {
  const _DcaOverviewCard({
    required this.snapshot,
    required this.onCreate,
    required this.onPauseAll,
    required this.onChart,
    required this.onHistory,
  });

  final DcaDashboardSnapshot snapshot;
  final VoidCallback onCreate;
  final VoidCallback onPauseAll;
  final VoidCallback onChart;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    final overview = snapshot.overview;
    final isProfit = overview.profitLossPercent >= 0;
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      background: const VitHeroGlow(center: Alignment(0, -0.96)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng danh mục DCA (VND)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextDim,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.visibility_outlined,
                color: AppColors.portfolioTextMuted,
                size: DcaSpacingTokens.dcaMainInlineIcon,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '₫${_formatFullVnd(overview.currentValueVnd)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.numericDisplayHeroXs.copyWith(
                    fontWeight: AppTextStyles.heavy,
                    height: AppTextStyles.numericDisplayHeroXs.height,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              SizedBox(
                width: DcaSpacingTokens.dcaMainSparklineWidth,
                height: VitDensity.compact.controlHeight,
                child: VitSparkline(
                  values: snapshot.sparkline,
                  color: isProfit ? AppColors.buy : AppColors.sell,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng lãi/lỗ · 90 ngày',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              Flexible(
                child: VitMetricDeltaPill(
                  label:
                      '${isProfit ? '+' : ''}${_formatFullVnd(overview.profitLossVnd.abs())} (${isProfit ? '+' : ''}${_formatPercent(overview.profitLossPercent.abs())})',
                  tone: isProfit
                      ? VitMetricDeltaTone.positive
                      : VitMetricDeltaTone.negative,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  icon: Icons.sync_rounded,
                  label: 'Kế\nhoạch',
                  value: '${overview.totalPlans}',
                  subtitle: '${overview.activePlans} đang chạy',
                  color: AppModuleAccents.dca,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _OverviewMetric(
                  icon: Icons.trending_up_rounded,
                  label: 'Đã đầu\ntư',
                  value: _formatCompactVnd(overview.totalInvestedVnd),
                  subtitle: _formatFullVnd(overview.totalInvestedVnd),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _OverviewMetric(
                  icon: Icons.bar_chart_rounded,
                  label: 'TB/plan',
                  value: _formatCompactVnd(overview.averagePerPlanVnd),
                  subtitle: 'VND / kế hoạch',
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _NextPurchaseRow(overview: overview),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _OverviewAction(
                  key: DCAPage.createPlanKey,
                  icon: Icons.add_rounded,
                  label: 'Tạo mới',
                  color: AppColors.buy,
                  onTap: onCreate,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _OverviewAction(
                  key: DCAPage.pauseAllKey,
                  icon: Icons.pause_rounded,
                  label: 'Tạm dừng',
                  color: AppColors.warn,
                  onTap: onPauseAll,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _OverviewAction(
                  key: DCAPage.chartKey,
                  icon: Icons.bar_chart_rounded,
                  label: 'Biểu đồ',
                  color: AppColors.accent,
                  onTap: onChart,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _OverviewAction(
                  key: DCAPage.historyKey,
                  icon: Icons.format_list_bulleted_rounded,
                  label: 'Lịch sử',
                  color: AppColors.text2,
                  onTap: onHistory,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension:
                    AppSpacing.buttonCompact - AppSpacing.formFieldLabelGap,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: color.withValues(alpha: .15),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                      side: BorderSide(color: color.withValues(alpha: .2)),
                    ),
                  ),
                  child: Icon(icon, color: color, size: AppSpacing.iconSm),
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.portfolioTextDim,
                    fontWeight: AppTextStyles.bold,
                    height: AppTextStyles.badge.height,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.amountXs.copyWith(
              color: color,
              fontWeight: AppTextStyles.heavy,
              height: AppTextStyles.badge.height,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.bold,
              height: AppTextStyles.badge.height,
            ),
          ),
        ],
      ),
    );
  }
}
