part of '../../phone/pages/hub/p2p_express_page.dart';

class _P2PExpressPageState extends ConsumerState<P2PExpressPage> {
  final TextEditingController _amountController = TextEditingController();
  P2PTradeType _tradeType = P2PTradeType.buy;
  String _asset = 'USDT';
  String _paymentMethod = '';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int get _fiatAmount {
    return int.tryParse(_amountController.text.replaceAll('.', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pExpressProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pExpressVisualNavClearance + _p2pExpressVisualClearance
            : _p2pExpressNativeNavClearance + _p2pExpressNativeClearance) +
        MediaQuery.paddingOf(context).bottom;
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Giao dịch nhanh P2P',
      semanticIdentifier: 'SC-211',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Giao dịch Express',
            subtitle: 'Mua bán nhanh',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2p),
            actions: [
              VitHeaderActionItem(
                key: P2PExpressPage.marketplaceKey,
                type: VitHeaderActionType.portfolio,
                tooltip: 'Marketplace',
                onPressed: () => context.go(AppRoutePaths.p2p),
              ),
            ],
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pExpressProvider),
            ),
            data: (snapshot) {
              final selectedAsset = snapshot.assetBySymbol(_asset);
              final bestAd = snapshot.bestAd(
                tradeType: _tradeType,
                asset: selectedAsset.symbol,
                fiatAmount: _fiatAmount,
                paymentMethod: _paymentMethod,
              );
              final topAds = snapshot.topAds(
                tradeType: _tradeType,
                asset: selectedAsset.symbol,
                fiatAmount: _fiatAmount,
              );
              final cryptoAmount = bestAd == null || _fiatAmount <= 0
                  ? 0.0
                  : _fiatAmount / bestAd.price;
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: VitInsetScrollView(
                  key: P2PExpressPage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  bottomInset: scrollEndPadding,
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      _ExpressHero(tradeType: _tradeType),
                      _ExpressTradeTabs(
                        tradeType: _tradeType,
                        onChanged: _setTradeType,
                      ),
                      _AssetCard(
                        tradeType: _tradeType,
                        selectedAsset: selectedAsset,
                        assets: snapshot.assets,
                        onAssetChanged: _setAsset,
                      ),
                      _AmountCard(
                        controller: _amountController,
                        tradeType: _tradeType,
                        amount: _fiatAmount,
                        bestAd: bestAd,
                        cryptoAmount: cryptoAmount,
                        quickAmounts: snapshot.quickAmountsVnd,
                        onChanged: () => setState(() {}),
                        onQuickAmount: _setAmount,
                      ),
                      _PaymentCard(
                        selectedPayment: _paymentMethod,
                        paymentMethods: snapshot.paymentMethods,
                        onChanged: _setPayment,
                      ),
                      if (_fiatAmount > 0 && bestAd != null)
                        _BestOfferCard(
                          tradeType: _tradeType,
                          ad: bestAd,
                          topOfferCount: topAds.length,
                          marketPrice: selectedAsset.marketPriceVnd,
                          cryptoAmount: cryptoAmount,
                          onMerchant: () => context.go(
                            AppRoutePaths.p2pMerchant(bestAd.merchantId),
                          ),
                          onMarketplace: () => context.go(AppRoutePaths.p2p),
                        ),
                      if (_fiatAmount > 0 && bestAd == null)
                        const _NoOfferCard(),
                      VitCtaButton(
                        key: P2PExpressPage.ctaKey,
                        onPressed: bestAd == null
                            ? null
                            : () => _openConfirm(
                                context,
                                selectedAsset.symbol,
                                bestAd,
                                cryptoAmount,
                              ),
                        variant: _tradeType == P2PTradeType.buy
                            ? VitCtaButtonVariant.success
                            : VitCtaButtonVariant.danger,
                        leading: const Icon(Icons.bolt_outlined),
                        child: Text(
                          '${_tradeType == P2PTradeType.buy ? 'Mua nhanh' : 'Bán nhanh'} ${selectedAsset.symbol}',
                        ),
                      ),
                      _EscrowCard(
                        title: snapshot.escrowTitle,
                        note: _tradeType == P2PTradeType.buy
                            ? snapshot.escrowBuyNote
                            : snapshot.escrowSellNote,
                      ),
                      _HowItWorksCard(steps: snapshot.steps),
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Xem lại trạng thái Express',
                        message:
                            'Phía giao dịch, tài sản, số tiền fiat, ước tính crypto, phương thức thanh toán, chào tốt nhất, ghi chú escrow và trạng thái CTA tắt vẫn hiện trước khi xác nhận.',
                        contractId: 'SC-211',
                        density: VitDensity.compact,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _setTradeType(P2PTradeType value) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _tradeType = value;
      _paymentMethod = '';
    });
  }

  void _setAsset(String value) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _asset = value;
      _paymentMethod = '';
    });
  }

  void _setPayment(String value) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _paymentMethod = _paymentMethod == value ? '' : value);
  }

  void _setAmount(int amount) {
    unawaited(HapticFeedback.selectionClick());
    _amountController.text = amount.toString();
    setState(() {});
  }

  void _openConfirm(
    BuildContext context,
    String asset,
    P2PAdDraft ad,
    double cryptoAmount,
  ) {
    unawaited(HapticFeedback.mediumImpact());
    final params = Uri(
      queryParameters: {
        'type': _tradeType.name,
        'asset': asset,
        'fiat': _fiatAmount.toString(),
        'crypto': cryptoAmount.toString(),
        'adId': ad.id,
        'payment': _paymentMethod.isEmpty
            ? ad.paymentMethods.first
            : _paymentMethod,
      },
    ).query;
    context.go('${AppRoutePaths.p2pExpressConfirm}?$params');
  }
}

class _ExpressHero extends StatelessWidget {
  const _ExpressHero({required this.tradeType});

  final P2PTradeType tradeType;

  @override
  Widget build(BuildContext context) {
    final color = tradeType == P2PTradeType.buy
        ? AppColors.buy
        : AppColors.sell;
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      clip: true,
      padding: P2PSpacingTokens.p2pExpressCompactCardPadding,
      background: const VitHeroGlow(),
      child: Row(
        children: [
          SizedBox.square(
            dimension: _p2pExpressIconBox,
            child: Material(
              color: color.withValues(alpha: .12),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.smRadius,
              ),
              child: Icon(
                Icons.bolt_outlined,
                color: color,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Giao dịch P2P tức thì',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Nhập VND, chọn thanh toán, xác nhận escrow trước khi khớp.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
    );
  }
}

class _ExpressTradeTabs extends StatelessWidget {
  const _ExpressTradeTabs({required this.tradeType, required this.onChanged});

  final P2PTradeType tradeType;
  final ValueChanged<P2PTradeType> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice<P2PTradeType>(
      selected: tradeType,
      onChanged: onChanged,
      height: _p2pExpressToggleHeight,
      borderRadius: AppRadii.lgRadius,
      options: const [
        VitSegmentedChoiceOption(
          key: P2PExpressPage.buyToggleKey,
          value: P2PTradeType.buy,
          label: 'MUA NHANH',
          accentColor: AppColors.buy,
          leading: Icon(Icons.bolt_outlined),
          semanticLabel: 'Chọn mua nhanh P2P Express',
        ),
        VitSegmentedChoiceOption(
          key: P2PExpressPage.sellToggleKey,
          value: P2PTradeType.sell,
          label: 'BÁN NHANH',
          accentColor: AppColors.sell,
          leading: Icon(Icons.bolt_outlined),
          semanticLabel: 'Chọn bán nhanh P2P Express',
        ),
      ],
    );
  }
}

class _AssetCard extends StatelessWidget {
  const _AssetCard({
    required this.tradeType,
    required this.selectedAsset,
    required this.assets,
    required this.onAssetChanged,
  });

  final P2PTradeType tradeType;
  final P2PAssetDraft selectedAsset;
  final List<P2PAssetDraft> assets;
  final ValueChanged<String> onAssetChanged;

  @override
  Widget build(BuildContext context) {
    final color = tradeType == P2PTradeType.buy
        ? AppColors.buy
        : AppColors.sell;
    return VitCard(
      padding: P2PSpacingTokens.p2pExpressCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tradeType == P2PTradeType.buy
                      ? 'Tôi muốn mua'
                      : 'Tôi muốn bán',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Chọn tài sản',
                color: AppColors.surface2,
                onSelected: onAssetChanged,
                itemBuilder: (context) => [
                  for (final asset in assets)
                    PopupMenuItem<String>(
                      value: asset.symbol,
                      child: Text('${asset.symbol} - ${asset.name}'),
                    ),
                ],
                child: Material(
                  color: AppColors.surface2,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.inputRadius,
                    side: BorderSide(color: AppColors.borderSolid),
                  ),
                  child: Padding(
                    padding: P2PSpacingTokens.p2pExpressSelectorPadding,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _AssetMark(symbol: selectedAsset.symbol, color: color),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          selectedAsset.symbol,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        const Icon(
                          Icons.expand_more,
                          color: AppColors.text3,
                          size: AppSpacing.iconSm,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _p2pExpressTightGap),
          Material(
            color: AppColors.surface2,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
            ),
            child: Padding(
              padding: P2PSpacingTokens.p2pExpressSelectorPadding,
              child: Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Giá thị trường:',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    _formatVnd(selectedAsset.marketPriceVnd),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Expanded(
                    child: Text(
                      'VND/${selectedAsset.symbol}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
