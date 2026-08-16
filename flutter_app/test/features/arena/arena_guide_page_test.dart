import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_guide_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/arena_home_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_safety_center_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_studio_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpArenaGuide(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaGuide,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-209 mock repository exposes Arena Guide BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaGuide();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-guide');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.createSteps.length, 6);
    expect(snapshot.joinSteps.length, 4);
    expect(snapshot.proTips.length, greaterThanOrEqualTo(5));
    expect(snapshot.safetyTips.first.title, 'Points, không phải tiền thật');
    expect(snapshot.keyConcepts.first.term, 'Arena Points');
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

  testWidgets('SC-209 renders Arena Guide baseline', (tester) async {
    await pumpArenaGuide(tester);

    expect(find.byType(ArenaGuidePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hướng dẫn Arena'), findsOneWidget);
    expect(find.text('Hướng dẫn - Open Arena'), findsOneWidget);
    expect(find.text('Tạo challenge đầu tiên trong 5 phút'), findsOneWidget);
    expect(find.text('Tạo Challenge'), findsWidgets);
    expect(find.text('Chọn Template'), findsOneWidget);
    expect(find.text('So sánh challenge'), findsOneWidget);
    expect(find.text('Thuật ngữ quan trọng'), findsOneWidget);
  });

  testWidgets('SC-209 first viewport exposes guide mode controls', (
    tester,
  ) async {
    await pumpArenaGuide(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-209 ArenaGuidePage',
      semanticLabel:
          'Hướng dẫn sử dụng Arena - mẹo, an toàn và câu hỏi thường gặp',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaGuidePage.modeCreateKey),
      routeName: 'SC-209 ArenaGuidePage',
      actionLabel: 'the create guide mode',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-209 tab controls reveal tips, safety, and FAQ', (
    tester,
  ) async {
    await pumpArenaGuide(tester);

    await tester.tap(find.text('Mẹo hay'));
    await tester.pumpAndSettle();
    expect(find.text('Checklist trước khi đăng'), findsOneWidget);
    expect(find.text('Đặt tên hấp dẫn, rõ ràng'), findsOneWidget);

    await tester.tap(find.text('An toàn'));
    await tester.pumpAndSettle();
    expect(find.text('An toàn trong Arena'), findsOneWidget);
    expect(
      find.text('Points only - không có rủi ro tài chính'),
      findsOneWidget,
    );

    await tester.tap(find.text('FAQ'));
    await tester.pumpAndSettle();
    expect(find.text('Câu hỏi thường gặp'), findsOneWidget);
    await tester.tap(find.byKey(ArenaGuidePage.faqKey('0')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Points không phải tiền thật'), findsWidgets);
  });

  testWidgets('SC-209 primary CTA opens create and join destinations', (
    tester,
  ) async {
    await pumpArenaGuide(tester);

    await tester.ensureVisible(find.byKey(ArenaGuidePage.ctaKey));
    await tester.tap(find.byKey(ArenaGuidePage.ctaKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaStudioPage), findsOneWidget);

    await pumpArenaGuide(tester);
    await tester.tap(find.byKey(ArenaGuidePage.modeJoinKey));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(ArenaGuidePage.ctaKey));
    await tester.tap(find.byKey(ArenaGuidePage.ctaKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaHomePage), findsOneWidget);
  });

  testWidgets('SC-209 safety tab opens Safety Center', (tester) async {
    await pumpArenaGuide(tester);

    await tester.tap(find.text('An toàn'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Safety Center'));
    await tester.tap(find.text('Safety Center'));
    await tester.pumpAndSettle();

    expect(find.byType(ArenaSafetyCenterPage), findsOneWidget);
  });
}
