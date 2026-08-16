import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_ad_analytics_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PAdAnalytics(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pAdAnalytics('sample'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-223 mock repository exposes P2P ad analytics BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getAdAnalytics('sample');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-ad-analytics-sample');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.sourceAdId, 'myad001');
    expect(snapshot.asset, 'USDT');
    expect(snapshot.priceVnd, 25360);
    expect(snapshot.ranking, 3);
    expect(snapshot.impressions, 12847);
    expect(snapshot.dailyPerformance.length, 7);
    expect(snapshot.hourlyHeatmap.length, 24);
    expect(snapshot.paymentBreakdown.length, 2);
    expect(snapshot.competitorComparison.length, 4);
    expect(snapshot.optimizationTips.length, 3);
    expect(snapshot.contractNotes, contains('escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-223 renders P2P ad analytics baseline', (tester) async {
    await pumpP2PAdAnalytics(tester);

    expect(find.byType(P2PAdAnalyticsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân tích quảng cáo'), findsOneWidget);
    expect(find.text('Phân tích · P2P'), findsOneWidget);
    expect(find.text('BÁN USDT'), findsOneWidget);
    expect(find.text('25.360'), findsOneWidget);
    expect(find.text('#3/428'), findsOneWidget);
    expect(find.text('Lượt xem'), findsWidgets);
    expect(find.text('12,847'), findsWidgets);
    expect(find.text('Lượt click'), findsWidgets);
    expect(find.text('1,926'), findsWidgets);
    expect(find.text('Đơn tạo'), findsWidgets);
    expect(find.text('Hoàn thành'), findsWidgets);
    expect(find.text('Phễu chuyển đổi'), findsOneWidget);
    expect(find.text('Hiệu suất 7 ngày'), findsOneWidget);
    expect(find.text('Volume giao dịch'), findsOneWidget);
    expect(find.text('Heatmap theo giờ'), findsOneWidget);
    expect(find.text('Thanh toán phân bổ'), findsOneWidget);
    expect(find.text('So sánh đối thủ'), findsOneWidget);
    expect(find.text('Gợi ý tối ưu'), findsOneWidget);
  });

  testWidgets('SC-223 first viewport previews conversion funnel', (
    tester,
  ) async {
    await pumpP2PAdAnalytics(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-223 P2PAdAnalyticsPage',
      semanticLabel: 'Phân tích quảng cáo P2P',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(P2PAdAnalyticsPage.funnelKey),
      targetLabel: 'conversion funnel card',
      minVisibleHeight: 18,
    );
  });

  testWidgets('SC-223 content scroll keeps analytics sections reachable', (
    tester,
  ) async {
    await pumpP2PAdAnalytics(tester);

    expect(find.byKey(P2PAdAnalyticsPage.funnelKey), findsOneWidget);
    await tester.drag(
      find.byKey(P2PAdAnalyticsPage.contentKey),
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();

    expect(find.text('So sánh đối thủ'), findsOneWidget);
    expect(
      find.text(
        'Tỷ lệ hoàn thành tốt! Duy trì phản hồi nhanh để giữ vị trí top 3.',
      ),
      findsOneWidget,
    );
  });
}
