import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/cross_module/data/smart_alerts_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/phone/pages/smart_alert_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpSmartAlerts(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.smartAlerts,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-323 mock repository exposes smart alerts BE draft', () async {
    final snapshot = await const MockSmartAlertsRepository().getCenter();

    expect(snapshot.endpoint, '/api/mobile/cross-module/smart-alerts');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Smart Alerts');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.alerts.length, 7);
    expect(snapshot.activeCount, 6);
    expect(snapshot.totalTriggers, 36);
    expect(snapshot.moduleCount, 6);
    expect(snapshot.history.length, 3);
    expect(snapshot.templates.length, 7);
    expect(snapshot.contractNotes, contains('Open Arena alerts stay'));
    expect(
      snapshot.supportedStates,
      containsAll([
        SmartAlertsScreenState.loading,
        SmartAlertsScreenState.empty,
        SmartAlertsScreenState.error,
        SmartAlertsScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-323 renders active smart alert baseline', (tester) async {
    await pumpSmartAlerts(tester);

    expect(find.byType(SmartAlertCenterPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Smart Alerts'), findsWidgets);
    expect(find.text('Hoat dong'), findsOneWidget);
    expect(find.text('Lich su'), findsOneWidget);
    expect(find.text('Cai dat'), findsOneWidget);
    expect(find.text('7 total alerts'), findsOneWidget);
    expect(find.text('Price Alert'), findsOneWidget);
    expect(find.text('Order Status'), findsOneWidget);
    expect(find.text('Create Alert'), findsOneWidget);
    expect(find.byKey(SmartAlertCenterPage.createButtonKey), findsOneWidget);
  });

  testWidgets('SC-323 switches history and settings locally', (tester) async {
    await pumpSmartAlerts(tester);

    await tester.tap(
      find.byKey(SmartAlertCenterPage.tabKey(SmartAlertTab.history)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Alert History'), findsOneWidget);
    expect(find.text('BTC > \$70,000'), findsOneWidget);
    expect(find.text('Alert Statistics (30 days)'), findsOneWidget);

    await tester.tap(
      find.byKey(SmartAlertCenterPage.tabKey(SmartAlertTab.settings)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Notification Channels'), findsOneWidget);
    expect(find.text('SMS Alerts'), findsOneWidget);
    expect(find.text('Alert Templates'), findsOneWidget);

    await tester.tap(find.byKey(SmartAlertCenterPage.channelKey('sms')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Disabled'), findsNothing);
  });
}
