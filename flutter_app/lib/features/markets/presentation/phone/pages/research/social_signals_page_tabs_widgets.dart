part of 'social_signals_page.dart';

class _SocialSignalsPageState extends ConsumerState<SocialSignalsPage> {
  String _tab = 'signals';
  TradingSignalStatus? _statusFilter;
  TradingSignalCategory? _categoryFilter;
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    // GD4-F3: getSocialSignals gọi 2 lần trên cùng trang với filter khác
    // nhau — chính = unfiltered (dùng cho tab Nhà cung cấp/Hiệu suất +
    // statusConfigs/tierConfigs dùng chung, giống hệt bản lọc vì cả 2 đều
    // suy ra từ toàn bộ _tradingSignals), phụ = filtered đọc qua .value
    // (mục 5, "2 async song song trên 1 trang" — không lồng 2 skeleton).
    final allAsync = ref.watch(
      marketSocialSignalsSnapshotProvider((
        statusFilter: null,
        categoryFilter: null,
      )),
    );
    final filteredSignals = ref
        .watch(
          marketSocialSignalsSnapshotProvider((
            statusFilter: _statusFilter,
            categoryFilter: _categoryFilter,
          )),
        )
        .value
        ?.signals;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x5 : AppSpacing.x4);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tín hiệu giao dịch',
      semanticIdentifier: 'SC-025',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tín hiệu giao dịch',
            subtitle: 'Tín hiệu · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SocialSignalsTabs(
                activeTab: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: SocialSignalsPage.contentKey,
                    padding: MarketsSpacingTokens.marketScrollPadding(
                      bottomInset,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      density: VitDensity.compact,
                      children: allAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được tín hiệu giao dịch',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              marketSocialSignalsSnapshotProvider((
                                statusFilter: null,
                                categoryFilter: null,
                              )),
                            ),
                          ),
                        ],
                        data: (allSnapshot) {
                          final signals =
                              filteredSignals ?? const <TradingSignalDraft>[];
                          return [
                            const _RiskDisclaimerCard(),
                            if (_tab == 'signals') ...[
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    VitFilterChip(
                                      key: SocialSignalsPage.statusAllKey,
                                      label: 'Tất cả',
                                      active: _statusFilter == null,
                                      onTap: () => setState(() {
                                        _statusFilter = null;
                                      }),
                                      color: AppAssetColors.neutralChain,
                                      padding: MarketsSpacingTokens
                                          .marketSocialFilterPadding
                                          .add(
                                            const EdgeInsetsDirectional.symmetric(
                                              vertical: AppSpacing.x2,
                                            ),
                                          ),
                                    ),
                                    const SizedBox(
                                      width:
                                          MarketsSpacingTokens.marketSocialGap,
                                    ),
                                    VitFilterChip(
                                      key: SocialSignalsPage.statusActiveKey,
                                      label: allSnapshot
                                          .statusConfigs[TradingSignalStatus
                                              .active]!
                                          .label,
                                      active:
                                          _statusFilter ==
                                          TradingSignalStatus.active,
                                      onTap: () => setState(() {
                                        _statusFilter =
                                            TradingSignalStatus.active;
                                      }),
                                      color: allSnapshot
                                          .statusConfigs[TradingSignalStatus
                                              .active]!
                                          .color
                                          .resolve(),
                                      padding: MarketsSpacingTokens
                                          .marketSocialFilterPadding
                                          .add(
                                            const EdgeInsetsDirectional.symmetric(
                                              vertical: AppSpacing.x2,
                                            ),
                                          ),
                                    ),
                                    const SizedBox(
                                      width:
                                          MarketsSpacingTokens.marketSocialGap,
                                    ),
                                    VitFilterChip(
                                      key: SocialSignalsPage.statusTargetHitKey,
                                      label: allSnapshot
                                          .statusConfigs[TradingSignalStatus
                                              .targetHit]!
                                          .label,
                                      active:
                                          _statusFilter ==
                                          TradingSignalStatus.targetHit,
                                      onTap: () => setState(() {
                                        _statusFilter =
                                            TradingSignalStatus.targetHit;
                                      }),
                                      color: allSnapshot
                                          .statusConfigs[TradingSignalStatus
                                              .targetHit]!
                                          .color
                                          .resolve(),
                                      padding: MarketsSpacingTokens
                                          .marketSocialFilterPadding
                                          .add(
                                            const EdgeInsetsDirectional.symmetric(
                                              vertical: AppSpacing.x2,
                                            ),
                                          ),
                                    ),
                                    const SizedBox(
                                      width:
                                          MarketsSpacingTokens.marketSocialGap,
                                    ),
                                    VitFilterChip(
                                      key: SocialSignalsPage.statusStoppedKey,
                                      label: allSnapshot
                                          .statusConfigs[TradingSignalStatus
                                              .stopped]!
                                          .label,
                                      active:
                                          _statusFilter ==
                                          TradingSignalStatus.stopped,
                                      onTap: () => setState(() {
                                        _statusFilter =
                                            TradingSignalStatus.stopped;
                                      }),
                                      color: allSnapshot
                                          .statusConfigs[TradingSignalStatus
                                              .stopped]!
                                          .color
                                          .resolve(),
                                      padding: MarketsSpacingTokens
                                          .marketSocialFilterPadding
                                          .add(
                                            const EdgeInsetsDirectional.symmetric(
                                              vertical: AppSpacing.x2,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    VitFilterChip(
                                      key: SocialSignalsPage.categoryAllKey,
                                      label: 'Tất cả',
                                      active: _categoryFilter == null,
                                      onTap: () => setState(() {
                                        _categoryFilter = null;
                                      }),
                                      color: _marketPrimary,
                                      padding: MarketsSpacingTokens
                                          .marketSocialFilterPadding
                                          .add(
                                            const EdgeInsetsDirectional.symmetric(
                                              vertical: AppSpacing.x2,
                                            ),
                                          ),
                                    ),
                                    const SizedBox(
                                      width:
                                          MarketsSpacingTokens.marketSocialGap,
                                    ),
                                    VitFilterChip(
                                      key: SocialSignalsPage.categoryScalpKey,
                                      label: 'Scalp',
                                      active:
                                          _categoryFilter ==
                                          TradingSignalCategory.scalp,
                                      onTap: () => setState(() {
                                        _categoryFilter =
                                            TradingSignalCategory.scalp;
                                      }),
                                      color: _marketPrimary,
                                      padding: MarketsSpacingTokens
                                          .marketSocialFilterPadding
                                          .add(
                                            const EdgeInsetsDirectional.symmetric(
                                              vertical: AppSpacing.x2,
                                            ),
                                          ),
                                    ),
                                    const SizedBox(
                                      width:
                                          MarketsSpacingTokens.marketSocialGap,
                                    ),
                                    VitFilterChip(
                                      key: SocialSignalsPage.categorySwingKey,
                                      label: 'Swing',
                                      active:
                                          _categoryFilter ==
                                          TradingSignalCategory.swing,
                                      onTap: () => setState(() {
                                        _categoryFilter =
                                            TradingSignalCategory.swing;
                                      }),
                                      color: _marketPrimary,
                                      padding: MarketsSpacingTokens
                                          .marketSocialFilterPadding
                                          .add(
                                            const EdgeInsetsDirectional.symmetric(
                                              vertical: AppSpacing.x2,
                                            ),
                                          ),
                                    ),
                                    const SizedBox(
                                      width:
                                          MarketsSpacingTokens.marketSocialGap,
                                    ),
                                    VitFilterChip(
                                      key:
                                          SocialSignalsPage.categoryPositionKey,
                                      label: 'Position',
                                      active:
                                          _categoryFilter ==
                                          TradingSignalCategory.position,
                                      onTap: () => setState(() {
                                        _categoryFilter =
                                            TradingSignalCategory.position;
                                      }),
                                      color: _marketPrimary,
                                      padding: MarketsSpacingTokens
                                          .marketSocialFilterPadding
                                          .add(
                                            const EdgeInsetsDirectional.symmetric(
                                              vertical: AppSpacing.x2,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (signals.isEmpty)
                                const _SignalsEmptyState()
                              else
                                for (final signal in signals)
                                  _SignalCard(
                                    key: SocialSignalsPage.signalCardKey(
                                      signal.id,
                                    ),
                                    signal: signal,
                                    tierConfig: allSnapshot
                                        .tierConfigs[signal.providerTier]!,
                                    statusConfig: allSnapshot
                                        .statusConfigs[signal.status]!,
                                    expanded: _expandedId == signal.id,
                                    onTap: () => setState(() {
                                      _expandedId = _expandedId == signal.id
                                          ? null
                                          : signal.id;
                                    }),
                                  ),
                            ] else if (_tab == 'providers') ...[
                              for (
                                var index = 0;
                                index < allSnapshot.providers.length;
                                index += 1
                              )
                                _ProviderCard(
                                  key: SocialSignalsPage.providerCardKey(
                                    allSnapshot.providers[index].name,
                                  ),
                                  rank: index + 1,
                                  provider: allSnapshot.providers[index],
                                  tierConfig:
                                      allSnapshot.tierConfigs[allSnapshot
                                          .providers[index]
                                          .tier]!,
                                ),
                            ] else ...[
                              _PerformanceSummary(snapshot: allSnapshot),
                              _StatusBreakdown(snapshot: allSnapshot),
                              const VitSectionHeader(
                                title: 'Kết quả tín hiệu',
                                accentColor: _marketPrimary,
                                bottomGap:
                                    AppSpacing.pageRhythmStandardInnerGap,
                                variant: VitSectionHeaderVariant.accentBar,
                              ),
                              for (final signal
                                  in allSnapshot.signals
                                      .where(
                                        (signal) =>
                                            signal.status !=
                                            TradingSignalStatus.active,
                                      )
                                      .toList()
                                    ..sort(
                                      (a, b) => b.pnlPct.compareTo(a.pnlPct),
                                    ))
                                _SignalResultRow(
                                  signal: signal,
                                  statusConfig:
                                      allSnapshot.statusConfigs[signal.status]!,
                                ),
                            ],
                          ];
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialSignalsTabs extends StatelessWidget {
  const _SocialSignalsTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: VitDensity.compact.controlHeight,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _UnderlinedTab(
                    key: SocialSignalsPage.signalsTabKey,
                    label: 'Tín hiệu',
                    value: 'signals',
                    active: activeTab == 'signals',
                    onChanged: onChanged,
                  ),
                  _UnderlinedTab(
                    key: SocialSignalsPage.providersTabKey,
                    label: 'Nhà cung cấp',
                    value: 'providers',
                    active: activeTab == 'providers',
                    onChanged: onChanged,
                  ),
                  _UnderlinedTab(
                    key: SocialSignalsPage.performanceTabKey,
                    label: 'Hiệu suất',
                    value: 'performance',
                    active: activeTab == 'performance',
                    onChanged: onChanged,
                  ),
                ],
              ),
            ),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlinedTab extends StatelessWidget {
  const _UnderlinedTab({
    super.key,
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final String value;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCard(
        onTap: () => onChanged(value),
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        padding: EdgeInsets.zero,
        borderColor: AppColors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                    height: AppTextStyles.numericMicro.height,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppSpacing.dividerHairline,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: _marketPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskDisclaimerCard extends StatelessWidget {
  const _RiskDisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: MarketsSpacingTokens.marketSocialDisclaimerIconPadding,
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.warn,
              size: AppSpacing.x4,
            ),
          ),
          const SizedBox(width: MarketsSpacingTokens.marketSocialGap),
          Expanded(
            child: Text(
              'Tín hiệu từ cộng đồng chỉ mang tính tham khảo. Không phải khuyến nghị đầu tư. Luôn tự nghiên cứu và quản lý rủi ro.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
