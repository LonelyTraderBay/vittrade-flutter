import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_panel.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';

/// Hàng meta dày đặc 1 dòng của terminal Trade (SC-048 tablet, hướng Bybit
/// 2026-08-31): nút đổi cặp (symbol ▾) + giá + biến động 24h + Cao/Thấp +
/// KL 24h (đồng base) + Giá trị 24h (USDT) + Spread ngăn bằng vạch mảnh +
/// nút làm mới — thay banner ticker 2 dòng kiểu dashboard cũ. Số tabular;
/// hướng tăng/giảm có cả MŨI TÊN ▲▼ (không chỉ phụ thuộc màu — a11y).
///
/// 2026-09-02 (user duyệt làm đầy cụm phải): cụm số liệu trải tới sát nút
/// làm mới — không còn khoảng trống dài cuối hàng.
class TradeTerminalMetaStrip extends StatelessWidget {
  const TradeTerminalMetaStrip({
    super.key,
    required this.pair,
    required this.pairs,
    required this.highLabel,
    required this.lowLabel,
    required this.volumeLabel,
    required this.coinVolumeLabel,
    required this.spreadLabel,
    required this.onPairSelected,
    required this.onRefresh,
  });

  final TradePair pair;
  final List<TradePair> pairs;
  final String highLabel;
  final String lowLabel;

  /// Giá trị giao dịch 24h theo quote (USDT).
  final String volumeLabel;

  /// Khối lượng giao dịch 24h theo đồng base.
  final String coinVolumeLabel;

  /// Spread = giá bán tốt nhất − giá mua tốt nhất ('—' khi sổ lệnh trống).
  final String spreadLabel;
  final ValueChanged<TradePair> onPairSelected;
  final VoidCallback onRefresh;

  Future<void> _openPairPicker(BuildContext context) async {
    final selected = await showVitBottomSheet<TradePair>(
      context: context,
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: TabletSpacingTokens.contentInsets,
              child: VitSheetHandle(),
            ),
            Padding(
              padding: TabletSpacingTokens.contentInsets,
              child: Text(
                'Chọn cặp giao dịch',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: TabletSpacingTokens.contentInsets,
                children: [
                  for (final candidate in pairs)
                    _TradePairPickerRow(
                      pair: candidate,
                      active: candidate.id == pair.id,
                      onTap: () => Navigator.of(sheetContext).pop(candidate),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null && selected.id != pair.id) {
      onPairSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final positive = pair.changePct >= 0;
    final accent = positive ? AppColors.buy : AppColors.sell;
    return TradeTerminalPanel(
      panelKey: TradeTabletKeys.metaStrip,
      child: Padding(
        padding: TradeSpacingTokens.tradeTerminalMetaStripPadding,
        child: Row(
          children: [
            _PairPickerButton(
              symbol: pair.symbol,
              onTap: () => _openPairPicker(context),
            ),
            const SizedBox(width: TabletSpacingTokens.x4),
            Flexible(
              child: Text(
                formatTradePrice(pair.price),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: accent,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(width: TabletSpacingTokens.x4),
            Text(
              '${positive ? '▲' : '▼'}${pair.changePct.abs().toStringAsFixed(2)}%',
              style: AppTextStyles.caption.copyWith(
                color: accent,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            for (final (label, value) in [
              ('Cao', highLabel),
              ('Thấp', lowLabel),
              ('KL 24h', '$coinVolumeLabel ${pair.baseAsset}'),
              ('Giá trị 24h', '$volumeLabel ${pair.quoteAsset}'),
              ('Spread', spreadLabel),
            ]) ...[
              const SizedBox(width: TabletSpacingTokens.x4),
              const SizedBox(
                height: TradeSpacingTokens.tradeTerminalMetaDividerHeight,
                child: VerticalDivider(
                  width: TabletSpacingTokens.hairlineStroke,
                  thickness: TabletSpacingTokens.hairlineStroke,
                  color: AppColors.divider,
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              // Flexible + ellipsis: tablet portrait (~655dp nội dung) vẫn
              // đủ chỗ — cụm số liệu co lại thay vì tràn panel.
              Flexible(
                child: Text.rich(
                  TextSpan(
                    text: '$label ',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                    children: [
                      TextSpan(
                        text: value,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  key: TradeTabletKeys.refresh,
                  tooltip: 'Làm mới dữ liệu',
                  onPressed: onRefresh,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: TabletSpacingTokens.iconMd,
                  ),
                  color: AppColors.text2,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nút đổi cặp: symbol đậm + chevron xuống — mở sheet chọn cặp.
class _PairPickerButton extends StatelessWidget {
  const _PairPickerButton({required this.symbol, required this.onTap});

  final String symbol;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: TradeTabletKeys.pairPicker,
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: TradeSpacingTokens.tradeTerminalPickerButtonPadding,
        child: Row(
          children: [
            Text(
              symbol,
              style: AppTextStyles.control.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: TabletSpacingTokens.x4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text2,
              size: TradeSpacingTokens.tradeHeaderChevron,
            ),
          ],
        ),
      ),
    );
  }
}

/// Một cặp trong sheet chọn: symbol + giá tabular + biến động màu mũi tên.
class _TradePairPickerRow extends StatelessWidget {
  const _TradePairPickerRow({
    required this.pair,
    required this.active,
    required this.onTap,
  });

  final TradePair pair;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final positive = pair.changePct >= 0;
    final accent = positive ? AppColors.buy : AppColors.sell;
    return InkWell(
      key: TradeTabletKeys.pairPickerItem,
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: TradeSpacingTokens.tradeTerminalPickerRowPadding,
        child: Row(
          children: [
            Expanded(
              child: Text(
                pair.symbol,
                style: AppTextStyles.control.copyWith(
                  color: active ? AppColors.primary : AppColors.text1,
                  fontWeight: active ? AppTextStyles.bold : null,
                ),
              ),
            ),
            Text(
              formatTradePrice(pair.price),
              style: AppTextStyles.control.copyWith(
                color: AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(width: TabletSpacingTokens.x4),
            SizedBox(
              width: TabletSpacingTokens.x7 + TabletSpacingTokens.x6,
              child: Text(
                '${positive ? '▲' : '▼'}${pair.changePct.abs().toStringAsFixed(2)}%',
                textAlign: TextAlign.right,
                style: AppTextStyles.caption.copyWith(
                  color: accent,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
