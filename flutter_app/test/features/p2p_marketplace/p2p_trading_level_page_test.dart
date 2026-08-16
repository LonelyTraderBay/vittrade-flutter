import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_trading_level_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PTradingLevel(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pTradingLevel,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-230 mock repository exposes P2P trading level BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getTradingLevel();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-trading-level');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.userLevel.currentLevel, 3);
    expect(snapshot.userLevel.completedOrders, 64);
    expect(snapshot.userLevel.accumulatedVolume, 1250000000);
    expect(snapshot.userLevel.dailyUsed, 45000000);
    expect(snapshot.dailyUsagePercent, 9);
    expect(snapshot.userLevel.nextLevelProgress, 0.42);
    expect(snapshot.currentLevel.nameVi, 'Nâng cao');
    expect(snapshot.levels, hasLength(4));
    expect(snapshot.levels.map((level) => level.name), [
      'Basic',
      'Standard',
      'Advanced',
      'VIP',
    ]);
    expect(snapshot.emptyTitle, 'Chưa có dữ liệu cấp bậc');
    expect(snapshot.contractNotes, contains('escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-230 renders trading level baseline', (tester) async {
    await pumpP2PTradingLevel(tester);

    expect(find.byType(P2PTradingLevelPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Cấp độ giao dịch P2P'), findsOneWidget);
    expect(find.text('Cấp bậc · P2P'), findsOneWidget);
    expect(find.text('Lv.3 Nâng cao'), findsWidgets);
    expect(find.text('Hiện tại'), findsWidgets);
    expect(find.text('Phí giao dịch +0.15%'), findsOneWidget);
    expect(find.text('Giao dịch hoàn tất'), findsOneWidget);
    expect(find.text('64'), findsOneWidget);
    expect(find.text('Volume tích lũy'), findsOneWidget);
    expect(find.text('1.25B'), findsOneWidget);
    expect(find.text('Hạn mức ngày'), findsOneWidget);
    expect(find.text('9%'), findsOneWidget);
    expect(find.text('Tiến trình lên Lv.4'), findsOneWidget);
    expect(find.text('42%'), findsOneWidget);
    expect(find.text('Tất cả cấp độ'), findsOneWidget);
    expect(find.text('Lv.1 Cơ bản'), findsOneWidget);
    expect(find.text('Lv.2 Tiêu chuẩn'), findsOneWidget);
  });

  testWidgets('SC-230 first viewport reaches level list', (tester) async {
    await pumpP2PTradingLevel(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-230 P2PTradingLevelPage',
      semanticLabel: 'Cấp độ giao dịch P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PTradingLevelPage.levelKey(1)),
      routeName: 'SC-230 P2PTradingLevelPage',
      actionLabel: 'first trading level card',
      minVisibleHeight: 72,
    );
  });

  testWidgets('SC-230 scrolls through all levels and upgrade CTA', (
    tester,
  ) async {
    await pumpP2PTradingLevel(tester);

    await tester.ensureVisible(P2PTradingLevelPage.levelKey(4).finder);
    await tester.pumpAndSettle();

    expect(find.text('Lv.4 VIP'), findsOneWidget);
    expect(find.text('Chưa đạt'), findsOneWidget);
    expect(find.text('∞'), findsWidgets);
    expect(find.text('Volume > 5 tỷ VND'), findsOneWidget);
    expect(find.byKey(P2PTradingLevelPage.upgradeButtonKey), findsOneWidget);
    expect(find.text('Nâng cấp lên VIP'), findsOneWidget);

    await tester.tap(find.byKey(P2PTradingLevelPage.upgradeButtonKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Nâng cấp lên VIP sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-230 header back returns to the P2P parent route', (
    tester,
  ) async {
    await pumpP2PTradingLevel(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('P2P'), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
