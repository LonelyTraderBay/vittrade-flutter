part of '../../phone/pages/hub/p2p_home_page.dart';

class _P2PHomePageState extends ConsumerState<P2PHomePage> {
  final TextEditingController _searchController = TextEditingController();
  P2PTradeType _tradeType = P2PTradeType.buy;
  String _asset = 'USDT';
  String _fiat = 'VND';
  String _query = '';
  bool _filtersOpen = false;
  String _merchantFilter = 'all';
  String _paymentFilter = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      p2pHomeProvider((tradeType: _tradeType, asset: _asset, fiat: _fiat)),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pHomeVisualNavClearance + _p2pHomeVisualClearance
            : _p2pHomeNativeNavClearance + _p2pHomeNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trang chủ giao dịch P2P',
      semanticIdentifier: 'SC-282',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.home),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.home),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                p2pHomeProvider((
                  tradeType: _tradeType,
                  asset: _asset,
                  fiat: _fiat,
                )),
              ),
            ),
          ),
          data: (snapshot) {
            final ads = _filteredAds(snapshot.ads);
            final showOfflineWithCache =
                snapshot.currentState == P2PScreenState.offline &&
                snapshot.ads.isNotEmpty;
            final offlineDetail = snapshot.lastUpdatedLabel.isEmpty
                ? 'C\u1EADp nh\u1EADt l\u1EA7n cu\u1ED1i: d\u1EEF li\u1EC7u g\u1EA7n nh\u1EA5t'
                : 'C\u1EADp nh\u1EADt l\u1EA7n cu\u1ED1i: ${snapshot.lastUpdatedLabel}';

            return VitAutoHideHeaderScaffold(
              header: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox.shrink() /*
                key: P2PHomePage.offlineKey,
                padding: P2PSpacingTokens.p2pHomeOfflinePadding,
                child: const SizedBox.shrink(
                  message: 'Mất kết nối. Đang hiển thị dữ liệu gần nhất.',
                  detail: 'Cập nhật lần cuối: 2 phút trước',
                ),
              ),
              */,
                  VitTopChrome(
                    type: VitTopChromeType.rootModule,
                    title: snapshot.title,
                    subtitle: snapshot.subtitle,
                    showBack: true,
                    onBack: () => context.go(AppRoutePaths.home),
                    actions: [
                      VitHeaderActionItem(
                        key: P2PHomePage.createKey,
                        type: VitHeaderActionType.add,
                        tooltip: 'Tạo tin',
                        onPressed: () => context.go(snapshot.createRoute),
                      ),
                      VitHeaderActionItem(
                        key: P2PHomePage.myOrdersKey,
                        type: VitHeaderActionType.history,
                        tooltip: 'Đơn của tôi',
                        onPressed: () => context.go(snapshot.myOrdersRoute),
                      ),
                      VitHeaderActionItem(
                        key: P2PHomePage.toolsKey,
                        type: VitHeaderActionType.more,
                        tooltip: 'Công cụ',
                        onPressed: _showToolsSheet,
                      ),
                    ],
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: P2PHomePage.contentKey,
                        physics: const ClampingScrollPhysics(),
                        padding: P2PSpacingTokens.p2pHomeScrollPadding(
                          scrollEndPadding,
                        ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          gap: VitContentGap.tight,
                          children: [
                            if (snapshot.highRiskContractId != null)
                              VitHighRiskStatePanel(
                                state: VitHighRiskUiState.riskReview,
                                title: 'Ký quỹ escrow đang bảo vệ P2P',
                                message:
                                    'Tin đăng, tạo đơn, bằng chứng thanh toán và tranh chấp được theo dõi trong cùng hợp đồng escrow. '
                                    'Không hoàn tác sau khi xác nhận thanh toán. '
                                    'Bước tiếp theo: giữ tiền trong ký quỹ đến khi hai bên hoàn tất hoặc mở tranh chấp.',
                                contractId: snapshot.highRiskContractId,
                              ),
                            if (showOfflineWithCache) ...[
                              Padding(
                                key: P2PHomePage.offlineKey,
                                padding: P2PSpacingTokens.p2pHomeOfflinePadding,
                                child: VitOfflineBanner(
                                  message:
                                      'M\u1EA5t k\u1EBFt n\u1ED1i. \u0110ang hi\u1EC3n th\u1ECB d\u1EEF li\u1EC7u g\u1EA7n nh\u1EA5t.',
                                  detail: offlineDetail,
                                ),
                              ),
                            ],
                            _KycComplianceBanner(snapshot: snapshot),
                            _QuickHub(snapshot: snapshot),
                            _AssetFiatRail(
                              snapshot: snapshot,
                              selectedAsset: _asset,
                              selectedFiat: _fiat,
                              onAsset: (value) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _asset = value);
                              },
                              onFiat: (value) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _fiat = value);
                              },
                            ),
                            _TradeTabs(
                              active: _tradeType,
                              onChanged: (value) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _tradeType = value);
                              },
                            ),
                            VitSearchBar(
                              key: P2PHomePage.searchKey,
                              controller: _searchController,
                              placeholder: snapshot.searchHint,
                              variant: VitSearchBarVariant.compact,
                              filterActive: _filtersOpen,
                              onFilterTap: () {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _filtersOpen = !_filtersOpen);
                              },
                              onChanged: (value) =>
                                  setState(() => _query = value),
                            ),
                            if (_filtersOpen) ...[
                              _HomeFilterSection(
                                merchantFilter: _merchantFilter,
                                paymentFilter: _paymentFilter,
                                paymentMethods: _paymentMethods(snapshot.ads),
                                onMerchant: (value) =>
                                    setState(() => _merchantFilter = value),
                                onPayment: (value) =>
                                    setState(() => _paymentFilter = value),
                                onClear: () => setState(() {
                                  _merchantFilter = 'all';
                                  _paymentFilter = '';
                                }),
                              ),
                            ],
                            _ResultsHeader(count: ads.length),
                            if (ads.isEmpty)
                              _EmptyOffers(snapshot: snapshot)
                            else
                              for (final ad in ads)
                                _OfferCard(
                                  ad: ad,
                                  tradeType: _tradeType,
                                  onOpen: () =>
                                      context.go(AppRoutePaths.p2pAd(ad.id)),
                                  onMerchant: () => context.go(
                                    AppRoutePaths.p2pMerchant(ad.merchantId),
                                  ),
                                  onReport: () => context.go(
                                    AppRoutePaths.p2pReport(ad.merchantId),
                                  ),
                                ),
                            Padding(
                              key: P2PHomePage.escrowDisclaimerKey,
                              padding: const EdgeInsetsDirectional.only(
                                top: AppSpacing.x2,
                              ),
                              child: Text(
                                snapshot.contractNotes,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<P2PAdDraft> _filteredAds(List<P2PAdDraft> ads) {
    final query = _query.trim().toLowerCase();
    return ads.where((ad) {
      if (query.isNotEmpty && !ad.merchant.toLowerCase().contains(query)) {
        return false;
      }
      if (_paymentFilter.isNotEmpty &&
          !ad.paymentMethods.contains(_paymentFilter)) {
        return false;
      }
      if (_merchantFilter == 'elite' && ad.merchantBadge != 'elite') {
        return false;
      }
      if (_merchantFilter == 'pro' && ad.merchantBadge != 'pro') {
        return false;
      }
      if (_merchantFilter == 'verified' && !ad.merchantVerified) {
        return false;
      }
      return true;
    }).toList();
  }

  void _showToolsSheet() {
    final rootContext = context;
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.bg,
        builder: (sheetContext) {
          return _P2PHomeToolsSheet(
            onNavigate: (route) {
              Navigator.of(sheetContext).pop();
              rootContext.go(route);
            },
          );
        },
      ),
    );
  }

  List<String> _paymentMethods(List<P2PAdDraft> ads) {
    final methods = <String>{};
    for (final ad in ads) {
      methods.addAll(ad.paymentMethods);
    }
    return methods.toList();
  }
}

class _KycComplianceBanner extends StatelessWidget {
  const _KycComplianceBanner({required this.snapshot});

  final P2PHomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PHomePage.kycBannerKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitBanner(
          variant: VitBannerVariant.warning,
          icon: Icons.verified_user_outlined,
          message: 'P2P yêu cầu xác minh KYC trước khi giao dịch',
          detail: 'Hoàn tất xác minh để mua/bán an toàn qua Escrow.',
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCtaButton(
          onPressed: () => context.go(snapshot.tradingLevelRoute),
          variant: VitCtaButtonVariant.secondary,
          fullWidth: true,
          height: AppSpacing.buttonCompact,
          child: const Text('Xác minh KYC'),
        ),
      ],
    );
  }
}

class _QuickHub extends StatelessWidget {
  const _QuickHub({required this.snapshot});

  final P2PHomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.platformStats;
    return VitCard(
      key: P2PHomePage.quickHubKey,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.p2p.withValues(alpha: .22),
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const VitAccentIconBox(
                icon: Icons.shield_outlined,
                color: AppModuleAccents.p2p,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ký quỹ escrow bảo vệ giao dịch',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Thao tác nhanh',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const VitStatusPill(
                label: 'Escrow',
                status: VitStatusPillStatus.success,
                icon: Icons.lock_outline_rounded,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _HubStat(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Escrow',
                  value: _compactVnd(stats.escrowProtected),
                  caption: 'đang bảo vệ',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HubStat(
                  icon: Icons.trending_up_rounded,
                  label: 'Hoàn tất',
                  value: '${stats.avgCompletionRate.toStringAsFixed(1)}%',
                  caption: stats.avgCompletionTime,
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              for (
                var index = 0;
                index < snapshot.quickActions.length;
                index++
              ) ...[
                Expanded(
                  child: VitCtaButton(
                    key: P2PHomePage.actionKey(snapshot.quickActions[index].id),
                    onPressed: () =>
                        context.go(snapshot.quickActions[index].route),
                    variant: snapshot.quickActions[index].toneKey == 'buy'
                        ? VitCtaButtonVariant.success
                        : VitCtaButtonVariant.primary,
                    fullWidth: true,
                    height: AppSpacing.buttonCompact,
                    leading: Icon(
                      snapshot.quickActions[index].iconKey == 'bolt'
                          ? Icons.bolt_rounded
                          : Icons.add_rounded,
                      size: AppSpacing.iconSm,
                    ),
                    child: Text(snapshot.quickActions[index].title),
                  ),
                ),
                if (index != snapshot.quickActions.length - 1)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TradeTabs extends StatelessWidget {
  const _TradeTabs({required this.active, required this.onChanged});

  final P2PTradeType active;
  final ValueChanged<P2PTradeType> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice<P2PTradeType>(
      key: P2PHomePage.tradeTabsKey,
      selected: active,
      onChanged: onChanged,
      height: AppSpacing.buttonCompact,
      borderRadius: AppRadii.lgRadius,
      options: [
        VitSegmentedChoiceOption(
          key: P2PHomePage.tradeTabKey(P2PTradeType.buy),
          value: P2PTradeType.buy,
          label: 'MUA',
          accentColor: AppColors.buy,
          semanticLabel: 'Chọn mua P2P',
        ),
        VitSegmentedChoiceOption(
          key: P2PHomePage.tradeTabKey(P2PTradeType.sell),
          value: P2PTradeType.sell,
          label: 'BÁN',
          accentColor: AppColors.sell,
          semanticLabel: 'Chọn bán P2P',
        ),
      ],
    );
  }
}

class _AssetFiatRail extends StatelessWidget {
  const _AssetFiatRail({
    required this.snapshot,
    required this.selectedAsset,
    required this.selectedFiat,
    required this.onAsset,
    required this.onFiat,
  });

  final P2PHomeSnapshot snapshot;
  final String selectedAsset;
  final String selectedFiat;
  final ValueChanged<String> onAsset;
  final ValueChanged<String> onFiat;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: P2PHomePage.assetRailKey,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Row(
              children: [
                for (final asset in snapshot.assets) ...[
                  VitChoicePill(
                    key: P2PHomePage.assetKey(asset),
                    label: asset,
                    selected: asset == selectedAsset,
                    onTap: () => onAsset(asset),
                    padding: _p2pHomeFilterChipPadding,
                    accentColor: AppModuleAccents.p2p,
                    semanticLabel: 'Bộ lọc P2P $asset',
                  ),
                  const SizedBox(width: AppSpacing.x2),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        for (final fiat in snapshot.fiatCurrencies) ...[
          VitChoicePill(
            key: P2PHomePage.fiatKey(fiat),
            label: fiat,
            selected: fiat == selectedFiat,
            onTap: () => onFiat(fiat),
            padding: _p2pHomeFilterChipPadding,
            accentColor: AppModuleAccents.p2p,
            semanticLabel: 'Bộ lọc P2P $fiat',
          ),
          const SizedBox(width: AppSpacing.x1),
        ],
      ],
    );
  }
}
