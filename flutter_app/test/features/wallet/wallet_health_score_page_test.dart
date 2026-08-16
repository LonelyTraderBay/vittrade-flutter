import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/wallet_health_score_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpHealthScore(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);
    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletHealthScore,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-151 mock repository exposes wallet health score BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getHealthScore();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-health-score');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.overallScore, 67);
    expect(snapshot.overallStatus, 'Good');
    expect(snapshot.metrics.length, 5);
    expect(snapshot.priorityRecommendations.map((rec) => rec.title), [
      'Enable 2FA',
      'Backup Seed Phrase',
      'Review Token Approvals',
    ]);
    expect(snapshot.diversification.first.name, 'BTC');
    expect(snapshot.securityChecklist.length, 8);
    expect(
      snapshot.supportedStates,
      containsAll([
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-151 renders wallet health overview baseline shell', (
    tester,
  ) async {
    await pumpHealthScore(tester);

    expect(find.byType(WalletHealthScorePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Wallet Health'), findsOneWidget);
    expect(find.text('T\u1ED5ng quan'), findsOneWidget);
    expect(find.text('B\u1EA3o m\u1EADt'), findsOneWidget);
    expect(find.text('\u0110a d\u1EA1ng h\u00F3a'), findsOneWidget);
    expect(find.text('Overall Health Score'), findsOneWidget);
    expect(find.text('67'), findsOneWidget);
    expect(find.text('Good'), findsOneWidget);
    expect(find.text('Enable 2FA'), findsOneWidget);
    expect(find.text('Health Breakdown'), findsOneWidget);
    expect(find.text('Chi ti\u1EBFt \u0111i\u1EC3m'), findsOneWidget);
    expect(find.text('Security'), findsOneWidget);
    expect(find.text('Diversification'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Risk Management'), findsOneWidget);
    expect(find.text('Backup & Recovery'), findsOneWidget);
  });

  testWidgets('SC-151 first viewport reaches priority recommendation', (
    tester,
  ) async {
    await pumpHealthScore(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-151 WalletHealthScorePage',
      semanticLabel: 'Điểm sức khỏe ví - tổng quan, bảo mật và đa dạng hóa',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(WalletHealthScorePage.recommendationKey('r1')),
      targetLabel: 'the priority recommendation action',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-151 recommendation sheet has clear close action', (
    tester,
  ) async {
    await pumpHealthScore(tester);

    await tester.tap(find.byKey(WalletHealthScorePage.recommendationKey('r1')));
    await tester.pumpAndSettle();

    expect(find.text('Enable Now'), findsWidgets);
    expect(find.textContaining('not financial advice'), findsOneWidget);
    expect(find.byKey(WalletHealthScorePage.sheetCloseKey), findsOneWidget);

    await tester.tap(find.byKey(WalletHealthScorePage.sheetCloseKey));
    await tester.pumpAndSettle();
    expect(find.textContaining('not financial advice'), findsNothing);
  });

  testWidgets(
    'SC-151 secondary tabs render local security and diversity data',
    (tester) async {
      await pumpHealthScore(tester);

      await tester.tap(
        find.byKey(WalletHealthScorePage.tabKey('B\u1EA3o m\u1EADt')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Security Score'), findsOneWidget);
      expect(find.text('Security Checklist'), findsOneWidget);
      expect(find.text('2FA Enabled'), findsOneWidget);
      expect(find.text('Seed Phrase Backup'), findsOneWidget);
      expect(find.text('Cần xử lý'), findsOneWidget);

      await tester.tap(
        find.byKey(WalletHealthScorePage.tabKey('\u0110a d\u1EA1ng h\u00F3a')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Asset Distribution'), findsOneWidget);
      expect(find.text('BTC 42%'), findsOneWidget);
      expect(find.text('Stablecoins 18%'), findsOneWidget);
      expect(find.text('Concentration Risk'), findsOneWidget);
      expect(find.text('Diversification Tips'), findsOneWidget);
    },
  );
}
