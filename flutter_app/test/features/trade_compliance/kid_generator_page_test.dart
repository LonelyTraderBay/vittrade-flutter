import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/disclosures/ex_ante_costs_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/disclosures/kid_generator_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpKidGenerator(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.tradeCopyKidGenerator,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-108 mock repository exposes KID generator BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getKidGenerator();

    expect(snapshot.document.title, 'Mirror Copy Trading - KID');
    expect(snapshot.document.documentType, 'PRIIPs KID');
    expect(snapshot.document.pages, 3);
    expect(snapshot.document.maxPages, 3);
    expect(snapshot.sections.map((section) => section.title), [
      'Product Overview',
      'Investment Objectives',
      'Risk & Reward Profile',
      'Performance Scenarios',
      'Costs',
      'Holding Period',
      'Additional Information',
    ]);
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-kid-generator',
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
  });

  testWidgets('SC-108 renders KID generator in Trade shell', (tester) async {
    await pumpKidGenerator(tester);

    expect(find.byType(KIDGeneratorPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Key Information Document'), findsOneWidget);
    expect(find.text('PRIIPs KID'), findsWidgets);
    expect(find.text('Mandatory PRIIPs Document'), findsOneWidget);
    expect(find.text('Mirror Copy Trading - KID'), findsOneWidget);
    expect(find.text('Document Sections'), findsOneWidget);
    expect(find.text('Product Overview'), findsOneWidget);
    expect(find.text('Holding Period'), findsOneWidget);
    expect(find.text('Download PDF'), findsOneWidget);
  });

  testWidgets('SC-105 KID quick link opens SC-108 route', (tester) async {
    await pumpKidGenerator(
      tester,
      initialLocation: AppRoutePaths.tradeCopyExAnteCosts,
    );

    await tester.drag(
      find.byKey(ExAnteCostsPage.contentKey),
      const Offset(0, -760),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ExAnteCostsPage.kidKey));
    await tester.pumpAndSettle();

    expect(find.byType(KIDGeneratorPage), findsOneWidget);
    expect(find.text('Key Information Document'), findsOneWidget);
  });

  testWidgets(
    'SC-108 preview KID shows a coming-soon notice sheet without crashing',
    (tester) async {
      await pumpKidGenerator(tester);

      await tester.scrollUntilVisible(
        find.byKey(KIDGeneratorPage.previewKey),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(KIDGeneratorPage.previewKey));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Xem trước KID sẽ sớm ra mắt'), findsOneWidget);
    },
  );
}
