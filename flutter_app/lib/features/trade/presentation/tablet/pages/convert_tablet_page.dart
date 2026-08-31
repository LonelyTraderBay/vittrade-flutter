import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/vit_trade_confirm_sheet.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Chuyển đổi tài sản (SC-056, 2026-08-31) — cùng
/// [tradeConvertSnapshotProvider] và [tradeConvertQuoteProvider] với trang
/// phone: form gửi/nhận + số lượng + trượt giá ở cột chính, tỷ giá · giới
/// hạn · lịch sử ở cột phụ; luồng preview → xác nhận → gửi (an toàn tài
/// chính: xem trước tỷ giá + phí trước khi gửi).
class ConvertTabletPage extends ConsumerStatefulWidget {
  const ConvertTabletPage({super.key});

  static const amountFieldKey = Key('sc056_tablet_amount');
  static const submitKey = Key('sc056_tablet_submit');

  static Key slippageKey(double option) =>
      Key('sc056_tablet_slippage_${option.toString()}');

  @override
  ConsumerState<ConvertTabletPage> createState() => _ConvertTabletPageState();
}

class _ConvertTabletPageState extends ConsumerState<ConvertTabletPage> {
  final _amountController = TextEditingController();
  double _slippage = 0.5;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  TradeConvertRequest get _request {
    final amount = double.tryParse(_amountController.text) ?? 0;
    return TradeConvertRequest(
      fromSymbol: 'USDT',
      toSymbol: 'BTC',
      amount: amount,
      slippagePct: _slippage,
      mode: 'market',
    );
  }

  Future<void> _submitConvert(TradeConvertQuote quote) async {
    final repository = ref.read(tradeReadModelControllerProvider);
    await repository.submitConvert(_request);
    if (!mounted) return;
    await showVitNoticeSheet(
      context: context,
      title: 'Đã chuyển đổi',
      message: 'Đã chuyển ${formatTradeMoney(_request.amount)} USDT',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final convertAsync = ref.watch(tradeConvertSnapshotProvider);
    return convertAsync.when(
      loading: () => TradeTabletDetailSurface(
        semanticLabel: 'Chuyển đổi tài sản',
        semanticIdentifier: 'SC-056',
        title: 'Chuyển đổi tài sản',
        subtitle: 'Đổi tài sản · xem trước tỷ giá và phí',
        onBack: () => context.go(AppRoutePaths.trade),
        primary: const VitSkeletonList(rows: 5),
        secondary: const VitSkeletonList(rows: 4),
      ),
      error: (error, stackTrace) => TradeTabletDetailSurface(
        semanticLabel: 'Chuyển đổi tài sản',
        semanticIdentifier: 'SC-056',
        title: 'Chuyển đổi tài sản',
        subtitle: 'Đổi tài sản · xem trước tỷ giá và phí',
        onBack: () => context.go(AppRoutePaths.trade),
        primary: VitErrorState(
          title: 'Không tải được chuyển đổi tài sản',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(tradeConvertSnapshotProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) {
        final amount = double.tryParse(_amountController.text) ?? 0;
        final quoteAsync = amount > 0
            ? ref.watch(tradeConvertQuoteProvider(_request))
            : null;
        final quote = quoteAsync?.asData?.value;

        return TradeTabletDetailSurface(
          semanticLabel: 'Chuyển đổi tài sản',
          semanticIdentifier: 'SC-056',
          title: 'Chuyển đổi tài sản',
          subtitle: 'Đổi tài sản · xem trước tỷ giá và phí',
          onBack: () => goBackOrFallback(
            context,
            fallbackPath: AppRoutePaths.trade,
            mode: BackNavigationMode.historyThenFallback,
          ),
          primary: VitCard(
            radius: VitCardRadius.tight,
            padding: AppSpacing.cardPaddingCompact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _AssetBlock(
                        label: 'Gửi',
                        symbol: snapshot.fromAsset.symbol,
                        name: snapshot.fromAsset.name,
                        balanceLabel:
                            '${formatTradeMoney(snapshot.fromAsset.balance)} ${snapshot.fromAsset.symbol}',
                      ),
                    ),
                    const Icon(Icons.sync_alt_rounded, color: AppColors.text3),
                    Expanded(
                      child: _AssetBlock(
                        label: 'Nhận',
                        symbol: snapshot.toAsset.symbol,
                        name: snapshot.toAsset.name,
                        balanceLabel:
                            '${formatTradeMoney(snapshot.toAsset.balance)} ${snapshot.toAsset.symbol}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x4),
                VitInput(
                  key: ConvertTabletPage.amountFieldKey,
                  label: 'Số lượng (${snapshot.fromAsset.symbol})',
                  semanticLabel: 'Số lượng chuyển đổi',
                  controller: _amountController,
                  onChanged: (_) => setState(() {}),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Wrap(
                  spacing: AppSpacing.rowGap,
                  runSpacing: AppSpacing.rowGap,
                  children: [
                    for (final option in snapshot.slippageOptions)
                      VitFilterChip(
                        key: ConvertTabletPage.slippageKey(option),
                        label: '$option%',
                        active: _slippage == option,
                        onTap: () => setState(() => _slippage = option),
                        color: AppColors.primary,
                      ),
                  ],
                ),
                if (quote != null) ...[
                  const SizedBox(height: AppSpacing.x4),
                  for (final (label, value) in [
                    (
                      'Nhận ước tính',
                      '${formatTradeMoney(quote.toAmount)} ${quote.toSymbol}',
                    ),
                    ('Phí chuyển đổi', formatTradeMoney(quote.feeUsd)),
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.x1,
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
                const SizedBox(height: AppSpacing.x4),
                VitCtaButton(
                  key: ConvertTabletPage.submitKey,
                  onPressed: amount <= 0
                      ? null
                      : () => _openConfirm(snapshot, quote),
                  child: Text(
                    amount <= 0
                        ? 'Nhập số lượng để tiếp tục'
                        : quote == null
                        ? 'Đang lấy báo giá…'
                        : 'Xem trước & xác nhận',
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
                padding: AppSpacing.cardPaddingCompact,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (label, value) in [
                      ('Tỷ giá hiện tại', snapshot.rateLabel),
                      ('Báo giá còn hiệu lực', snapshot.countdownLabel),
                      (
                        'Giới hạn mỗi lệnh',
                        '${formatTradeMoney(snapshot.minUsd)} – ${formatTradeMoney(snapshot.maxUsd)} USDT',
                      ),
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.x1,
                        ),
                        child: VitKeyValueRow(
                          label: label,
                          value: value,
                          labelStyle: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                          valueStyle: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              if (snapshot.history.isNotEmpty)
                VitCard(
                  radius: VitCardRadius.tight,
                  padding: AppSpacing.cardPaddingCompact,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Chuyển đổi gần đây',
                        style: AppTextStyles.control.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      for (final record in snapshot.history.take(5))
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.x1,
                          ),
                          child: Text(
                            '${formatTradeMoney(record.fromAmount)} ${record.fromSymbol} → '
                            '${formatTradeMoney(record.toAmount)} ${record.toSymbol} · ${record.timeLabel}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openConfirm(
    TradeConvertSnapshot snapshot,
    TradeConvertQuote? quote,
  ) async {
    final amount = _amountController.text;
    if (amount.isEmpty) return;
    final confirmed = await showVitTradeConfirmSheet(
      context: context,
      title: 'Xác nhận chuyển đổi tài sản',
      lines: [
        VitTradeConfirmLine(
          label: 'Gửi',
          value: '$amount ${snapshot.fromAsset.symbol}',
        ),
        VitTradeConfirmLine(label: 'Nhận', value: snapshot.toAsset.symbol),
        VitTradeConfirmLine(label: 'Tỷ giá', value: snapshot.rateLabel),
        VitTradeConfirmLine(label: 'Trượt giá', value: '$_slippage%'),
        if (quote != null)
          VitTradeConfirmLine(
            label: 'Nhận ước tính',
            value: '${formatTradeMoney(quote.toAmount)} ${quote.toSymbol}',
          ),
        if (quote != null)
          VitTradeConfirmLine(
            label: 'Phí',
            value: formatTradeMoney(quote.feeUsd),
          ),
      ],
      riskMessage:
          'Tỷ giá có thể thay đổi theo báo giá hiện tại. Xem trước số nhận và '
          'phí trước khi xác nhận. Không hoàn tác sau khi gửi.',
    );
    if (!confirmed || !mounted) return;
    if (quote == null) return;
    await _submitConvert(quote);
  }
}

class _AssetBlock extends StatelessWidget {
  const _AssetBlock({
    required this.label,
    required this.symbol,
    required this.name,
    required this.balanceLabel,
  });

  final String label;
  final String symbol;
  final String name;
  final String balanceLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          symbol,
          style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
        ),
        Text(
          name,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          balanceLabel,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
