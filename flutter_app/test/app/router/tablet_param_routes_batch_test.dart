// Batch test tablet cho các route THAM SỐ HÓA (:id) — các nhánh
// _buildTabletPage có param chưa được pump bởi batch path tĩnh (coverage
// đợt 2 nhóm b). Id mẫu; trang render trạng thái dữ liệu hoặc not-found
// đều phủ được builder + _requiredParam.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';

void main() {
  Future<void> pumpTablet(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: location,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Chia lô để giữ runtime mỗi test hợp lý.
  testWidgets(
    'route tham số tablet render trang thật (lô 1: trade/markets/wallet/referral)',
    (tester) async {
      final locations = <String>[
        '/pair/btcusdt',
        '/pair/btcusdt/depth',
        '/pair/btcusdt/info',
        '/trade/btcusdt',
        '/trade/btcusdt/futures',
        '/trade/btcusdt/futures/leverage',
        '/trade/advanced-chart/btcusdt',
        '/trade/trader/trader-01',
        '/trade/copy-provider/ct001/configuration',
        '/trade/copy-provider/ct001/confirmation',
        '/trade/copy-performance/copy-001',
        '/trade/copy-audit-log/copy-001',
        '/trade/copy-trading/complaint-tracking/case-01',
        '/trade/copy-trading/target-market-definition/product-01',
        '/markets/predictions/event/event-01',
        '/markets/predictions/receipt/receipt-01',
        '/markets/predictions/tournament/tournament-01',
        '/markets/predictions/advanced-chart/event-01',
        '/wallet/asset/btc',
        '/wallet/transaction/tx-001',
        '/wallet/deposit/usdt',
        '/wallet/withdraw/usdt',
        '/referral/friend/friend-01',
        '/dca/rebalance/config-01/edit',
        '/dca/rebalance/config-01/history',
      ];
      for (final location in locations) {
        await pumpTablet(tester, location);
        expect(
          find.byType(VitTabletUtilityPage),
          findsNothing,
          reason: location,
        );
        expect(tester.takeException(), isNull, reason: location);
      }
    },
  );

  testWidgets('route tham số tablet render trang thật (lô 2: p2p + arena)', (
    tester,
  ) async {
    final locations = <String>[
      '/p2p/ad-analytics/ad-usdt-01',
      '/p2p/chat/order-01',
      '/p2p/dispute/order-01',
      '/p2p/dispute/detail/dispute-01',
      '/p2p/dispute/evidence/dispute-01',
      '/p2p/dispute/resolution/dispute-01',
      '/p2p/escrow/order-01',
      '/p2p/escrow/balance',
      '/p2p/insurance/claim/claim-01',
      '/p2p/merchant/merchant-01',
      '/p2p/order/order-01',
      '/p2p/order/cancel/order-01',
      '/p2p/order/proof/order-01',
      '/p2p/order/rate/order-01',
      '/p2p/order/timeline/order-01',
      '/p2p/payment-method/ownership/method-01',
      '/p2p/payment-method/verification/method-01',
      '/p2p/report/merchant-01',
      '/p2p/tax-report/detailed/2026',
      '/arena/challenge/challenge-01',
      '/arena/creator/creator-01',
      '/arena/join/challenge-01',
      '/arena/ledger/entry/entry-01',
      '/arena/mode/mode-01',
      '/arena/report/case-01',
      '/arena/trust/user-01',
    ];
    for (final location in locations) {
      await pumpTablet(tester, location);
      expect(find.byType(VitTabletUtilityPage), findsNothing, reason: location);
      expect(tester.takeException(), isNull, reason: location);
    }
  });
}
