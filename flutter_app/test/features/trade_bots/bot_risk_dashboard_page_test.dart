import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/settings/bot_emergency_stop_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/dashboard/bot_risk_dashboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpRiskDashboard(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotRiskDashboard,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-120 mock repository exposes bot risk dashboard BE draft', () async {
    final snapshot = await const MockTradeBotsRepository(
      loadDelay: Duration.zero,
    ).getBotRiskDashboard();

    expect(snapshot.riskScore, 68);
    expect(snapshot.riskLabel, 'Rủi ro trung bình');
    expect(snapshot.drawdownPoints, hasLength(7));
    expect(snapshot.exposures, hasLength(3));
    expect(snapshot.varHistory, hasLength(7));
    expect(snapshot.safetyControls, hasLength(4));
    expect(snapshot.emergencyPath, '/trade/bots/emergency-stop');
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-risk-dashboard');
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

  testWidgets('SC-120 renders risk dashboard baseline in Trade shell', (
    tester,
  ) async {
    await pumpRiskDashboard(tester);

    expect(find.byType(BotRiskDashboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Bảng điều khiển rủi ro'), findsOneWidget);
    expect(find.text('Điểm rủi ro danh mục'), findsOneWidget);
    expect(find.text('68/100'), findsOneWidget);
    expect(find.text('Rủi ro trung bình'), findsWidgets);
    expect(find.text('Chỉ số quan trọng'), findsOneWidget);
    expect(find.text('Xu hướng sụt giảm vốn (24h)'), findsOneWidget);
    expect(find.text('Dừng khẩn cấp tất cả bot'), findsOneWidget);
    expect(find.text('Tổng quan rủi ro'), findsNothing);
  });

  testWidgets('SC-120 first viewport reaches critical metrics', (tester) async {
    await pumpRiskDashboard(tester);

    await tester.ensureVisible(find.text('Sụt giảm vốn'));
    await tester.pumpAndSettle();
    expect(find.text('Sụt giảm vốn'), findsOneWidget);
  });

  testWidgets('SC-120 emergency CTA navigates to SC-121 edge', (tester) async {
    await pumpRiskDashboard(tester);

    await tester.ensureVisible(
      find.byKey(BotRiskDashboardPage.emergencyButtonKey),
    );
    await tester.tap(find.byKey(BotRiskDashboardPage.emergencyButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(BotEmergencyStopPage), findsOneWidget);
    expect(find.text('Dừng khẩn cấp'), findsOneWidget);
  });
}
