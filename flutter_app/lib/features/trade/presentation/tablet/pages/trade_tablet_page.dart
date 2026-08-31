import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_order_receipt_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_status_content.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_bottom_panel.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_book_panel.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_chart_panel.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_meta_strip.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_panel.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_tape_panel.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/vit_trade_simple_order_form.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_high_risk_status_ui.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Terminal giao dịch 3 vùng của Trade tablet (SC-048/SC-049, hướng Bybit
/// duyệt 2026-08-31) — cùng route, cùng [tradeScreenProvider] và cùng
/// widget công khai với [TradePage], nhưng là GRID CỐ ĐỊNH chiếm toàn bộ
/// chiều cao, KHÔNG cuộn trang: hàng meta dày đặc 1 dòng (đổi cặp + giá +
/// Cao/Thấp/KL + làm mới), cột chart nến OHLC (toolbar khung giờ + MA/KL
/// wired thật, crosshair) với tab Lệnh mở | Vị thế dưới chart, cột sổ lệnh
/// 12 mức/bên + tape giao dịch, và cột ĐẶT LỆNH luôn hiện. Tách vùng bằng
/// panel phẳng viền hairline (ngôn ngữ terminal Markets SC-044 hướng C).
///
/// Nhóm cột an toàn tài chính (bất biến giữ từ dashboard cũ, khóa bằng
/// test): xương sống đặt lệnh — product tabs, form, panel "Đánh giá rủi
/// ro" và disclaimer — ở cùng cột ĐẶT LỆNH luôn hiện không cuộn, nên fee/
/// trượt giá/số dư luôn kề cạnh nút gửi. Sổ lệnh/tape/chart là dữ liệu độc
/// lập với lệnh nháp, tách cột riêng.
///
/// Tầng chiều rộng (đọc width MỘT lần qua LayoutBuilder — R1c, không bao
/// giờ hỏi orientation): ≥ [TradeSpacingTokens.tradeTerminalFullSplitMinWidth]
/// = 3 vùng đầy; ≥ [TradeSpacingTokens.tradeTerminalSplitMinWidth] = chart
/// | đặt lệnh+tape (sổ lệnh thành tab thứ 3 dưới chart); dưới nữa là vùng
/// resize cửa sổ → stack cuộn.
class TradeTabletPage extends ConsumerStatefulWidget {
  const TradeTabletPage({
    super.key,
    this.initialSide = TradeOrderSide.buy,
    this.pairId = 'btcusdt',
  });

  final TradeOrderSide initialSide;
  final String pairId;

  @override
  ConsumerState<TradeTabletPage> createState() => _TradeTabletPageState();
}

class _TradeTabletPageState extends ConsumerState<TradeTabletPage> {
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

  Future<void> _refreshScreen() async {
    ref.invalidate(tradeScreenProvider(widget.pairId));
    await ref.read(tradeScreenProvider(widget.pairId).future);
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
        primaryKey: TradeTabletOrderReceiptPage.continueTradingKey,
        secondaryLabel: 'Chia sẻ',
        secondaryPressedLabel: 'Đã chia sẻ',
        secondaryKey: TradeTabletOrderReceiptPage.shareKey,
        onPrimary: () {
          context.go(AppRoutePaths.tradePair(widget.pairId));
        },
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
    final screenAsync = ref.watch(tradeScreenProvider(widget.pairId));
    final showBack = context.canPop();
    // Header cố định xuất hiện trong mọi nhánh async (R9) — fallback tên
    // chung trước khi cặp tải xong, hiện symbol thật khi có dữ liệu.
    final pair = screenAsync.asData?.value.pair;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Giao dịch Spot',
      semanticIdentifier: 'SC-048',
      child: Column(
        children: [
          VitHeader(
            title: pair?.symbol ?? 'Giao dịch',
            subtitle: 'Giao dịch Spot',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.trade,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
            backKey: TradeTabletKeys.back,
            // STEP-P2.4 / D5: Lệnh + Vị thế (EP-26 / EP-27) — không phụ
            // thuộc dữ liệu cặp, an toàn trước khi tải xong.
            actions: [
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
          ),
          Expanded(
            child: screenAsync.when(
              loading: () => const TradeLoadingContent(),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được màn hình giao dịch',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: _refreshScreen,
                ),
              ),
              data: _buildTerminal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminal(TradeScreenSnapshot snapshot) {
    final pair = snapshot.pair;
    final daySnapshot = tradeSyntheticDaySnapshot(pair.price, pair.changePct);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TradeTerminalMetaStrip(
          pair: pair,
          pairs: snapshot.pairs,
          highLabel: daySnapshot.highLabel,
          lowLabel: daySnapshot.lowLabel,
          volumeLabel: daySnapshot.volumeLabel,
          // Đổi cặp = thay root của luồng giao dịch (khuôn Bybit), không
          // xếp chồng cặp cũ lên stack back.
          onPairSelected: (candidate) =>
              context.go(AppRoutePaths.tradePair(candidate.id)),
          onRefresh: () => _refreshScreen(),
        ),
        const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              if (width >= TradeSpacingTokens.tradeTerminalFullSplitMinWidth) {
                return _buildFullTier(snapshot);
              }
              if (width >= TradeSpacingTokens.tradeTerminalSplitMinWidth) {
                return _buildCompactTier(snapshot);
              }
              return _buildStackedTier(snapshot);
            },
          ),
        ),
      ],
    );
  }

  /// Tầng đầy đủ: [chart + tab dưới chart | sổ lệnh + tape | đặt lệnh].
  Widget _buildFullTier(TradeScreenSnapshot snapshot) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildChartColumn(snapshot)),
        const SizedBox(width: TradeSpacingTokens.tradeTerminalGutter),
        SizedBox(
          width: TradeSpacingTokens.tradeTerminalBookColumnWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TradeTerminalBookPanel(orderBook: snapshot.orderBook),
              ),
              const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
              Expanded(child: TradeTerminalTapePanel(trades: snapshot.trades)),
            ],
          ),
        ),
        const SizedBox(width: TradeSpacingTokens.tradeTerminalGutter),
        SizedBox(
          width: TradeSpacingTokens.tradeTerminalEntryColumnWidth,
          child: _buildEntryPanel(snapshot, scrollable: true),
        ),
      ],
    );
  }

  /// Tầng gọn (tablet portrait): [chart + tab dưới chart (kèm tab Sổ lệnh)
  /// | đặt lệnh (cuộn nội bộ khi cần) + tape].
  Widget _buildCompactTier(TradeScreenSnapshot snapshot) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildChartColumn(snapshot, showBookTab: true)),
        const SizedBox(width: TradeSpacingTokens.tradeTerminalGutter),
        SizedBox(
          width: TradeSpacingTokens.tradeTerminalEntryColumnWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildEntryPanel(snapshot, scrollable: true)),
              const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
              SizedBox(
                height: TradeSpacingTokens.tradeTerminalBottomPanelHeight,
                child: TradeTerminalTapePanel(trades: snapshot.trades),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Vùng resize cửa sổ (nhỏ hơn tablet thật): stack cuộn dọc, panel giữ
  /// nguyên nhưng cao độ giới hạn bằng SizedBox.
  Widget _buildStackedTier(TradeScreenSnapshot snapshot) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._buildProductTabs(snapshot),
          const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
          SizedBox(
            height: TradeSpacingTokens.tradeTerminalStackedChartHeight,
            child: _buildChartPanel(snapshot),
          ),
          const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
          _buildBottomPanel(snapshot, showBookTab: true),
          const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
          SizedBox(
            height: TradeSpacingTokens.tradeTerminalBottomPanelHeight * 2,
            child: TradeTerminalBookPanel(orderBook: snapshot.orderBook),
          ),
          const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
          _buildEntryPanel(snapshot, scrollable: false),
        ],
      ),
    );
  }

  /// Hàng product tabs (L1 — Spot/Futures/Margin/Convert/Bot).
  List<Widget> _buildProductTabs(TradeScreenSnapshot snapshot) {
    return tradeShellWithProductTabs(
      context: context,
      showProductTabs: true,
      activeProductId: 'spot',
      productPair: snapshot.pair,
      quickNavKey: TradeTabletKeys.quickNav,
      navigationBuilder: buildTradeProductNavigation,
      children: const [SizedBox.shrink()],
    );
  }

  /// Panel chart nến OHLC của cặp hiện tại.
  Widget _buildChartPanel(TradeScreenSnapshot snapshot) {
    final pair = snapshot.pair;
    return TradeTerminalChartPanel(
      pairId: pair.id,
      anchorPrice: pair.price,
      positive: pair.changePct >= 0,
    );
  }

  /// Tab Lệnh mở | Vị thế (| Sổ lệnh ở tầng không có cột sổ lệnh riêng).
  Widget _buildBottomPanel(
    TradeScreenSnapshot snapshot, {
    bool showBookTab = false,
  }) {
    return TradeTerminalBottomPanel(
      orders: snapshot.orders,
      positions: snapshot.positions,
      orderBook: snapshot.orderBook,
      showBookTab: showBookTab,
      onViewAll: () => context.push(AppRoutePaths.tradeOrdersHistory),
    );
  }

  /// Cột chart: product tabs (L1 — điều hướng sản phẩm) + panel chart nến
  /// (Expanded) + tab Lệnh mở | Vị thế dưới chart.
  Widget _buildChartColumn(
    TradeScreenSnapshot snapshot, {
    bool showBookTab = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ..._buildProductTabs(snapshot),
        const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
        Expanded(child: _buildChartPanel(snapshot)),
        const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
        _buildBottomPanel(snapshot, showBookTab: showBookTab),
      ],
    );
  }

  /// Cột ĐẶT LỆNH — xương sống an toàn tài chính: form + panel rủi ro +
  /// disclaimer cùng cột, LUÔN HIỆN (terminal không cuộn trang; cột tự
  /// cuộn nội bộ khi viewport lùn).
  Widget _buildEntryPanel(
    TradeScreenSnapshot snapshot, {
    required bool scrollable,
  }) {
    final pair = snapshot.pair;
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
    final marketPrice = formatTradePrice(pair.price);
    final availableBalanceLabel = _side == TradeOrderSide.buy
        ? '${formatTradeMoney(snapshot.balances.usdtAvailable)} USDT'
        : '${formatTradeMoney(snapshot.balances.baseAvailable)} ${pair.baseAsset}';

    final form = VitTradeSimpleOrderForm(
      side: _side,
      pair: pair,
      balances: snapshot.balances,
      amountController: _amountController,
      preview: preview,
      canSubmit: canSubmit,
      marketPriceLabel: marketPrice,
      buyKey: TradeTabletKeys.buySide,
      sellKey: TradeTabletKeys.sellSide,
      amountFieldKey: TradeTabletKeys.amountField,
      submitKey: TradeTabletKeys.submit,
      pctKeyBuilder: TradeTabletKeys.pct,
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
    );

    // Luật 13dp: mỗi khối chỉ inset ngang — khoảng dọc giữa các khối và
    // tới viền panel đều là gutter 13 (label padding bottom đã cho form
    // khoảng 13 đầu tiên).
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: TradeSpacingTokens.tradeTerminalPanelBodyPadding,
          child: form,
        ),
        const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
        if (snapshot.highRiskContractId != null)
          Padding(
            padding: TradeSpacingTokens.tradeTerminalPanelBodyPadding,
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
        // Disclaimer y hệt shell phone (vit_trade_simple_shell) — giữ kề
        // form/panel rủi ro mà nó cảnh báo.
        if (snapshot.highRiskContractId != null)
          const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
        Padding(
          padding: TradeSpacingTokens.tradeTerminalPanelBodyPadding,
          child: Text(
            'Giao dịch tiền mã hoá có rủi ro. Chỉ dùng số tiền bạn chấp nhận mất.',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(height: TradeSpacingTokens.tradeTerminalGutter),
      ],
    );

    return TradeTerminalPanel(
      panelKey: TradeTabletKeys.entryPanel,
      label: 'ĐẶT LỆNH',
      fill: scrollable,
      child: scrollable ? SingleChildScrollView(child: content) : content,
    );
  }
}
