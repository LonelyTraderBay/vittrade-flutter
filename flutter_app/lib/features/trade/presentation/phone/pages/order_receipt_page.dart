// Phone-only order receipt; Tablet owns a separate receipt page.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';

part '../../widgets/phone/order_receipt_page_sections.dart';
part '../../widgets/phone/order_receipt_page_common.dart';

const double _receiptCopyActionExtent = AppSpacing.buttonCompact;

class OrderReceiptPage extends ConsumerStatefulWidget {
  const OrderReceiptPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc051_order_receipt_content');
  static const openOrdersKey = Key('sc051_open_orders');
  static const copyOrderIdKey = Key('sc051_copy_order_id');
  static const openActionsKey = Key('sc051_open_actions');
  static const shareKey = Key('sc051_share');
  static const continueTradingKey = Key('sc051_continue_trading');
  static const supportKey = Key('sc051_support');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<OrderReceiptPage> createState() => _OrderReceiptPageState();
}

class _OrderReceiptPageState extends ConsumerState<OrderReceiptPage> {
  Future<void> _openReceiptActionsSheet(String orderId) {
    return showVitNoticeSheet(
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
  }

  @override
  Widget build(BuildContext context) {
    final receiptAsync = ref.watch(tradeOrderReceiptProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance = tradeScrollBottomInset(
      context,
      shellRenderMode: mode,
    );

    return VitTradeDetailScaffold(
      title: 'Chi tiết lệnh',
      semanticLabel: 'Chi tiết lệnh giao dịch',
      semanticIdentifier: 'SC-051',
      contentKey: OrderReceiptPage.contentKey,
      shellRenderMode: mode,
      bottomInset: scrollEndClearance,
      showProductTabs: false,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: receiptAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được chi tiết lệnh',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeOrderReceiptProvider),
          ),
        ],
        data: (snapshot) {
          final receipt = snapshot.receipt;
          final sideLabel = receipt.side == TradeOrderSide.buy ? 'Mua' : 'Bán';
          return [
            VitTradeComplianceHero(
              title: 'Đặt lệnh thành công!',
              description: 'Lệnh $sideLabel ${receipt.symbol} đang được xử lý',
              icon: Icons.check_circle_outline_rounded,
              accentColor: AppColors.buy,
            ),
            _ReceiptCard(receipt: receipt),
            VitTradeSection(title: 'Lưu ý', child: _WarningNotice()),
            VitTradeSection(
              title: 'Hỗ trợ',
              child: _OrderSupportLink(supportRoute: snapshot.supportRoute),
            ),
            VitCtaButton(
              key: OrderReceiptPage.openActionsKey,
              variant: VitCtaButtonVariant.success,
              density: VitDensity.compact,
              onPressed: () => _openReceiptActionsSheet(receipt.orderId),
              child: const Text('Thao tác tiếp theo'),
            ),
          ];
        },
      ),
    );
  }
}
