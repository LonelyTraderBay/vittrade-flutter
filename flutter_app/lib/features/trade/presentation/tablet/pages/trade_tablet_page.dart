import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_order_receipt_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_positions_panel.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_status_content.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_ticker_strip.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/vit_trade_simple_order_form.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_high_risk_status_ui.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet composition of Trade (SC-048) — same route, same
/// [tradeScreenProvider] data and the same public Trade widgets as
/// [TradePage], but laid out as a persistent two-column dashboard instead
/// of one scrolling phone column. Does not touch `trade_page.dart`/
/// `trade_page_state.dart` — reached via `createTabletAppRouter`/surface
/// bootstrap. Fourth reference implementation for
/// `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md`.
///
/// Deliberate financial-safety column grouping (not just a generic content
/// split): the order-entry backbone — product-switch tabs, price hero,
/// order form, and the persistent "Đánh giá rủi ro" risk panel — all stay
/// together in the PRIMARY column. That risk panel restates the same fee/
/// slippage/balance facts as the confirm-sheet CTA a moment later; keeping
/// it beside the form means anyone acting entirely within that column
/// always sees live risk status next to what they're about to submit,
/// without depending on also having scrolled the independently-scrolling
/// secondary column into view. Only content genuinely independent of the
/// in-progress order draft — the "Tiếp theo" nudge and existing positions —
/// goes in the secondary column. See
/// docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md.
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

  _TradeTabletNextAction _resolveNextAction(TradeScreenSnapshot snapshot) {
    if (snapshot.orders.isNotEmpty) {
      return _TradeTabletNextAction(
        icon: Icons.pending_actions_outlined,
        title: 'Hoàn tất lệnh đang chờ',
        subtitle: 'Bạn có ${snapshot.orders.length} lệnh mở cần theo dõi',
        statusLabel: 'Lệnh mở',
        ctaLabel: 'Xem lệnh',
        onTap: () => context.push(AppRoutePaths.tradeOrdersHistory),
      );
    }
    if (snapshot.positions.isEmpty) {
      return _TradeTabletNextAction(
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
    return _TradeTabletNextAction(
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
    final showBack = context.canPop();
    // Unlike the phone page (whose header lives entirely inside its data
    // branch, so loading/error show no chrome at all), the tablet header is
    // a fixed sibling present in every async state (R9) — falls back to a
    // generic title before the pair has loaded once, via AsyncValue's own
    // last-known-value accessor, then shows the real symbol once available.
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
            // STEP-P2.4 / D5: persistent Lệnh + Vị thế (EP-26 / EP-27) — same
            // as phone, doesn't depend on pair data so it's safe pre-load.
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
              loading: () => TradeLoadingContent(onRefresh: _refreshScreen),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được màn hình giao dịch',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: _refreshScreen,
                ),
              ),
              data: _buildDashboard,
            ),
          ),
        ],
      ),
    );
  }

  // Two-column threshold and per-column width caps are owned by
  // [VitTwoColumnTabletDashboard] (`TabletDashboardWidths` defaults) —
  // Trade's own content confirmed the same values as `HomeTabletPage` hold,
  // including the primary/secondary VitCard-ancestry split the risk panel
  // depends on (see the wide-tablet cases in `trade_tablet_page_test.dart`).
  // Pass constructor overrides on the call below instead of editing the
  // shared widths if Trade's content ever needs a different number.

  Widget _buildDashboard(TradeScreenSnapshot snapshot) {
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
    final daySnapshot = tradeSyntheticDaySnapshot(pair.price, pair.changePct);
    final nextAction = _resolveNextAction(snapshot);
    final availableBalanceLabel = _side == TradeOrderSide.buy
        ? '${formatTradeMoney(snapshot.balances.usdtAvailable)} USDT'
        : '${formatTradeMoney(snapshot.balances.baseAvailable)} ${pair.baseAsset}';

    // Product-switch quick-nav stays scoped to the primary (order-entry)
    // column rather than promoted to a second fixed bar above both columns
    // — it's page-primary navigation for the order flow happening in that
    // column, not shared context for the secondary column's nudge/positions
    // content, and R9 doesn't establish a pattern for a second chrome tier.
    // The instrument hero moved the other way: its price facts became the
    // fixed full-width ticker banner so they stay visible regardless of
    // either column's scroll offset.
    final primaryChildren = tradeShellWithProductTabs(
      context: context,
      showProductTabs: true,
      activeProductId: 'spot',
      productPair: pair,
      quickNavKey: TradeTabletKeys.quickNav,
      navigationBuilder: buildTradeProductNavigation,
      children: [
        VitTradeSimpleOrderForm(
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
        // Same disclaimer VitTradeSimpleShell appends unconditionally on
        // phone (see vit_trade_simple_shell.dart) — kept beside the order
        // form/risk panel it caveats rather than the secondary column.
        Text(
          'Giao dịch tiền mã hoá có rủi ro. Chỉ dùng số tiền bạn chấp nhận mất.',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );

    final secondaryChildren = [
      VitTradeSection(
        title: 'Tiếp theo',
        child: VitNextActionCard(
          key: TradeTabletKeys.nextAction,
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
        child: TradePositionsPanel(positions: snapshot.positions),
      ),
    ];

    return VitTwoColumnTabletDashboard(
      banner: TradeTickerStrip(
        symbol: pair.symbol,
        priceLabel: marketPrice,
        changePct: pair.changePct,
        highLabel: daySnapshot.highLabel,
        lowLabel: daySnapshot.lowLabel,
        volumeLabel: daySnapshot.volumeLabel,
        sparklineValues: daySnapshot.sparkline,
        availableBalanceLabel: availableBalanceLabel,
      ),
      onRefresh: _refreshScreen,
      primaryChildren: primaryChildren,
      secondaryChildren: secondaryChildren,
      primaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
      secondaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
    );
  }
}

class _TradeTabletNextAction {
  const _TradeTabletNextAction({
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
