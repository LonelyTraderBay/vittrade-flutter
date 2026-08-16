import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/network_status_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpNetworkStatus(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletNetworkStatus,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-155 mock repository exposes network status BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getNetworkStatus();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-network-status');
    expect(snapshot.actionDraft, 'read-only refresh');
    expect(snapshot.refreshIntervalSeconds, 4);
    expect(snapshot.networks.length, 7);
    expect(snapshot.operationalCount, 5);
    expect(snapshot.issueCount, 1);
    expect(snapshot.downCount, 1);
    expect(snapshot.networks.first.name, 'Bitcoin');
    expect(snapshot.networks.last.id, 'polygon');
    expect(
      snapshot.supportedStates,
      containsAll([
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-155 renders network status baseline shell', (tester) async {
    await pumpNetworkStatus(tester);

    expect(find.byType(NetworkStatusPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Tr\u1EA1ng th\u00E1i m\u1EA1ng'), findsWidgets);
    expect(
      find.text('1 m\u1EA1ng \u0111ang b\u1EA3o tr\u00EC'),
      findsOneWidget,
    );
    expect(find.text('Ho\u1EA1t \u0111\u1ED9ng'), findsOneWidget);
    expect(find.text('Ch\u1EADm / T\u1EAFc'), findsOneWidget);
    expect(find.text('B\u1EA3o tr\u00EC'), findsWidgets);
    expect(find.byKey(NetworkStatusPage.networkKey('btc')), findsOneWidget);
    expect(find.byKey(NetworkStatusPage.networkKey('eth')), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('Ethereum'), findsOneWidget);
    expect(find.text('25% - B\u00ECnh th\u01B0\u1EDDng'), findsOneWidget);
    expect(find.text('42% - Cao'), findsOneWidget);
    expect(find.text('N\u1EA1p OK'), findsWidgets);
    expect(find.text('R\u00FAt OK'), findsWidgets);
    expect(find.byKey(NetworkStatusPage.filterKey('all')), findsOneWidget);
    expect(find.byKey(NetworkStatusPage.filterKey('issues')), findsOneWidget);
  });

  testWidgets('SC-155 first viewport reaches first network card', (
    tester,
  ) async {
    await pumpNetworkStatus(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'NetworkStatusPage',
      semanticLabel: 'Trạng thái mạng - phí, độ trễ và tắc nghẽn',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(NetworkStatusPage.filterKey('all')),
      routeName: 'NetworkStatusPage',
      actionLabel: 'the status filter controls',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(NetworkStatusPage.networkKey('polygon')),
      routeName: 'NetworkStatusPage',
      actionLabel: 'the highest-risk network status card',
    );
  });

  testWidgets('SC-155 refresh and filters give visible feedback', (
    tester,
  ) async {
    await pumpNetworkStatus(tester);

    await tester.tap(find.byKey(NetworkStatusPage.refreshKey));
    await tester.pump();

    expect(find.byKey(NetworkStatusPage.refreshFeedbackKey), findsOneWidget);
    expect(
      find.text(
        '\u0110\u00E3 l\u00E0m m\u1EDBi tr\u1EA1ng th\u00E1i m\u1EA1ng',
      ),
      findsWidgets,
    );

    await tester.tap(find.byKey(NetworkStatusPage.filterKey('maintenance')));
    await tester.pumpAndSettle();

    expect(find.byKey(NetworkStatusPage.networkKey('polygon')), findsOneWidget);
    expect(find.byKey(NetworkStatusPage.networkKey('btc')), findsNothing);
    expect(find.text('B\u1EA3o tr\u00EC (1)'), findsOneWidget);
  });

  testWidgets('SC-155 full list includes maintenance and legend', (
    tester,
  ) async {
    await pumpNetworkStatus(tester);

    await tester.drag(
      find.byKey(NetworkStatusPage.contentKey),
      const Offset(0, -1800),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(NetworkStatusPage.networkKey('polygon')), findsOneWidget);
    expect(find.text('Polygon'), findsOneWidget);
    expect(find.text('N\u1EA1p T\u1EA1m d\u1EEBng'), findsOneWidget);
    expect(find.text('R\u00FAt T\u1EA1m d\u1EEBng'), findsOneWidget);
    expect(
      find.text('Ch\u00FA th\u00EDch tr\u1EA1ng th\u00E1i'),
      findsOneWidget,
    );
  });
}
