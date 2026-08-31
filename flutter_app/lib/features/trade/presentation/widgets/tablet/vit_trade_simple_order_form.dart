import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/vit_trade_confirm_sheet.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/vit_trade_side_switch.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_input.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_key_value_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_preset_chip_row.dart';

const _tradePrimary = AppColors.primary;

/// Market-only spot order form for beginner mode.
class VitTradeSimpleOrderForm extends StatelessWidget {
  const VitTradeSimpleOrderForm({
    super.key,
    required this.side,
    required this.pair,
    required this.balances,
    required this.amountController,
    required this.preview,
    required this.canSubmit,
    required this.marketPriceLabel,
    required this.onSideChanged,
    required this.onPct,
    required this.onChanged,
    required this.onConfirmedSubmit,
    this.submitting = false,
    this.onPreviewOpened,
    this.onPreviewDismissed,
    this.buyKey,
    this.sellKey,
    this.amountFieldKey,
    this.submitKey,
    this.pctKeyBuilder,
  });

  final TradeOrderSide side;
  final TradePair pair;
  final TradeBalances balances;
  final TextEditingController amountController;
  final TradeOrderPreview preview;
  final bool canSubmit;
  final String marketPriceLabel;
  final ValueChanged<TradeOrderSide> onSideChanged;
  final ValueChanged<int> onPct;
  final VoidCallback onChanged;
  final VoidCallback onConfirmedSubmit;

  /// Máy trạng thái đang confirming/submitting — CTA khóa + spinner.
  final bool submitting;

  /// `ready → preview` khi sheet 'Xem lại lệnh' mở (ADR-001).
  final VoidCallback? onPreviewOpened;

  /// `preview → ready` khi đóng sheet mà không xác nhận.
  final VoidCallback? onPreviewDismissed;

  final Key? buyKey;
  final Key? sellKey;
  final Key? amountFieldKey;
  final Key? submitKey;
  final Key Function(int pct)? pctKeyBuilder;

  String get _submitLabel {
    if (submitting) return 'Đang gửi lệnh…';
    if (!canSubmit) return 'Nhập số lượng để tiếp tục';
    return side == TradeOrderSide.buy ? 'Xác nhận MUA' : 'Đặt lệnh BÁN';
  }

  Future<void> _openConfirm(BuildContext context) async {
    if (!canSubmit || submitting) return;
    onPreviewOpened?.call();
    final sideLabel = side == TradeOrderSide.buy ? 'MUA' : 'BÁN';
    final availableLabel = side == TradeOrderSide.buy
        ? '${formatTradeMoney(balances.usdtAvailable)} USDT'
        : '${formatTradeMoney(balances.baseAvailable)} ${pair.baseAsset}';
    final confirmed = await showVitTradeConfirmSheet(
      context: context,
      title: 'Xem lại lệnh',
      lines: [
        VitTradeConfirmLine(label: 'Cặp', value: pair.symbol),
        VitTradeConfirmLine(label: 'Loại', value: sideLabel),
        VitTradeConfirmLine(
          label: 'Giá',
          value: 'Giá thị trường · $marketPriceLabel',
        ),
        VitTradeConfirmLine(
          label: 'Số lượng',
          value: '${amountController.text} ${pair.baseAsset}',
        ),
        VitTradeConfirmLine(
          label: 'Phí ước tính',
          value: formatTradeMoney(preview.fee),
        ),
        const VitTradeConfirmLine(
          label: 'Trượt giá',
          value: 'Lệnh thị trường · có thể lệch khi khớp',
        ),
        VitTradeConfirmLine(label: 'Số dư khả dụng', value: availableLabel),
        VitTradeConfirmLine(
          label: 'Tổng thanh toán',
          value: '${formatTradeMoney(preview.total)} USDT',
        ),
      ],
      riskMessage:
          'Giao dịch tiền mã hoá có rủi ro. Chỉ dùng số tiền bạn chấp nhận mất. '
          'Không hoàn tác sau khi xác nhận gửi. '
          'Bước tiếp theo: theo dõi trạng thái lệnh và biên lai.',
    );
    if (!context.mounted) return;
    if (confirmed) {
      onConfirmedSubmit();
    } else {
      onPreviewDismissed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseAsset = pair.baseAsset;
    final actionVerb = side == TradeOrderSide.buy ? 'mua' : 'bán';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitTradeSpotSideSwitch(
          side: side,
          onChanged: onSideChanged,
          buyKey: buyKey,
          sellKey: sellKey,
          activeBuyKey: const Key('sc048_trade_active_buy_side'),
          activeSellKey: const Key('sc048_trade_active_sell_side'),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitInput(
          key: amountFieldKey,
          label: 'Số lượng $actionVerb ($baseAsset)',
          semanticLabel: 'Số lượng $actionVerb $baseAsset',
          controller: amountController,
          onChanged: (_) => onChanged(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitPresetChipRow.percentBalance(
          onTap: onPct,
          keyFor: pctKeyBuilder ?? (pct) => Key('sc048_pct_$pct'),
          accentColor: _tradePrimary,
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitKeyValueRow(
          label: 'Giá thị trường',
          value: marketPriceLabel,
          labelStyle: AppTextStyles.caption.copyWith(color: AppColors.text2),
          valueStyle: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitKeyValueRow(
          label: 'Phí ước tính',
          value: formatTradeMoney(preview.fee),
          labelStyle: AppTextStyles.caption.copyWith(color: AppColors.text2),
          valueStyle: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitKeyValueRow(
          label: 'Trượt giá',
          // Cột terminal 320dp: bản rút gọn của dòng confirm sheet đầy đủ
          // ('Lệnh thị trường · có thể lệch khi khớp') để không tràn cột.
          value: 'Có thể lệch khi khớp',
          labelStyle: AppTextStyles.caption.copyWith(color: AppColors.text2),
          valueStyle: AppTextStyles.caption.copyWith(color: AppColors.text1),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitKeyValueRow(
          label: 'Số dư khả dụng',
          value: side == TradeOrderSide.buy
              ? '${formatTradeMoney(balances.usdtAvailable)} USDT'
              : '${formatTradeMoney(balances.baseAvailable)} ${pair.baseAsset}',
          labelStyle: AppTextStyles.caption.copyWith(color: AppColors.text2),
          valueStyle: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitKeyValueRow(
          label: 'Tổng thanh toán',
          value: '${formatTradeMoney(preview.total)} USDT',
          labelStyle: AppTextStyles.caption.copyWith(color: AppColors.text2),
          valueStyle: AppTextStyles.body.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        Text(
          'Giá thị trường có thể thay đổi. Không hoàn tác sau khi xác nhận gửi.',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        Semantics(
          button: true,
          enabled: canSubmit && !submitting,
          label: submitting
              ? 'Đang gửi lệnh giao dịch'
              : !canSubmit
              ? 'Nhập số lượng để tiếp tục đặt lệnh'
              : side == TradeOrderSide.buy
              ? 'Xác nhận mua lệnh Spot'
              : 'Đặt lệnh bán Spot',
          child: VitCtaButton(
            key: submitKey,
            onPressed: canSubmit && !submitting
                ? () => _openConfirm(context)
                : null,
            loading: submitting,
            density: VitDensity.tool,
            variant: side == TradeOrderSide.buy
                ? VitCtaButtonVariant.success
                : VitCtaButtonVariant.danger,
            child: Text(_submitLabel),
          ),
        ),
      ],
    );
  }
}
