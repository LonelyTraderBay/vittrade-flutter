import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/presentation/pages/hub/arena_home_page.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/pages/topic_hub_page.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/pages/unified_search_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/pages/hub/dca_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/hub/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/notifications/presentation/pages/notifications_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/pages/hub/p2p_home_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/pages/payment/p2p_payment_method_add_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/pages/payment/p2p_payment_methods_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/features/referral/presentation/pages/referral_home_page.dart';
import 'package:vit_trade_flutter/features/rewards/presentation/pages/rewards_hub_page.dart';
import 'package:vit_trade_flutter/features/support/presentation/pages/support_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/convert/convert_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/hub/copy_trading_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/margin/margin_trading_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/hub/trade_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/hub/trading_bots_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/hub/wallet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/withdraw_page.dart';

void main() {
  Future<GoRouter> pumpApp(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.home,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = createAppRouter(initialLocation: initialLocation);
    await tester.pumpWidget(
      ProviderScope(child: VitTradeApp(routerConfig: router)),
    );
    await tester.pumpAndSettle();
    return router;
  }

  Future<void> pushFromHome(WidgetTester tester, String path) async {
    final router = await pumpApp(tester);
    unawaited(router.push(path));
    await tester.pumpAndSettle();
  }

  Future<void> tapHeaderBack(WidgetTester tester) async {
    final back = find.byIcon(Icons.chevron_left_rounded).first;
    expect(back, findsOneWidget);
    await tester.tap(back);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Home product navigation pushes so Chuyển đổi back returns Home',
    (tester) async {
      await pumpApp(tester);

      final convertCard = find.text('Chuyển đổi').first;
      await tester.ensureVisible(convertCard);
      await tester.tap(convertCard);
      await tester.pumpAndSettle();

      expect(find.byType(ConvertPage), findsOneWidget);

      await tapHeaderBack(tester);

      expect(find.byType(HomePage), findsOneWidget);
    },
  );

  for (final routeCase in _homeEntryCases) {
    testWidgets('${routeCase.label} returns to Home when pushed from Home', (
      tester,
    ) async {
      await pushFromHome(tester, routeCase.path);

      expect(find.byType(routeCase.entryPage), findsOneWidget);

      await tapHeaderBack(tester);

      expect(find.byType(HomePage), findsOneWidget);
    });
  }

  testWidgets('Trade pair direct entry falls back to Trade root', (
    tester,
  ) async {
    await pumpApp(tester, initialLocation: '/trade/btcusdt');

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byKey(TradePage.backKey), findsOneWidget);

    await tapHeaderBack(tester);

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byKey(TradePage.backKey), findsNothing);
  });

  testWidgets('Markets root keeps Home history for system back', (
    tester,
  ) async {
    final router = await pumpApp(tester);
    unawaited(router.push(AppRoutePaths.markets));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('P2P child back returns to child parent instead of Home', (
    tester,
  ) async {
    final router = await pumpApp(tester);
    unawaited(router.push(AppRoutePaths.p2p));
    await tester.pumpAndSettle();
    unawaited(router.push(AppRoutePaths.p2pPaymentMethodAdd));
    await tester.pumpAndSettle();

    expect(find.byType(P2PPaymentMethodAddPage), findsOneWidget);

    await tapHeaderBack(tester);

    expect(find.byType(P2PPaymentMethodsPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  for (final routeCase in _directFallbackCases) {
    testWidgets('${routeCase.label} direct entry falls back to parent', (
      tester,
    ) async {
      await pumpApp(tester, initialLocation: routeCase.path);

      expect(find.byType(routeCase.entryPage), findsOneWidget);

      await tapHeaderBack(tester);

      expect(find.byType(routeCase.parentPage), findsOneWidget);
    });
  }
}

const _homeEntryCases = [
  _HomeEntryCase(
    label: 'Search',
    path: AppRoutePaths.search,
    entryPage: UnifiedSearchPage,
  ),
  _HomeEntryCase(
    label: 'Notifications',
    path: AppRoutePaths.notifications,
    entryPage: NotificationsPage,
  ),
  _HomeEntryCase(
    label: 'Trade pair',
    path: '/trade/btcusdt',
    entryPage: TradePage,
  ),
  _HomeEntryCase(
    label: 'Margin',
    path: AppRoutePaths.tradeMargin,
    entryPage: MarginTradingPage,
  ),
  _HomeEntryCase(
    label: 'Bot',
    path: AppRoutePaths.tradeBots,
    entryPage: TradingBotsPage,
  ),
  _HomeEntryCase(
    label: 'Copy Trading',
    path: AppRoutePaths.tradeCopyTrading,
    entryPage: CopyTradingPage,
  ),
  _HomeEntryCase(label: 'P2P', path: AppRoutePaths.p2p, entryPage: P2PHomePage),
  _HomeEntryCase(label: 'DCA', path: AppRoutePaths.dca, entryPage: DCAPage),
  _HomeEntryCase(
    label: 'Staking',
    path: AppRoutePaths.earnStaking,
    entryPage: StakingEarnPage,
  ),
  _HomeEntryCase(
    label: 'Savings',
    path: AppRoutePaths.earnSavings,
    entryPage: SavingsPage,
  ),
  _HomeEntryCase(
    label: 'Launchpad',
    path: AppRoutePaths.launchpad,
    entryPage: LaunchpadPage,
  ),
  _HomeEntryCase(
    label: 'Prediction Markets',
    path: AppRoutePaths.marketsPredictions,
    entryPage: PredictionsHomePage,
  ),
  _HomeEntryCase(
    label: 'Arena',
    path: AppRoutePaths.arena,
    entryPage: ArenaHomePage,
  ),
  _HomeEntryCase(
    label: 'Rewards',
    path: AppRoutePaths.rewards,
    entryPage: RewardsHubPage,
  ),
  _HomeEntryCase(
    label: 'Support',
    path: AppRoutePaths.support,
    entryPage: SupportPage,
  ),
  _HomeEntryCase(
    label: 'Topics',
    path: AppRoutePaths.topics,
    entryPage: TopicHubPage,
  ),
  _HomeEntryCase(
    label: 'Referral',
    path: AppRoutePaths.referral,
    entryPage: ReferralHomePage,
  ),
  _HomeEntryCase(
    label: 'Wallet',
    path: AppRoutePaths.wallet,
    entryPage: WalletPage,
  ),
  _HomeEntryCase(
    label: 'Withdraw next action',
    path: '/wallet/withdraw/USDT',
    entryPage: WithdrawPage,
  ),
  _HomeEntryCase(
    label: 'Market pair row',
    path: '/pair/btcusdt',
    entryPage: PairDetailPage,
  ),
];

const _directFallbackCases = [
  _DirectFallbackCase(
    label: 'Convert',
    path: AppRoutePaths.tradeConvert,
    entryPage: ConvertPage,
    parentPage: TradePage,
  ),
  _DirectFallbackCase(
    label: 'Margin',
    path: AppRoutePaths.tradeMargin,
    entryPage: MarginTradingPage,
    parentPage: TradePage,
  ),
  _DirectFallbackCase(
    label: 'Bot',
    path: AppRoutePaths.tradeBots,
    entryPage: TradingBotsPage,
    parentPage: TradePage,
  ),
  _DirectFallbackCase(
    label: 'Copy Trading',
    path: AppRoutePaths.tradeCopyTrading,
    entryPage: CopyTradingPage,
    parentPage: TradePage,
  ),
  _DirectFallbackCase(
    label: 'DCA',
    path: AppRoutePaths.dca,
    entryPage: DCAPage,
    parentPage: TradePage,
  ),
  _DirectFallbackCase(
    label: 'Savings',
    path: AppRoutePaths.earnSavings,
    entryPage: SavingsPage,
    parentPage: StakingEarnPage,
  ),
  _DirectFallbackCase(
    label: 'Prediction Markets',
    path: AppRoutePaths.marketsPredictions,
    entryPage: PredictionsHomePage,
    parentPage: MarketListPage,
  ),
  _DirectFallbackCase(
    label: 'Withdraw',
    path: '/wallet/withdraw/USDT',
    entryPage: WithdrawPage,
    parentPage: WalletPage,
  ),
  _DirectFallbackCase(
    label: 'Market pair row',
    path: '/pair/btcusdt',
    entryPage: PairDetailPage,
    parentPage: MarketListPage,
  ),
];

final class _HomeEntryCase {
  const _HomeEntryCase({
    required this.label,
    required this.path,
    required this.entryPage,
  });

  final String label;
  final String path;
  final Type entryPage;
}

final class _DirectFallbackCase {
  const _DirectFallbackCase({
    required this.label,
    required this.path,
    required this.entryPage,
    required this.parentPage,
  });

  final String label;
  final String path;
  final Type entryPage;
  final Type parentPage;
}
