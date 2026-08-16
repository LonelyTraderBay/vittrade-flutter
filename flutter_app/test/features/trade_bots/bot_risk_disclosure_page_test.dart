import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/settings/bot_risk_disclosure_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/settings/bot_suitability_assessment_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRiskDisclosure(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotRiskDisclosure,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-118 mock repository exposes bot risk BE draft', () async {
    final snapshot = await const MockTradeBotsRepository(
      loadDelay: Duration.zero,
    ).getBotRiskDisclosure();

    expect(snapshot.highRiskTitle, 'CẢNH BÁO RỦI RO CAO');
    expect(snapshot.categories, hasLength(6));
    expect(snapshot.categories.first.title, 'Rủi ro biến động thị trường');
    expect(snapshot.additionalWarnings, hasLength(5));
    expect(snapshot.regulatoryTitle, 'Tuân thủ MiFID II / ESMA / SEC');
    expect(snapshot.disabledCta, 'Xác nhận rủi ro để tiếp tục');
    expect(snapshot.enabledCta, 'Tôi đã hiểu rủi ro - Tiếp tục');
    expect(snapshot.nextPath, AppRoutePaths.tradeBotSuitabilityAssessment);
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-risk-disclosure');
    expect(snapshot.actionDraft, contains('POST /bots/create'));
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
  });

  testWidgets('SC-118 renders risk disclosure baseline in Trade shell', (
    tester,
  ) async {
    await pumpRiskDisclosure(tester);

    expect(find.byType(BotRiskDisclosurePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Công bố rủi ro'), findsOneWidget);
    expect(find.text('CẢNH BÁO RỦI RO CAO'), findsOneWidget);
    expect(
      find.text('Miễn trừ trách nhiệm về hiệu suất quá khứ'),
      findsOneWidget,
    );
    expect(find.text('Các hạng mục rủi ro'), findsOneWidget);
    expect(find.text('Rủi ro biến động thị trường'), findsOneWidget);
    expect(find.text('Xác nhận rủi ro để tiếp tục'), findsOneWidget);
  });

  testWidgets('SC-118 first viewport reaches first risk category', (
    tester,
  ) async {
    await pumpRiskDisclosure(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-118 BotRiskDisclosurePage',
      semanticLabel: 'Công bố rủi ro khi sử dụng bot giao dịch',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(BotRiskDisclosurePage.categoryKey('market')),
      targetLabel: 'the first bot risk category card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-118 acknowledgment enables canonical suitability route', (
    tester,
  ) async {
    await pumpRiskDisclosure(tester);

    await tester.ensureVisible(
      find.byKey(BotRiskDisclosurePage.acknowledgmentKey),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(BotRiskDisclosurePage.ctaKey));
    await tester.pumpAndSettle();
    expect(find.byType(BotRiskDisclosurePage), findsOneWidget);

    await tester.tap(find.byKey(BotRiskDisclosurePage.acknowledgmentKey));
    await tester.pumpAndSettle();
    expect(find.text('Tôi đã hiểu rủi ro - Tiếp tục'), findsOneWidget);

    await tester.tap(find.byKey(BotRiskDisclosurePage.ctaKey));
    await tester.pumpAndSettle();
    expect(find.byType(BotSuitabilityAssessmentPage), findsOneWidget);
    expect(find.text('Đánh giá mức độ phù hợp'), findsOneWidget);
  });
}
