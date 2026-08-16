import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/provider/copy_provider_detail_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/provider/provider_leaderboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpProviderLeaderboard(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyLeaderboard,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-079 mock repository exposes provider leaderboard BE draft',
    () async {
      final snapshot = await const MockTradeCopyTradingRepository(
        loadDelay: Duration.zero,
      ).getProviderLeaderboard();

      expect(snapshot.providers, hasLength(5));
      expect(snapshot.defaultSortId, 'roi');
      expect(snapshot.defaultRiskFilterId, 'all');
      expect(snapshot.defaultVerifiedOnly, isFalse);
      expect(snapshot.sortOptions.map((item) => item.id), [
        'roi',
        'sharpe',
        'followers',
        'recent',
      ]);
      expect(snapshot.riskFilters.map((item) => item.id), [
        'all',
        'low',
        'medium',
        'high',
      ]);
      expect(snapshot.warningTitle, 'Survivorship Bias Warning');
      expect(
        snapshot.supportedStates,
        containsAll([
          TradeScreenState.loading,
          TradeScreenState.empty,
          TradeScreenState.error,
          TradeScreenState.offline,
          TradeScreenState.realtimeRefresh,
        ]),
      );
    },
  );

  testWidgets('SC-079 renders leaderboard baseline inside the Trade shell', (
    tester,
  ) async {
    await pumpProviderLeaderboard(tester);

    expect(find.byType(ProviderLeaderboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Bảng xếp hạng'), findsOneWidget);
    expect(find.text('Survivorship Bias Warning'), findsOneWidget);
    expect(find.text('ROI'), findsWidgets);
    expect(find.text('Risk Level'), findsOneWidget);
    expect(find.text('Chỉ hiện Verified providers'), findsOneWidget);
    expect(find.text('Hiển thị 5 providers'), findsOneWidget);
    expect(find.text('RiskMaster_88'), findsOneWidget);
    expect(find.text('+567.8%'), findsOneWidget);
    expect(find.text('WhaleWatcher'), findsOneWidget);
  });

  testWidgets('SC-079 first viewport reaches top provider card', (
    tester,
  ) async {
    await pumpProviderLeaderboard(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ProviderLeaderboardPage',
      semanticLabel: 'Bảng xếp hạng provider',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ProviderLeaderboardPage.providerKey('ct003')),
      minVisibleHeight: 24,
      targetLabel: 'top provider card',
      reason:
          'Provider leaderboard must expose the first ranked provider above '
          'bottom navigation after warning, review, sort, risk, and verified '
          'filters.',
    );
  });

  testWidgets('SC-079 filters low risk providers locally', (tester) async {
    await pumpProviderLeaderboard(tester);

    await tester.tap(find.byKey(ProviderLeaderboardPage.riskKey('low')));
    await tester.pumpAndSettle();

    expect(find.text('Hiển thị 2 providers'), findsOneWidget);
    expect(find.text('WhaleWatcher'), findsOneWidget);
    expect(find.text('SteadyGains_Pro'), findsOneWidget);
    expect(find.text('RiskMaster_88'), findsNothing);
  });

  testWidgets('SC-079 verified toggle hides non-verified providers', (
    tester,
  ) async {
    await pumpProviderLeaderboard(tester);

    await tester.tap(find.byKey(ProviderLeaderboardPage.verifiedToggleKey));
    await tester.pumpAndSettle();

    expect(find.text('Hiển thị 4 providers'), findsOneWidget);
    expect(find.text('RiskMaster_88'), findsNothing);
    expect(find.text('AlphaHunter_VN'), findsOneWidget);
  });

  testWidgets('SC-079 provider card opens SC-070 provider detail', (
    tester,
  ) async {
    await pumpProviderLeaderboard(tester);

    await tester.tap(find.byKey(ProviderLeaderboardPage.providerKey('ct003')));
    await tester.pumpAndSettle();

    expect(find.byType(CopyProviderDetailPage), findsOneWidget);
    expect(find.byKey(CopyProviderDetailPage.assessmentKey), findsOneWidget);
    expect(find.text('RiskMaster_88'), findsWidgets);
  });
}
