import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/arena_home_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_safety_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSafetyCenter(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaSafety,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-198 mock repository exposes Arena Safety BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaSafetyCenter();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-safety');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.communityRules.map((rule) => rule.title), [
      'Tôn trọng kết quả',
      'Không giao dịch ngoài nền tảng',
      'Ngôn ngữ văn minh',
      'Bảo vệ thông tin cá nhân',
    ]);
    expect(snapshot.bannedContent.length, 6);
    expect(snapshot.reportActions.map((action) => action.kind), [
      ArenaSafetyKind.report,
      ArenaSafetyKind.block,
    ]);
    expect(snapshot.violationProcess.last.title, 'Kết luận');
    expect(snapshot.quickLinks.map((link) => link.route), [
      AppRoutePaths.arenaBlocked,
      AppRoutePaths.arenaMyReports,
    ]);
    expect(snapshot.disclaimer, contains('không phải ví giao dịch hoặc PnL'));
    expect(
      snapshot.supportedStates,
      containsAll([
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-198 renders Arena Safety Center baseline', (tester) async {
    await pumpSafetyCenter(tester);

    expect(find.byType(ArenaSafetyCenterPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('An toàn & Quy tắc Arena'), findsOneWidget);
    expect(find.text('Trung tâm an toàn · Open Arena'), findsOneWidget);
    expect(find.text('Open Arena cam kết an toàn'), findsOneWidget);
    expect(find.text('Quy tắc cộng đồng'), findsWidgets);
    expect(find.text('Tôn trọng kết quả'), findsOneWidget);
    expect(find.text('Nội dung bị cấm'), findsOneWidget);
    expect(find.text('Spam, quảng cáo, link lạ'), findsOneWidget);
  });

  testWidgets('SC-198 first viewport reaches first community rule', (
    tester,
  ) async {
    await pumpSafetyCenter(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ArenaSafetyCenterPage',
      semanticLabel: 'An toàn và quy tắc Arena - trung tâm an toàn Open Arena',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ArenaSafetyCenterPage.firstCommunityRuleKey),
      targetLabel: 'first community rule',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-198 quick links use safe Arena routes', (tester) async {
    await pumpSafetyCenter(tester);

    await tester.ensureVisible(
      find.byKey(ArenaSafetyCenterPage.blockedLinkKey),
    );
    await tester.tap(find.byKey(ArenaSafetyCenterPage.blockedLinkKey));
    await tester.pumpAndSettle();
    expect(find.text('Người đã chặn'), findsOneWidget);

    await pumpSafetyCenter(tester);
    await tester.ensureVisible(
      find.byKey(ArenaSafetyCenterPage.reportsLinkKey),
    );
    await tester.tap(find.byKey(ArenaSafetyCenterPage.reportsLinkKey));
    await tester.pumpAndSettle();
    expect(find.text('Báo cáo của tôi'), findsOneWidget);
  });

  testWidgets('SC-198 acknowledge returns to Arena Home safely', (
    tester,
  ) async {
    await pumpSafetyCenter(tester);

    await tester.ensureVisible(
      find.byKey(ArenaSafetyCenterPage.acknowledgeKey),
    );
    await tester.tap(find.byKey(ArenaSafetyCenterPage.acknowledgeKey));
    await tester.pumpAndSettle();

    expect(find.byType(ArenaHomePage), findsOneWidget);
  });
}
