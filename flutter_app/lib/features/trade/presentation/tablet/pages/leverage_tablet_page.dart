import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
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
import 'package:vit_trade_flutter/shared/widgets/vit_filter_chip.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_key_value_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_notice_sheet.dart';

/// Bố cục tablet của Đòn bẩy Futures (SC-058, 2026-08-31) — cùng
/// [tradeLeverageControllerProvider] với trang phone: chọn mức đòn bẩy qua
/// preset (wired `setLeverage`), bảng TÁC ĐỘNG theo mức (quy mô vị thế,
/// khoảng cách thanh lý, phí, lãi/lỗ ±1%) cập nhật theo preview, xác nhận
/// rủi ro trước khi áp dụng (ADR-001).
class LeverageTabletPage extends ConsumerWidget {
  const LeverageTabletPage({super.key, required this.pairId});

  static const submitKey = Key('sc058_tablet_submit');

  static Key presetKey(int leverage) => Key('sc058_tablet_preset_$leverage');

  final String pairId;

  Future<void> _apply(
    BuildContext context,
    WidgetRef ref,
    TradeLeverageViewState state,
  ) async {
    final notifier = ref.read(tradeLeverageControllerProvider(pairId).notifier);
    final confirmed = await showVitTradeConfirmSheet(
      context: context,
      title: 'Xác nhận thay đổi đòn bẩy',
      lines: [
        VitTradeConfirmLine(label: 'Cặp', value: pairId.toUpperCase()),
        VitTradeConfirmLine(
          label: 'Đòn bẩy',
          value: '${state.request.leverage} x',
        ),
        VitTradeConfirmLine(label: 'Rủi ro', value: state.preview.riskLabel),
      ],
      riskMessage:
          'Đòn bẩy cao làm tăng nguy cơ thanh lý toàn bộ ký quỹ. '
          'Xem trước tác động bên cạnh trước khi áp dụng.',
    );
    if (!confirmed || !context.mounted) return;
    await notifier.submit();
    if (!context.mounted) return;
    await showVitNoticeSheet(
      context: context,
      title: 'Đã áp dụng đòn bẩy',
      message:
          'Đã áp dụng ${state.request.leverage} x cho ${pairId.toUpperCase()}',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerAsync = ref.watch(tradeLeverageControllerProvider(pairId));
    final state = controllerAsync;
    final snapshot = state.snapshot;
    final preview = state.preview;
    final notifier = ref.read(tradeLeverageControllerProvider(pairId).notifier);
    final busy = state.status.isBusy;

    return TradeTabletDetailSurface(
      semanticLabel: 'Thiết lập đòn bẩy hợp đồng tương lai',
      semanticIdentifier: 'SC-058',
      title: 'Đòn bẩy ${snapshot.futures.pair.symbol}',
      subtitle: 'Thiết lập đòn bẩy · xem trước tác động',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradePair(pairId),
        mode: BackNavigationMode.historyThenFallback,
      ),
      primary: VitCard(
        radius: VitCardRadius.tight,
        padding: TabletSpacingTokens.cardPaddingCompact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Mức đòn bẩy · hiện tại ${snapshot.currentLeverage} x',
              style: AppTextStyles.control.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            Wrap(
              spacing: TabletSpacingTokens.rowGap,
              runSpacing: TabletSpacingTokens.rowGap,
              children: [
                for (final preset in snapshot.presets)
                  VitFilterChip(
                    key: LeverageTabletPage.presetKey(preset),
                    label: '${preset}x',
                    active: state.request.leverage == preset,
                    onTap: busy ? () {} : () => notifier.setLeverage(preset),
                    color: AppColors.primary,
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            _LeverageImpactRows(preview: preview),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              key: LeverageTabletPage.submitKey,
              onPressed:
                  state.request.leverage == snapshot.currentLeverage || busy
                  ? null
                  : () => _apply(context, ref, state),
              loading: busy,
              child: Text(
                state.request.leverage == snapshot.currentLeverage
                    ? 'Đòn bẩy đã áp dụng'
                    : 'Xem trước & áp dụng đòn bẩy',
              ),
            ),
          ],
        ),
      ),
      secondary: VitCard(
        radius: VitCardRadius.tight,
        padding: TabletSpacingTokens.cardPaddingCompact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ký quỹ mẫu · ví dụ',
              style: AppTextStyles.control.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            for (final (label, value) in [
              (
                'Ký quỹ ví dụ',
                '${formatTradeMoney(snapshot.exampleMargin)} USDT',
              ),
              ('Mức hiện tại', '${snapshot.currentLeverage} x'),
              ('Mức đang chọn', '${state.request.leverage} x'),
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
            if (preview.warningText.isNotEmpty)
              Text(
                preview.warningText,
                style: AppTextStyles.caption.copyWith(color: AppColors.caution),
              ),
          ],
        ),
      ),
    );
  }
}

class _LeverageImpactRows extends StatelessWidget {
  const _LeverageImpactRows({required this.preview});

  final TradeFuturesLeveragePreview preview;

  @override
  Widget build(BuildContext context) {
    final riskColor = Color(preview.riskColorHex);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TabletSpacingTokens.x1),
          child: VitKeyValueRow(
            label: 'Mức rủi ro',
            value: preview.riskLabel,
            labelStyle: AppTextStyles.caption.copyWith(color: AppColors.text2),
            valueStyle: AppTextStyles.caption.copyWith(
              color: riskColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        for (final (label, value) in [
          (
            'Quy mô vị thế với ký quỹ mẫu',
            formatTradeMoney(preview.positionSize),
          ),
          (
            'Khoảng cách giá thanh lý',
            '${preview.liquidationDistancePct.toStringAsFixed(2)}%',
          ),
          ('Phí mở lệnh', formatTradeMoney(preview.openFee)),
          ('Lãi nếu giá +1%', formatTradeSignedMoney(preview.profitAtOnePct)),
          ('Lỗ nếu giá −1%', formatTradeSignedMoney(preview.lossAtOnePct)),
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
    );
  }
}
