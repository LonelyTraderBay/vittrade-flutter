import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/kyc_page.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/transfer/withdraw_limits_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpWithdrawLimits(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletLimits,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder semanticsLabel(Pattern pattern) {
    return find.byWidgetPredicate((widget) {
      if (widget is! Semantics) return false;
      final label = widget.properties.label;
      if (label == null) return false;
      return switch (pattern) {
        String() => label == pattern,
        RegExp() => pattern.hasMatch(label),
        _ => false,
      };
    });
  }

  test('SC-153 mock repository exposes withdraw limits BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getWithdrawLimits();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-limits');
    expect(
      snapshot.actionDraft,
      'read-only + local navigation to /profile/kyc',
    );
    expect(snapshot.currentLevel, 2);
    expect(snapshot.currentTier.name, 'N\u00E2ng cao');
    expect(snapshot.tiers.length, 4);
    expect(snapshot.faqs.length, 3);
    expect(snapshot.dailyRemaining, 97550);
    expect(snapshot.monthlyRemaining, 481250);
    expect(snapshot.dailyPercent.toStringAsFixed(1), '2.5');
    expect(
      snapshot.supportedStates,
      containsAll([
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-153 renders withdraw limits baseline shell', (tester) async {
    await pumpWithdrawLimits(tester);

    expect(find.byType(WithdrawLimitsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('H\u1EA1n m\u1EE9c r\u00FAt ti\u1EC1n'), findsWidgets);
    expect(find.text('KYC Level 2'), findsWidgets);
    expect(find.text('N\u00E2ng cao'), findsWidgets);
    expect(find.text('\u0110\u00E3 x\u00E1c minh'), findsOneWidget);
    expect(find.text('\$2,450.00 / \$100,000.00'), findsOneWidget);
    expect(find.text('C\u00F2n l\u1EA1i: \$97,550.00'), findsOneWidget);
    expect(find.text('\$100,000.00'), findsWidgets);
    expect(find.text('\$50,000.00'), findsOneWidget);
    expect(find.text('\$500,000.00'), findsWidgets);
    expect(find.text('Level 0'), findsOneWidget);
    expect(find.text('Level 3'), findsOneWidget);
    expect(find.text('HI\u1EC6N T\u1EA0I'), findsOneWidget);
    expect(find.text('\u0110\u00E3 m\u1EDF'), findsWidgets);
    expect(find.text('X\u00E1c minh KYC'), findsOneWidget);
    expect(find.text('FAQ t\u0129nh'), findsOneWidget);
    expect(
      semanticsLabel(RegExp(r'C\u1EA7n KYC C\u1EA5p KYC 3')),
      findsOneWidget,
    );
  });

  testWidgets('SC-153 first viewport reaches current tier usage', (
    tester,
  ) async {
    await pumpWithdrawLimits(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'WithdrawLimitsPage',
      semanticLabel: 'Hạn mức rút tiền theo cấp KYC',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(WithdrawLimitsPage.currentTierKey),
      routeName: 'WithdrawLimitsPage',
      actionLabel: 'the current KYC tier summary',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(WithdrawLimitsPage.dailyUsageKey),
      routeName: 'WithdrawLimitsPage',
      actionLabel: 'the daily usage bar',
    );
  });

  testWidgets('SC-153 wires locked tier to KYC edge', (tester) async {
    await pumpWithdrawLimits(tester);

    expect(find.text('X\u00E1c minh KYC'), findsOneWidget);

    await tester.ensureVisible(find.byKey(WithdrawLimitsPage.tierKey(3)));
    await tester.tap(find.byKey(WithdrawLimitsPage.tierKey(3)));
    await tester.pumpAndSettle();

    expect(find.byType(KYCPage), findsOneWidget);
    expect(find.text('X\u00E1c minh danh t\u00EDnh'), findsOneWidget);
  });
}
