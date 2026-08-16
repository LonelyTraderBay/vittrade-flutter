import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/copy_trading_card_demo.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpCopyCardDemo(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.demoCopyCard,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-401 mock repository exposes copy card demo BE draft', () async {
    final snapshot = await const MockTradeCopyTradingRepository(
      loadDelay: Duration.zero,
    ).getCopyCardDemo();

    expect(snapshot.endpoint, '/api/mobile/demo/demo-copy-card');
    expect(
      snapshot.actionDraft,
      'POST /copy-trading/follow|configure|stop where applicable',
    );
    expect(snapshot.title, 'Phân tích thẻ sao chép');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.metrics.traders, 5);
    expect(snapshot.metrics.copiers, 11000);
    expect(snapshot.metrics.aumUsd, 19250000);
    expect(snapshot.variants, hasLength(3));
    expect(snapshot.issues, hasLength(7));
    expect(snapshot.contractNotes, contains('internal role or dev flag'));
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-401 renders hero, tabular and compact variants', (
    tester,
  ) async {
    await pumpCopyCardDemo(tester);

    expect(find.byType(CopyTradingCardDemo), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân tích thẻ sao chép'), findsOneWidget);
    expect(find.byKey(CopyTradingCardDemo.analysisKey), findsOneWidget);
    expect(find.text('Enterprise Fintech Card Analysis'), findsOneWidget);
    expect(find.text('Variant A: Hero Metric Pattern'), findsOneWidget);
    expect(find.byKey(CopyTradingCardDemo.cardKey('hero')), findsOneWidget);
    expect(find.text(r'$19.25M'), findsWidgets);
    expect(find.text('11K'), findsWidgets);

    await tester.ensureVisible(
      find.byKey(CopyTradingCardDemo.variantKey('compact')),
    );
    await tester.pump();

    expect(find.text('Variant B: Financial Dashboard Pattern'), findsOneWidget);
    expect(
      find.text('Variant C: Compact (Original Structure Refined)'),
      findsOneWidget,
    );
    expect(find.byKey(CopyTradingCardDemo.cardKey('compact')), findsOneWidget);
  });

  testWidgets('SC-401 lower analysis sections render', (tester) async {
    await pumpCopyCardDemo(tester);

    await tester.ensureVisible(find.byKey(CopyTradingCardDemo.matrixKey));
    await tester.pump();

    expect(find.text('Compliance Comparison Matrix'), findsOneWidget);
    expect(find.text('Variant A'), findsWidgets);
    expect(find.text('Visual Hierarchy'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(CopyTradingCardDemo.recommendationKey),
    );
    await tester.pump();

    expect(
      find.text('Original Card Issues (Enterprise Standards)'),
      findsOneWidget,
    );
    expect(find.text('Final Recommendation'), findsOneWidget);
    expect(find.text('Guidelines Compliance'), findsOneWidget);
  });

  testWidgets('SC-401 header back returns home', (tester) async {
    await pumpCopyCardDemo(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(HomePage), findsOneWidget);
  });
}
