import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_limit_orders_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_empty_state.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpLimitOrders(
    WidgetTester tester, {
    LaunchpadRepository? repository,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (repository != null)
            launchpadRepositoryProvider.overrideWithValue(repository),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadLimitOrders,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-315 mock repository exposes launchpad limit orders BE draft',
    () async {
      final snapshot = await const MockLaunchpadRepository(
        loadDelay: Duration.zero,
      ).getLimitOrders();

      expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-limit-orders');
      expect(
        snapshot.actionDraft,
        'POST /orders/:id/action where applicable; POST /launchpad/subscribe|claim|bridge where applicable',
      );
      expect(snapshot.title, 'Limit Orders');
      expect(snapshot.backRoute, AppRoutePaths.launchpad);
      expect(snapshot.tabs, ['Hoat dong', 'Lich su', 'Tao lenh']);
      expect(snapshot.orders, hasLength(4));
      expect(snapshot.activeOrders, hasLength(3));
      expect(snapshot.historyOrders, hasLength(1));
      expect(snapshot.activeOrders.first.symbol, 'ARB');
      expect(snapshot.filled24h, 3);
      expect(snapshot.totalValueLabel, r'$4.2K');
      expect(snapshot.contractNotes, contains('active/history orders'));
      expect(
        snapshot.supportedStates,
        containsAll([
          LaunchpadScreenState.loading,
          LaunchpadScreenState.empty,
          LaunchpadScreenState.error,
          LaunchpadScreenState.offline,
          LaunchpadScreenState.submitting,
          LaunchpadScreenState.success,
        ]),
      );
    },
  );

  testWidgets('SC-315 renders active limit orders baseline', (tester) async {
    await pumpLimitOrders(tester);

    expect(find.byType(LaunchpadLimitOrdersPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Limit Orders'), findsOneWidget);
    expect(find.byKey(LaunchpadLimitOrdersPage.tabsKey), findsOneWidget);
    expect(find.byKey(LaunchpadLimitOrdersPage.statsKey), findsOneWidget);
    expect(find.byKey(LaunchpadLimitOrdersPage.activeListKey), findsOneWidget);
    expect(
      find.byKey(LaunchpadLimitOrdersPage.orderKey('lo_001')),
      findsOneWidget,
    );
    expect(find.text('Buy ARB'), findsOneWidget);
    expect(find.text('Sell OP'), findsOneWidget);
    expect(find.text('Buy AVAX'), findsOneWidget);
    expect(find.text(r'$4.2K'), findsOneWidget);
    expect(find.text('PARTIAL OK'), findsWidgets);
  });

  testWidgets('SC-315 first viewport reaches first active order', (
    tester,
  ) async {
    await pumpLimitOrders(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-315 LaunchpadLimitOrdersPage',
      semanticLabel: 'Quản lý lệnh giới hạn giao dịch token',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadLimitOrdersPage.orderKey('lo_001')),
      routeName: 'SC-315 LaunchpadLimitOrdersPage',
      actionLabel: 'the first active limit order',
    );
  });

  testWidgets('SC-315 renders shared empty state for no active orders', (
    tester,
  ) async {
    await pumpLimitOrders(
      tester,
      repository: const _EmptyLimitOrdersRepository(),
    );

    expect(find.byType(VitEmptyState), findsOneWidget);
    expect(find.text('No active orders'), findsOneWidget);
    expect(find.text('Create a limit order to get started'), findsOneWidget);
  });

  testWidgets('SC-315 switches to history tab', (tester) async {
    await pumpLimitOrders(tester);

    await tester.tap(find.text('Lich su'));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadLimitOrdersPage.historyKey), findsOneWidget);
    expect(find.text('Lich su lenh'), findsOneWidget);
    expect(find.text('Buy MATIC'), findsOneWidget);
    expect(find.text('FILLED'), findsOneWidget);
  });

  testWidgets('SC-315 create tab previews and submits a limit order', (
    tester,
  ) async {
    await pumpLimitOrders(tester);

    await tester.tap(find.byKey(LaunchpadLimitOrdersPage.headerCreateKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadLimitOrdersPage.createKey), findsOneWidget);
    expect(find.text('Loai lenh'), findsOneWidget);

    await tester.enterText(
      find.byKey(LaunchpadLimitOrdersPage.targetFieldKey),
      '2.35',
    );
    await tester.enterText(
      find.byKey(LaunchpadLimitOrdersPage.amountFieldKey),
      '1000',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadLimitOrdersPage.previewKey), findsOneWidget);
    expect(find.text('BUY ARB'), findsOneWidget);
    expect(find.text(r'$2350.00'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadLimitOrdersPage.expiryKey('14')));
    await tester.tap(find.byKey(LaunchpadLimitOrdersPage.partialFillKey));
    await tester.pumpAndSettle();
    expect(find.text('14 days'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadLimitOrdersPage.ctaKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã tạo lệnh giới hạn'), findsOneWidget);
    expect(find.text('Mua 1000 ARB tại giá \$2.35.'), findsOneWidget);
  });

  testWidgets('SC-315 create tab switches order side', (tester) async {
    await pumpLimitOrders(tester);

    await tester.tap(find.text('Tao lenh'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(
        LaunchpadLimitOrdersPage.sideKey(LaunchpadLimitOrderSide.sell),
      ),
    );
    await tester.enterText(
      find.byKey(LaunchpadLimitOrdersPage.targetFieldKey),
      '2.10',
    );
    await tester.enterText(
      find.byKey(LaunchpadLimitOrdersPage.amountFieldKey),
      '500',
    );
    await tester.pumpAndSettle();

    expect(find.text('SELL ARB'), findsOneWidget);
  });

  testWidgets('SC-315 edit mini icon button shows a placeholder snackbar', (
    tester,
  ) async {
    await pumpLimitOrders(tester);

    final orderCard = find.byKey(LaunchpadLimitOrdersPage.orderKey('lo_001'));
    await tester.ensureVisible(orderCard);

    await tester.tap(
      find.descendant(
        of: orderCard,
        matching: find.byIcon(Icons.edit_outlined),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sửa lệnh sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-315 delete mini icon button shows a placeholder snackbar', (
    tester,
  ) async {
    await pumpLimitOrders(tester);

    final orderCard = find.byKey(LaunchpadLimitOrdersPage.orderKey('lo_001'));
    await tester.ensureVisible(orderCard);

    await tester.tap(
      find.descendant(
        of: orderCard,
        matching: find.byIcon(Icons.delete_outline_rounded),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Xóa lệnh sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-315 header back returns to launchpad', (tester) async {
    await pumpLimitOrders(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}

final class _EmptyLimitOrdersRepository implements LaunchpadRepository {
  const _EmptyLimitOrdersRepository();

  @override
  Future<LaunchpadLimitOrdersSnapshot> getLimitOrders() async {
    return const LaunchpadLimitOrdersSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-limit-orders',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Limit Orders',
      backRoute: AppRoutePaths.launchpad,
      tabs: ['Hoat dong', 'Lich su', 'Tao lenh'],
      orders: [],
      filled24h: 0,
      totalValueLabel: r'$0',
      contractNotes:
          'Empty-state test double for active/history orders and screenState coverage.',
      supportedStates: {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      },
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
