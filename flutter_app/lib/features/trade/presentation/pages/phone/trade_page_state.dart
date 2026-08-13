part of 'trade_page.dart';

class _TradePageState extends ConsumerState<TradePage> {
  late TradeOrderSide _side;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _side = widget.initialSide;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder(TradeOrderControllerRequest request) async {
    final provider = tradeOrderControllerProvider(request);
    await ref.read(provider.notifier).submit();
    if (!mounted) return;
    final orderState = ref.read(provider);
    if (orderState.status == TradeHighRiskFlowStatus.success) {
      final orderId = orderState.receipt?.orderId ?? 'lệnh';
      context.go(AppRoutePaths.tradeOrderReceipt);
      if (!context.mounted) return;
      await showVitNoticeSheet(
        context: context,
        title: 'Lệnh đã gửi',
        message: 'Đã gửi $orderId',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
        ctaLabel: 'Tiếp tục giao dịch',
        primaryKey: OrderReceiptPage.continueTradingKey,
        secondaryLabel: 'Chia sẻ',
        secondaryPressedLabel: 'Đã chia sẻ',
        secondaryKey: OrderReceiptPage.shareKey,
        onPrimary: () {
          context.go(AppRoutePaths.tradePair('btcusdt'));
        },
      );
      return;
    }
    // Nhánh error/offline: ở lại trang, panel rủi ro hiển thị trạng thái;
    // sheet thông báo cho phép người dùng biết ngay lý do.
    await showVitNoticeSheet(
      context: context,
      title: 'Gửi lệnh thất bại',
      message:
          orderState.errorMessage ?? 'Không gửi được lệnh. Vui lòng thử lại.',
      variant: VitBannerVariant.error,
    );
  }

  _TradeNextAction _resolveNextAction(TradeScreenSnapshot snapshot) {
    if (snapshot.orders.isNotEmpty) {
      return _TradeNextAction(
        icon: Icons.pending_actions_outlined,
        title: 'Hoàn tất lệnh đang chờ',
        subtitle: 'Bạn có ${snapshot.orders.length} lệnh mở cần theo dõi',
        statusLabel: 'Lệnh mở',
        ctaLabel: 'Xem lệnh',
        onTap: () => context.push(AppRoutePaths.tradeOrdersHistory),
      );
    }
    if (snapshot.positions.isEmpty) {
      return _TradeNextAction(
        icon: Icons.play_circle_outline_rounded,
        title: 'Bắt đầu giao dịch đầu tiên',
        subtitle: 'Chọn MUA hoặc BÁN, nhập số lượng và xác nhận',
        statusLabel: 'Mới',
        ctaLabel: 'Bắt đầu',
        onTap: () {
          unawaited(HapticFeedback.selectionClick());
          unawaited(
            showVitNoticeSheet(
              context: context,
              title: 'Bắt đầu giao dịch',
              message: 'Tính năng bắt đầu giao dịch sẽ sớm ra mắt',
            ),
          );
        },
      );
    }
    return _TradeNextAction(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Theo dõi tài sản Spot',
      subtitle: 'Bạn đang giữ ${snapshot.positions.length} vị thế',
      statusLabel: 'Vị thế',
      ctaLabel: 'Xem',
      onTap: () => context.push(AppRoutePaths.tradePositions),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenAsync = ref.watch(tradeScreenProvider(widget.pairId));
    return screenAsync.when(
      loading: () => const VitSkeletonList(),
      error: (error, stackTrace) => VitErrorState(
        title: 'Không tải được màn hình giao dịch',
        message: 'Vui lòng kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: () => ref.invalidate(tradeScreenProvider(widget.pairId)),
      ),
      data: _buildContent,
    );
  }

  Widget _buildContent(TradeScreenSnapshot snapshot) {
    final pair = snapshot.pair;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final amount = double.tryParse(_amountController.text) ?? 0;
    final draft = TradeOrderDraft(
      pairId: pair.id,
      side: _side,
      type: TradeOrderType.market,
      price: pair.price,
      amount: amount,
    );
    final orderRequest = (pairId: widget.pairId, draft: draft);
    final orderState = ref.watch(tradeOrderControllerProvider(orderRequest));
    final orderNotifier = ref.read(
      tradeOrderControllerProvider(orderRequest).notifier,
    );
    final preview = orderState.preview;
    final canSubmit = orderNotifier.canSubmit;
    final submitting = orderState.status.isBusy;
    final showBack =
        widget.chartVariant == TradeChartVariant.pairRoute || context.canPop();
    final marketPrice = formatTradePrice(pair.price);
    final daySnapshot = tradeSyntheticDaySnapshot(pair.price, pair.changePct);
    final nextAction = _resolveNextAction(snapshot);
    final availableBalanceLabel = _side == TradeOrderSide.buy
        ? '${formatTradeMoney(snapshot.balances.usdtAvailable)} USDT'
        : '${formatTradeMoney(snapshot.balances.baseAvailable)} ${pair.baseAsset}';

    return VitTradeSimpleShell(
      title: pair.symbol,
      subtitle: 'Giao dịch Spot',
      semanticLabel: 'Giao dịch Spot',
      semanticIdentifier: 'SC-048',
      contentKey: TradePage.contentKey,
      shellRenderMode: mode,
      showBack: showBack,
      backKey: TradePage.backKey,
      onBack: showBack
          ? () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.trade,
              mode: BackNavigationMode.historyThenFallback,
            )
          : null,
      // STEP-P2.4 / D5: persistent Lệnh + Vị thế (EP-26 / EP-27).
      headerActions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.history,
          size: VitHeaderActionSize.sm,
          tooltip: 'Lệnh',
          onPressed: () => context.push(AppRoutePaths.tradeOrdersHistory),
        ),
        VitHeaderActionItem(
          type: VitHeaderActionType.portfolio,
          size: VitHeaderActionSize.sm,
          tooltip: 'Vị thế',
          onPressed: () => context.push(AppRoutePaths.tradePositions),
        ),
      ],
      activeProductId: 'spot',
      productPair: pair,
      quickNavKey: TradePage.quickNavKey,
      children: [
        VitTradeSimpleHero(
          symbol: pair.symbol,
          priceLabel: marketPrice,
          changePct: pair.changePct,
          sparklineValues: daySnapshot.sparkline,
          highLabel: daySnapshot.highLabel,
          lowLabel: daySnapshot.lowLabel,
          volumeLabel: daySnapshot.volumeLabel,
          availableBalanceLabel: availableBalanceLabel,
        ),
        VitTradeSimpleOrderForm(
          side: _side,
          pair: pair,
          balances: snapshot.balances,
          amountController: _amountController,
          preview: preview,
          canSubmit: canSubmit,
          marketPriceLabel: marketPrice,
          buyKey: TradePage.buySideKey,
          sellKey: TradePage.sellSideKey,
          amountFieldKey: TradePage.amountFieldKey,
          submitKey: TradePage.submitKey,
          pctKeyBuilder: TradePage.pctKey,
          onSideChanged: (side) => setState(() => _side = side),
          onPct: (pct) => setState(() {
            final available = _side == TradeOrderSide.buy
                ? snapshot.balances.usdtAvailable / pair.price
                : snapshot.balances.baseAvailable;
            _amountController.text = (available * pct / 100).toStringAsFixed(6);
          }),
          onChanged: () => setState(() {}),
          submitting: submitting,
          onPreviewOpened: orderNotifier.enterPreview,
          onPreviewDismissed: orderNotifier.cancelPreview,
          onConfirmedSubmit: () => _submitOrder(orderRequest),
        ),
        if (snapshot.highRiskContractId != null)
          VitTradeSection(
            title: 'Đánh giá rủi ro',
            child: VitHighRiskStatePanel(
              state: orderState.status.uiState,
              title: switch (orderState.status.uiState) {
                VitHighRiskUiState.submitting => 'Đang gửi lệnh',
                VitHighRiskUiState.success => 'Lệnh đã gửi',
                VitHighRiskUiState.error => 'Gửi lệnh thất bại',
                VitHighRiskUiState.offline => 'Mất kết nối',
                _ => 'Cần xem trước rủi ro lệnh spot',
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
                  'Xem trước phí (${formatTradeMoney(preview.fee)}), trượt giá và số dư khả dụng ($availableBalanceLabel) trước khi gửi lệnh thị trường. '
                      'Không hoàn tác sau khi xác nhận gửi. '
                      'Bước tiếp theo: theo dõi trạng thái lệnh và biên lai.',
              },
              contractId: snapshot.highRiskContractId,
              density: VitDensity.tool,
            ),
          ),
        VitTradeSection(
          title: 'Tiếp theo',
          child: VitNextActionCard(
            key: TradePage.nextActionKey,
            icon: nextAction.icon,
            title: nextAction.title,
            subtitle: nextAction.subtitle,
            statusLabel: nextAction.statusLabel,
            ctaLabel: nextAction.ctaLabel,
            accentColor: AppModuleAccents.trade,
            onTap: nextAction.onTap,
          ),
        ),
        VitTradeSection(
          title: 'Tài sản của bạn',
          actionLabel: snapshot.positions.isNotEmpty ? 'Xem tất cả' : null,
          onAction: snapshot.positions.isNotEmpty
              ? () => context.push(AppRoutePaths.tradePositions)
              : null,
          child: _SimplePositionsList(positions: snapshot.positions),
        ),
      ],
    );
  }
}

class _TradeNextAction {
  const _TradeNextAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.ctaLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String statusLabel;
  final String ctaLabel;
  final VoidCallback onTap;
}

class _SimplePositionsList extends StatelessWidget {
  const _SimplePositionsList({required this.positions});

  final List<TradePosition> positions;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return const VitEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Chưa có tài sản Spot',
        message: 'Mua coin đầu tiên để bắt đầu.',
      );
    }

    final visible = positions.take(3).toList();
    return VitTradeOrderList(
      records: [
        for (final position in visible)
          VitTradeOrderRecord(
            id: position.symbol,
            symbol: position.symbol,
            sideLabel: position.side == TradeOrderSide.buy ? 'MUA' : 'BÁN',
            sideColor: position.side == TradeOrderSide.buy
                ? AppColors.buy
                : AppColors.sell,
            detail:
                '${formatTradeMoney(position.notional)} · PnL ${formatTradeMoney(position.pnl)}',
          ),
      ],
      emptyLabel: 'Chưa có tài sản Spot',
    );
  }
}
