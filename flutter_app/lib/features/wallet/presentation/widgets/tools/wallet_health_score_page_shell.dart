part of '../../phone/pages/tools/wallet_health_score_page.dart';

class _WalletHealthScorePageState extends ConsumerState<WalletHealthScorePage> {
  String _tab = _tabOverview;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletHealthScoreProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding = _healthScrollBottomInset(context, mode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Điểm sức khỏe ví - tổng quan, bảo mật và đa dạng hóa',
      semanticIdentifier: 'SC-151',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Wallet Health',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VitInsetScrollView(
                  key: WalletHealthScorePage.contentKey,
                  bottomInset: scrollEndPadding,
                  physics: const ClampingScrollPhysics(),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    gap: VitContentGap.tight,
                    children: [
                      ...snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được điểm sức khỏe ví',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(walletHealthScoreProvider),
                          ),
                        ],
                        data: (snapshot) {
                          final primaryRecommendation =
                              snapshot.priorityRecommendations.isEmpty
                              ? null
                              : snapshot.priorityRecommendations.first;
                          return [
                            _OverallScoreCard(snapshot: snapshot),
                            if (primaryRecommendation != null)
                              _RecommendationCard(
                                recommendation: primaryRecommendation,
                                onTap: () => _showRecommendationSheet(
                                  primaryRecommendation,
                                ),
                              )
                            else
                              const VitEmptyState(
                                title: 'No priority recommendations',
                                message:
                                    'Wallet health actions will appear here when needed.',
                              ),
                            _HealthTabs(
                              activeTab: _tab,
                              onChanged: (tab) => setState(() => _tab = tab),
                            ),
                            ..._tabSectionChildren(
                              snapshot,
                              primaryRecommendationId:
                                  primaryRecommendation?.id,
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _tabSectionChildren(
    WalletHealthScoreSnapshot snapshot, {
    String? primaryRecommendationId,
  }) {
    if (_tab == _tabSecurity) {
      return _SecurityTab(snapshot: snapshot).sectionChildren;
    }
    if (_tab == _tabDiversification) {
      return _DiversificationTab(snapshot: snapshot).sectionChildren;
    }
    return _OverviewTab(
      snapshot: snapshot,
      primaryRecommendationId: primaryRecommendationId,
      onRecommendationTap: _showRecommendationSheet,
    ).sectionChildren;
  }

  void _showRecommendationSheet(WalletHealthRecommendation recommendation) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: _healthPanel,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.sheetTopRadius,
        ),
        builder: (context) {
          return VitSheetPanel(
            title: recommendation.actionLabel,
            child: VitPageContent(
              padding: VitContentPadding.none,
              gap: VitContentGap.tight,
              density: VitDensity.compact,
              children: [
                VitStatusPill(
                  label: '${recommendation.impact} impact advisory',
                  status: VitStatusPillStatus.warning,
                  size: VitStatusPillSize.sm,
                ),
                Text(
                  recommendation.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                Text(
                  'This is an advisory health signal, not financial advice. Review account settings and live risk before taking action.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1.32,
                  ),
                ),
                VitCtaButton(
                  key: WalletHealthScorePage.sheetCloseKey,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HealthTabs extends StatelessWidget {
  const _HealthTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      tabs: [
        for (final tab in const [
          _tabOverview,
          _tabSecurity,
          _tabDiversification,
        ])
          VitTabItem(
            key: tab,
            label: tab,
            icon: switch (tab) {
              _tabOverview => Icons.health_and_safety_outlined,
              _tabSecurity => Icons.shield_outlined,
              _ => Icons.donut_large_rounded,
            },
            widgetKey: WalletHealthScorePage.tabKey(tab),
          ),
      ],
      activeKey: activeTab,
      onChanged: onChanged,
      variant: VitTabBarVariant.segment,
    );
  }
}
