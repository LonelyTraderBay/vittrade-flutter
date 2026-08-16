import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/governance/regulatory_inspection_ready_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpInspection(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyRegulatoryInspectionReady,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-116 mock repository exposes inspection readiness BE draft',
    () async {
      final snapshot = await const MockTradeRegulatoryRepository(
        loadDelay: Duration.zero,
      ).getRegulatoryInspectionReady();

      expect(snapshot.complianceScore, 97);
      expect(snapshot.stats.map((stat) => stat.value), [
        '10',
        '3.4k',
        '45k',
        '7yr',
      ]);
      expect(snapshot.frameworks.map((framework) => framework.name), [
        'MiFID II',
        'PRIIPs Regulation',
        'FCA CASS 7',
        'FCA DISP',
      ]);
      expect(snapshot.documents, hasLength(10));
      expect(snapshot.portalCta, 'Inspector Portal Access');
      expect(snapshot.reportCta, 'Download Full Compliance Report (PDF)');
      expect(
        snapshot.endpoint,
        '/api/mobile/trade/trade-copy-trading-regulatory-inspection-ready',
      );
      expect(snapshot.actionDraft, contains('POST /copy-trading/follow'));
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

  testWidgets('SC-116 renders inspection readiness in Trade shell', (
    tester,
  ) async {
    await pumpInspection(tester);

    expect(find.byType(RegulatoryInspectionReadyPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Regulatory Compliance'), findsOneWidget);
    expect(find.text('Inspection Ready Dashboard'), findsOneWidget);
    expect(find.text('97%'), findsOneWidget);
    expect(find.text('Regulatory Framework Coverage'), findsOneWidget);
    expect(find.text('MiFID II'), findsOneWidget);
    expect(find.text('PRIIPs Regulation'), findsOneWidget);
  });

  testWidgets('SC-116 first viewport reaches regulatory framework coverage', (
    tester,
  ) async {
    await pumpInspection(tester);

    expectFirstViewportVisible(
      tester,
      find.text('MiFID II'),
      targetLabel: 'first regulatory framework card',
    );
  });

  testWidgets('SC-116 exposes document repository and inspector actions', (
    tester,
  ) async {
    await pumpInspection(tester);

    await tester.drag(
      find.byKey(RegulatoryInspectionReadyPage.contentKey),
      const Offset(0, -1250),
    );
    await tester.pumpAndSettle();

    expect(find.text('Document Repository'), findsOneWidget);
    expect(find.text('Transaction Reports (ARM)'), findsOneWidget);
    expect(find.text('Audit Trail Logs'), findsOneWidget);

    await tester.drag(
      find.byKey(RegulatoryInspectionReadyPage.contentKey),
      const Offset(0, -700),
    );
    await tester.pumpAndSettle();

    expect(find.text('Regulatory Inspector Access'), findsOneWidget);
    expect(find.byKey(RegulatoryInspectionReadyPage.portalKey), findsOneWidget);
    expect(find.byKey(RegulatoryInspectionReadyPage.reportKey), findsOneWidget);
  });
}
