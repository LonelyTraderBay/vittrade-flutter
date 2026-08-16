import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/safety/copy_education_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/copy_trading_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCopyEducation(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyEducation,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-065 mock repository exposes copy education BE draft', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getCopyEducation();

    expect(snapshot.trade.copyProviders, isNotEmpty);
    expect(snapshot.defaultTab, 'how-it-works');
    expect(snapshot.tabs.map((tab) => tab.id), [
      'how-it-works',
      'scenarios',
      'fees',
      'mistakes',
      'regulatory',
    ]);
    expect(snapshot.steps, hasLength(4));
    expect(snapshot.copyModes, hasLength(3));
    expect(snapshot.concepts, hasLength(4));
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

  testWidgets('SC-065 renders CopyEducationPage inside the Trade shell', (
    tester,
  ) async {
    await pumpCopyEducation(tester);

    expect(find.byType(CopyEducationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hướng dẫn Copy Trading'), findsOneWidget);
    expect(find.text('Học trước khi đầu tư'), findsOneWidget);
    expect(find.text('Cơ chế'), findsOneWidget);
    expect(find.text('Kịch bản'), findsOneWidget);
    expect(find.text('Sai lầm'), findsOneWidget);
    expect(find.text('Quy định'), findsOneWidget);
    expect(find.text('Copy Trading hoạt động như thế nào?'), findsOneWidget);
    expect(find.text('Chọn provider'), findsOneWidget);
    expect(find.text('Sao chép tự động'), findsOneWidget);
    expect(find.text('Các chế độ sao chép'), findsOneWidget);
    expect(find.text('Mirror Copy'), findsOneWidget);
  });

  testWidgets('SC-065 first viewport reaches education tabs', (tester) async {
    await pumpCopyEducation(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-065 CopyEducationPage',
      semanticLabel: 'Hướng dẫn Copy Trading',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(CopyEducationPage.tabKey('fees')),
      routeName: 'SC-065 CopyEducationPage',
      actionLabel: 'the education fee tab',
    );
  });

  testWidgets('SC-065 tab buttons switch educational content', (tester) async {
    await pumpCopyEducation(tester);

    await tester.tap(find.byKey(CopyEducationPage.tabKey('fees')));
    await tester.pumpAndSettle();

    expect(find.text('Phí & Chi phí'), findsOneWidget);
    expect(find.textContaining('Tính platform fee'), findsOneWidget);
  });

  testWidgets('SC-065 provider CTA navigates back to CopyTradingPage', (
    tester,
  ) async {
    await pumpCopyEducation(tester);

    await tester.ensureVisible(find.byKey(CopyEducationPage.providerCtaKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(CopyEducationPage.providerCtaKey));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsOneWidget);
    expect(find.byType(CopyEducationPage), findsNothing);
  });

  testWidgets('SC-065 back returns to SC-063 CopyTradingPage', (tester) async {
    await pumpCopyEducation(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsOneWidget);
    expect(find.byType(CopyEducationPage), findsNothing);
  });
}
