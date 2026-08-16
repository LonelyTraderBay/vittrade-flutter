import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_fund_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_score_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/settings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PInsuranceScore(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pInsuranceScore,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-240 mock repository exposes insurance score BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getInsuranceScore();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-insurance-score');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.overallScore, 78);
    expect(snapshot.maxScore, 100);
    expect(snapshot.grade, 'A');
    expect(snapshot.currentTier, 'Pro');
    expect(snapshot.potentialGain, 22);
    expect(snapshot.factors, hasLength(5));
    expect(snapshot.quickActions, hasLength(4));
    expect(snapshot.tierRequirements, hasLength(4));
    expect(snapshot.parentRoute, AppRoutePaths.p2pInsurance);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
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

  testWidgets('SC-240 renders protection score baseline in P2P shell', (
    tester,
  ) async {
    await pumpP2PInsuranceScore(tester);

    expect(find.byType(P2PInsuranceScorePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Điểm bảo vệ'), findsOneWidget);
    expect(find.text('Bảo hiểm · P2P'), findsOneWidget);
    expect(find.byKey(P2PInsuranceScorePage.scoreCardKey), findsOneWidget);
    expect(find.text('78'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('+22 điểm có thể cải thiện'), findsOneWidget);
    expect(find.byKey(P2PInsuranceScorePage.factorsKey), findsOneWidget);
    expect(find.text('Chi tiết điểm số'), findsOneWidget);
    expect(find.text('Xác minh danh tính'), findsOneWidget);
    expect(find.text('Lịch sử claims'), findsOneWidget);
    expect(find.text('Bảo mật tài khoản'), findsOneWidget);

    await tester.ensureVisible(find.text('Lộ trình nâng cấp'));
    expect(find.text('Cải thiện nhanh'), findsOneWidget);
    expect(find.text('Thiết lập Anti-Phishing Code'), findsOneWidget);
    expect(find.text('Lộ trình nâng cấp'), findsOneWidget);
    expect(find.text('Pro - HIỆN TẠI'), findsOneWidget);
    expect(find.text('Elite'), findsOneWidget);
  });

  testWidgets('SC-240 first viewport reaches score factors safely', (
    tester,
  ) async {
    await pumpP2PInsuranceScore(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-240 P2PInsuranceScorePage',
      semanticLabel: 'Điểm bảo vệ P2P',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(P2PInsuranceScorePage.factorsKey),
      targetLabel: 'score factor breakdown',
      minVisibleHeight: 80,
    );
    expect(
      tester.getSize(find.byKey(P2PInsuranceScorePage.scoreCardKey)).height,
      lessThanOrEqualTo(280),
      reason:
          'Protection score summary should not dominate the first viewport.',
    );
  });

  testWidgets('SC-240 navigation edges open parent, settings, and P2P', (
    tester,
  ) async {
    await pumpP2PInsuranceScore(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(P2PInsuranceFundPage), findsOneWidget);

    await pumpP2PInsuranceScore(tester);
    await tester.ensureVisible(
      find.byKey(
        P2PInsuranceScorePage.quickActionKey('Thiết lập Anti-Phishing Code'),
      ),
    );
    await tester.tap(
      find.byKey(
        P2PInsuranceScorePage.quickActionKey('Thiết lập Anti-Phishing Code'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);

    await pumpP2PInsuranceScore(tester);
    await tester.ensureVisible(
      find.byKey(
        P2PInsuranceScorePage.quickActionKey('Hoàn thành thêm 20 giao dịch'),
      ),
    );
    await tester.tap(
      find.byKey(
        P2PInsuranceScorePage.quickActionKey('Hoàn thành thêm 20 giao dịch'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('P2P'), findsOneWidget);
  });
}
