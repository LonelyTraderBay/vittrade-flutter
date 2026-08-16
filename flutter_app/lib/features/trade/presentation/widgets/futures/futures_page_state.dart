part of '../../phone/pages/futures/futures_page.dart';

class _FuturesPageState extends ConsumerState<FuturesPage> {
  final _marginController = TextEditingController();
  TradeFuturesSide _side = TradeFuturesSide.long;
  final int _leverage = 10;

  @override
  void dispose() {
    _marginController.dispose();
    super.dispose();
  }

  void _setPercent(int pct, double availableBalance) {
    final value = availableBalance * pct / 100;
    setState(() {
      _marginController.text = value.toStringAsFixed(0);
    });
  }

  TradeFuturesOrderControllerRequest get _orderRequest {
    final margin = double.tryParse(_marginController.text) ?? 0;
    return (
      pairId: widget.pairId,
      draft: TradeFuturesOrderDraft(
        pairId: widget.pairId,
        side: _side,
        type: TradeFuturesOrderType.market,
        margin: margin,
        leverage: _leverage,
      ),
    );
  }

  Future<void> _submit() async {
    final request = _orderRequest;
    final provider = tradeFuturesOrderControllerProvider(request);
    final notifier = ref.read(provider.notifier);
    if (!notifier.canSubmit) return;
    await notifier.submit();
    if (!mounted) return;
    final orderState = ref.read(provider);
    if (orderState.status == TradeHighRiskFlowStatus.success) {
      // Clear form trước khi mở sheet — request thay đổi khi margin xoá
      // nên Notifier cũ sẽ dispose sau khi sheet đóng, không race.
      setState(() => _marginController.clear());
      final orderId = orderState.receipt?.orderId ?? 'lệnh';
      await showVitNoticeSheet(
        context: context,
        title: 'Đã gửi lệnh',
        message: 'Đã gửi $orderId',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      );
      return;
    }
    await showVitNoticeSheet(
      context: context,
      title: 'Gửi lệnh thất bại',
      message:
          orderState.errorMessage ?? 'Không gửi được lệnh. Vui lòng thử lại.',
      variant: VitBannerVariant.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final futuresAsync = ref.watch(tradeFuturesProvider(widget.pairId));
    return futuresAsync.when(
      loading: () => const VitSkeletonList(),
      error: (error, stackTrace) => VitErrorState(
        title: 'Không tải được màn hình futures',
        message: 'Vui lòng kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: () => ref.invalidate(tradeFuturesProvider(widget.pairId)),
      ),
      data: _buildContent,
    );
  }

  Widget _buildContent(TradeFuturesSnapshot snapshot) {
    final orderRequest = _orderRequest;
    final orderState = ref.watch(
      tradeFuturesOrderControllerProvider(orderRequest),
    );
    final orderNotifier = ref.read(
      tradeFuturesOrderControllerProvider(orderRequest).notifier,
    );
    final pair = snapshot.pair;
    final daySnapshot = tradeSyntheticDaySnapshot(pair.price, pair.changePct);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    // Banner nằm trong scroll content (sau product tabs do
    // tradeShellWithProductTabs prepend) — không overlay Stack/Positioned
    // lên header/tab Spot·Futures·Margin.
    return VitTradeSimpleShell(
      title: pair.symbol,
      subtitle: 'Hợp đồng tương lai',
      semanticLabel: 'Giao dịch hợp đồng tương lai (Futures)',
      semanticIdentifier: 'SC-057',
      contentKey: const Key('sc057_futures_scroll_content'),
      shellRenderMode: mode,
      showBack: true,
      backKey: FuturesPage.closeKey,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradePair(widget.pairId),
        mode: BackNavigationMode.historyThenFallback,
      ),
      activeProductId: 'futures',
      productPair: pair,
      quickNavKey: FuturesPage.quickNavKey,
      children: [
        VitTradeSimpleHero(
          symbol: pair.symbol,
          priceLabel: formatTradePrice(pair.price),
          changePct: pair.changePct,
          sparklineValues: daySnapshot.sparkline,
          highLabel: daySnapshot.highLabel,
          lowLabel: daySnapshot.lowLabel,
          volumeLabel: daySnapshot.volumeLabel,
          availableBalanceLabel:
              '${formatTradeMoney(snapshot.accountBalance - snapshot.usedMargin)} USDT',
        ),
        VitTradeSection(
          title: 'Giao dịch',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VitHighRiskStatePanel(
                state: orderState.status.uiState,
                density: VitDensity.tool,
                title: switch (orderState.status.uiState) {
                  VitHighRiskUiState.submitting => 'Đang gửi lệnh',
                  VitHighRiskUiState.success => 'Đã gửi lệnh',
                  VitHighRiskUiState.error => 'Gửi lệnh thất bại',
                  VitHighRiskUiState.offline => 'Mất kết nối',
                  _ => 'Rủi ro cao',
                },
                message: switch (orderState.status.uiState) {
                  VitHighRiskUiState.submitting =>
                    'Đang gửi lệnh tới sàn. Vui lòng chờ trong giây lát.',
                  VitHighRiskUiState.success =>
                    'Đã gửi ${orderState.receipt?.orderId ?? 'lệnh'}.',
                  VitHighRiskUiState.error || VitHighRiskUiState.offline =>
                    orderState.errorMessage ??
                        'Không gửi được lệnh. Vui lòng thử lại.',
                  _ =>
                    'Hợp đồng tương lai có thể làm bạn mất toàn bộ ký quỹ. Chỉ dùng số tiền bạn chấp nhận mất.',
                },
                contractId: snapshot.highRiskContractId,
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              _FuturesSimpleForm(
                snapshot: snapshot,
                preview: orderState.preview,
                submitting: orderState.status.isBusy,
                side: _side,
                leverage: _leverage,
                marginController: _marginController,
                onSideChanged: (side) => setState(() => _side = side),
                onPercent: (pct) => _setPercent(
                  pct,
                  snapshot.accountBalance - snapshot.usedMargin,
                ),
                onChanged: () => setState(() {}),
                onPreviewOpened: orderNotifier.enterPreview,
                onPreviewDismissed: orderNotifier.cancelPreview,
                onConfirmedSubmit: _submit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FuturesSimpleForm extends StatelessWidget {
  const _FuturesSimpleForm({
    required this.snapshot,
    required this.preview,
    required this.submitting,
    required this.side,
    required this.leverage,
    required this.marginController,
    required this.onSideChanged,
    required this.onPercent,
    required this.onChanged,
    required this.onPreviewOpened,
    required this.onPreviewDismissed,
    required this.onConfirmedSubmit,
  });

  final TradeFuturesSnapshot snapshot;

  /// Preview từ CÙNG family member mà trang watch — form không tự watch để
  /// tránh hai member khác nhau khi record draft lệch một field.
  final TradeFuturesPreview preview;
  final bool submitting;
  final TradeFuturesSide side;
  final int leverage;
  final TextEditingController marginController;
  final ValueChanged<TradeFuturesSide> onSideChanged;
  final ValueChanged<int> onPercent;
  final VoidCallback onChanged;
  final VoidCallback onPreviewOpened;
  final VoidCallback onPreviewDismissed;
  final VoidCallback onConfirmedSubmit;

  Future<void> _openConfirm(
    BuildContext context,
    TradeFuturesPreview preview,
  ) async {
    if (!preview.canOpen || submitting) return;
    onPreviewOpened();
    final sideLabel = side == TradeFuturesSide.long ? 'Giá tăng' : 'Giá giảm';
    final confirmed = await showVitTradeConfirmSheet(
      context: context,
      title: 'Xem lại hợp đồng',
      lines: [
        VitTradeConfirmLine(label: 'Cặp', value: snapshot.pair.symbol),
        VitTradeConfirmLine(label: 'Hướng', value: sideLabel),
        VitTradeConfirmLine(label: 'Đòn bẩy', value: '${leverage}x'),
        VitTradeConfirmLine(
          label: 'Ký quỹ',
          value: '${marginController.text} USDT',
        ),
        VitTradeConfirmLine(
          label: 'Quy mô vị thế',
          value: formatTradeMoney(preview.positionSize),
        ),
        VitTradeConfirmLine(
          label: 'Giá thanh lý',
          value: formatTradePrice(preview.liquidationPrice),
        ),
      ],
      riskMessage:
          'Hợp đồng tương lai có rủi ro cao. Bạn có thể mất toàn bộ ký quỹ.',
    );
    if (!context.mounted) return;
    if (confirmed) {
      onConfirmedSubmit();
    } else {
      onPreviewDismissed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final margin = double.tryParse(marginController.text) ?? 0;

    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Bước 1 · Chọn hướng',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitSegmentedChoice<TradeFuturesSide>(
            selected: side,
            onChanged: onSideChanged,
            options: [
              VitSegmentedChoiceOption(
                key: FuturesPage.sideKey('long'),
                value: TradeFuturesSide.long,
                label: 'Giá tăng',
                accentColor: _futuresGreen,
                leading: const Icon(Icons.trending_up_rounded),
              ),
              VitSegmentedChoiceOption(
                key: FuturesPage.sideKey('short'),
                value: TradeFuturesSide.short,
                label: 'Giá giảm',
                accentColor: _futuresRed,
                leading: const Icon(Icons.trending_down_rounded),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Đòn bẩy ${leverage}x',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Bước 2 · Số tiền ký quỹ',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _MarginInput(controller: marginController, onChanged: onChanged),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _PercentRow(onPercent: onPercent),
          if (margin > 0) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            _PreviewCard(pair: snapshot.pair, preview: preview),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            key: FuturesPage.submitKey,
            onPressed: preview.canOpen && !submitting
                ? () => _openConfirm(context, preview)
                : null,
            loading: submitting,
            density: VitDensity.tool,
            variant: side == TradeFuturesSide.long
                ? VitCtaButtonVariant.success
                : VitCtaButtonVariant.danger,
            child: Text(
              submitting
                  ? 'Đang gửi lệnh…'
                  : preview.canOpen
                  ? 'Xem lại & xác nhận'
                  : 'Nhập ký quỹ để tiếp tục',
            ),
          ),
        ],
      ),
    );
  }
}
