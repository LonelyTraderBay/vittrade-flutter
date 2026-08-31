import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/vit_trade_confirm_sheet.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_empty_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_filter_chip.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_notice_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_input.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_key_value_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_preset_chip_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_segmented_choice.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

/// Bố cục tablet của Giao dịch Margin (SC-085/SC-086, 2026-08-31) — cùng
/// provider với trang phone: form đặt lệnh ký quỹ (chế độ → hướng → số
/// lượng → xem trước → xác nhận) ở cột chính, tổng tài khoản ký quỹ +
/// bảng vị thế margin ở cột phụ luôn thấy cạnh form.
class MarginTradingTabletPage extends ConsumerStatefulWidget {
  const MarginTradingTabletPage({
    super.key,
    this.pairId = 'btcusdt',
    this.pairRouteVariant = false,
  });

  static const amountFieldKey = Key('sc085_tablet_amount_field');
  static const submitKey = Key('sc085_tablet_submit');

  static Key modeKey(String id) => Key('sc085_tablet_mode_$id');
  static Key sideKey(String id) => Key('sc085_tablet_side_$id');

  final String pairId;
  final bool pairRouteVariant;

  @override
  ConsumerState<MarginTradingTabletPage> createState() =>
      _MarginTradingTabletPageState();
}

class _MarginTradingTabletPageState
    extends ConsumerState<MarginTradingTabletPage> {
  late String _mode;
  late String _side;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mode = 'cross';
    _side = 'long';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = (
      pairId: widget.pairId,
      pairRouteVariant: widget.pairRouteVariant,
    );
    final controllerAsync = ref.watch(tradeMarginControllerProvider(request));

    return controllerAsync.when(
      loading: () => TradeTabletDetailSurface(
        semanticLabel: 'Giao dịch ký quỹ',
        semanticIdentifier: widget.pairRouteVariant ? 'SC-086' : 'SC-085',
        title: 'Margin ${widget.pairId.toUpperCase()}',
        subtitle: 'Giao dịch Margin',
        onBack: () => context.go(AppRoutePaths.trade),
        primary: const VitSkeletonList(rows: 5),
        secondary: const VitSkeletonList(rows: 4),
      ),
      error: (error, stackTrace) => TradeTabletDetailSurface(
        semanticLabel: 'Giao dịch ký quỹ',
        semanticIdentifier: widget.pairRouteVariant ? 'SC-086' : 'SC-085',
        title: 'Margin ${widget.pairId.toUpperCase()}',
        subtitle: 'Giao dịch Margin',
        onBack: () => context.go(AppRoutePaths.trade),
        primary: VitErrorState(
          title: 'Không tải được giao dịch Margin',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(tradeMarginSnapshotProvider(request)),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (controller) => _buildContent(controller, request),
    );
  }

  Widget _buildContent(
    TradeMarginController controller,
    ({String pairId, bool pairRouteVariant}) request,
  ) {
    final snapshot = controller.state.snapshot;
    final modePositions = controller.positionsForMode(_mode);
    final amount = _amountController.text;
    final canSubmit = amount != '0.00' && amount.isNotEmpty;

    return TradeTabletDetailSurface(
      semanticLabel: 'Giao dịch ký quỹ',
      semanticIdentifier: widget.pairRouteVariant ? 'SC-086' : 'SC-085',
      title: 'Margin ${snapshot.pair.symbol}',
      subtitle: 'Giao dịch Margin · ${_mode == 'cross' ? 'Cross' : 'Cô lập'}',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      primary: VitCard(
        radius: VitCardRadius.tight,
        padding: TabletSpacingTokens.cardPaddingCompact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: TabletSpacingTokens.rowGap,
              runSpacing: TabletSpacingTokens.rowGap,
              children: [
                for (final tab in snapshot.modeTabs)
                  VitFilterChip(
                    key: MarginTradingTabletPage.modeKey(tab.id),
                    label: tab.label,
                    active: _mode == tab.id,
                    onTap: () => setState(() => _mode = tab.id),
                    color: AppColors.primary,
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitSegmentedChoice<String>(
              selected: _side,
              onChanged: (side) => setState(() => _side = side),
              options: [
                VitSegmentedChoiceOption(
                  key: MarginTradingTabletPage.sideKey('long'),
                  value: 'long',
                  label: 'Giá tăng',
                  accentColor: AppColors.buy,
                  leading: const Icon(Icons.trending_up_rounded),
                ),
                VitSegmentedChoiceOption(
                  key: MarginTradingTabletPage.sideKey('short'),
                  value: 'short',
                  label: 'Giá giảm',
                  accentColor: AppColors.sell,
                  leading: const Icon(Icons.trending_down_rounded),
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitInput(
              key: MarginTradingTabletPage.amountFieldKey,
              label: 'Số lượng (${snapshot.pair.baseAsset})',
              semanticLabel: 'Số lượng mua ký quỹ',
              controller: _amountController,
              onChanged: (_) => setState(() {}),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitPresetChipRow.percentBalance(
              onTap: (pct) => setState(() {
                // maxAmountFor trả chuỗi định dạng sẵn — parse về số trước
                // khi tính phần trăm.
                final maxLabel = controller.maxAmountFor(
                  leverage: snapshot.defaultLeverage,
                );
                final max = double.tryParse(maxLabel) ?? 0;
                _amountController.text = (max * pct / 100).toStringAsFixed(2);
              }),
              keyFor: (pct) => Key('sc085_tablet_pct_$pct'),
              accentColor: AppColors.primary,
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            for (final (label, value) in [
              ('Đòn bẩy', '${snapshot.defaultLeverage}x'),
              (
                'Giá tham chiếu',
                formatTradePrice(snapshot.referencePrices.markPrice),
              ),
              (
                'Giá thanh lý ước tính',
                snapshot.orderDraft.liquidationPriceLabel,
              ),
              (
                'Số dư khả dụng',
                '${formatTradeMoney(snapshot.account.availableMargin)} USDT',
              ),
            ])
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: TabletSpacingTokens.x1,
                ),
                child: VitKeyValueRow(
                  label: label,
                  value: value,
                  labelStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                  ),
                  valueStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              key: MarginTradingTabletPage.submitKey,
              onPressed: canSubmit ? () => _openConfirm(snapshot) : null,
              variant: _side == 'long'
                  ? VitCtaButtonVariant.success
                  : VitCtaButtonVariant.danger,
              child: Text(
                canSubmit ? 'Xem lại & xác nhận' : 'Nhập số lượng để tiếp tục',
              ),
            ),
          ],
        ),
      ),
      secondary: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitCard(
            radius: VitCardRadius.tight,
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tài khoản ký quỹ',
                  style: AppTextStyles.control.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                for (final (label, value) in [
                  (
                    'Tổng vốn',
                    '${formatTradeMoney(snapshot.account.totalEquity)} USDT',
                  ),
                  (
                    'Ký quỹ đã dùng',
                    '${formatTradeMoney(snapshot.account.totalMargin)} USDT',
                  ),
                  (
                    'Khả dụng',
                    '${formatTradeMoney(snapshot.account.availableMargin)} USDT',
                  ),
                  (
                    'P/L chưa realise',
                    formatTradeSignedMoney(snapshot.account.unrealizedPnl),
                  ),
                  (
                    'Tỷ lệ ký quỹ',
                    snapshot.account.marginLevel.toStringAsFixed(2),
                  ),
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: TabletSpacingTokens.x1,
                    ),
                    child: VitKeyValueRow(
                      label: label,
                      value: value,
                      labelStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                      valueStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: TabletSpacingTokens.pageRhythmStandardSectionGap,
          ),
          if (modePositions.isEmpty)
            const VitEmptyState(
              icon: Icons.account_balance_outlined,
              title: 'Chưa có vị thế margin',
              message: 'Vị thế ký quỹ sẽ hiện tại đây.',
            )
          else
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Vị thế margin',
                    style: AppTextStyles.control.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  for (final position in modePositions)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: TabletSpacingTokens.x1,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${position.pair} · ${position.leverage}x · ${position.mode == 'cross' ? 'Cross' : 'Cô lập'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'TL ${position.liquidationPrice.toStringAsFixed(0)}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text3,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${position.pnl >= 0 ? '▲' : '▼'} ${formatTradeSignedMoney(position.pnl)}',
                              textAlign: TextAlign.right,
                              style: AppTextStyles.caption.copyWith(
                                color: position.pnl >= 0
                                    ? AppColors.buy
                                    : AppColors.sell,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openConfirm(TradeMarginTradingSnapshot snapshot) async {
    final amount = _amountController.text;
    if (amount == '0.00' || amount.isEmpty) return;
    final sideLabel = _side == 'long' ? 'Giá tăng' : 'Giá giảm';
    final confirmed = await showVitTradeConfirmSheet(
      context: context,
      title: 'Xem lại lệnh ký quỹ',
      lines: [
        VitTradeConfirmLine(label: 'Cặp', value: snapshot.pair.symbol),
        VitTradeConfirmLine(label: 'Hướng', value: sideLabel),
        VitTradeConfirmLine(
          label: 'Chế độ',
          value: _mode == 'cross' ? 'Cross' : 'Cô lập',
        ),
        VitTradeConfirmLine(
          label: 'Đòn bẩy',
          value: '${snapshot.defaultLeverage}x',
        ),
        VitTradeConfirmLine(label: 'Số lượng', value: amount),
        VitTradeConfirmLine(
          label: 'Giá thanh lý ước tính',
          value: snapshot.orderDraft.liquidationPriceLabel,
        ),
      ],
      riskMessage:
          'Giao dịch ký quỹ có rủi ro thanh lý. Xem trước tỷ lệ ký quỹ và giá '
          'thanh lý trước khi gửi. Không hoàn tác sau khi xác nhận.',
    );
    if (confirmed && mounted) {
      await showVitNoticeSheet(
        context: context,
        title: 'Đã gửi lệnh',
        message: 'Đã gửi lệnh ký quỹ (mock)',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      );
    }
  }
}
