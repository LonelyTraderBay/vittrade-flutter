import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/wallet_token_approval_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTokenApprovals(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletTokenApproval,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-150 mock repository exposes token approval BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getTokenApprovals();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-token-approval');
    expect(snapshot.actionDraft, contains('revoke-preview'));
    expect(snapshot.approvals.length, 5);
    expect(snapshot.criticalCount, 1);
    expect(snapshot.highRiskCount, 1);
    expect(snapshot.unlimitedCount, 3);
    expect(snapshot.unusedCount, 1);
    expect(snapshot.riskSortedApprovals.first.token, 'WETH');
    expect(snapshot.riskSortedApprovals.first.maskedSpender, '0x1234...7890');
    expect(snapshot.revokedApprovals.length, 2);
    expect(
      snapshot.supportedStates,
      containsAll([
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.submitting,
        WalletScreenState.success,
      ]),
    );
  });

  testWidgets('SC-150 renders token approvals active baseline shell', (
    tester,
  ) async {
    await pumpTokenApprovals(tester);

    expect(find.byType(WalletTokenApprovalPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Phê duyệt token'), findsOneWidget);
    expect(find.text('Ho\u1EA1t \u0111\u1ED9ng'), findsOneWidget);
    expect(find.text('L\u1ECBch s\u1EED'), findsOneWidget);
    expect(find.text('C\u00E0i \u0111\u1EB7t'), findsOneWidget);
    expect(find.text('5 active approvals'), findsOneWidget);
    expect(find.text('Critical Risk'), findsOneWidget);
    expect(find.text('High Risk'), findsOneWidget);
    expect(find.text('Critical Security Risk'), findsOneWidget);
    expect(find.text('Active Approvals'), findsOneWidget);
    expect(find.text('WETH'), findsOneWidget);
    expect(find.text('\u2192 Unknown Contract'), findsOneWidget);
    expect(find.text('0x1234...7890'), findsOneWidget);
    expect(find.textContaining('Unlimited'), findsWidgets);
    expect(find.text('UNI'), findsOneWidget);
    expect(find.text('USDT'), findsOneWidget);
    expect(find.text('DAI'), findsOneWidget);
    expect(find.text('USDC'), findsOneWidget);
    expect(find.text('Revoke All High-Risk Approvals'), findsOneWidget);
    expect(
      find.textContaining('Token approvals allow smart contracts'),
      findsOneWidget,
    );
  });

  testWidgets('SC-150 revoke confirmation and secondary tabs are local', (
    tester,
  ) async {
    await pumpTokenApprovals(tester);

    await tester.tap(find.byKey(WalletTokenApprovalPage.revokeKey('a3')));
    await tester.pumpAndSettle();
    expect(find.text('Thu hồi phê duyệt WETH'), findsOneWidget);
    expect(
      find.textContaining('Xem lại bên chi tiêu, token, hạn mức'),
      findsOneWidget,
    );
    expect(find.text('Bên chi tiêu'), findsOneWidget);
    expect(find.text('Unknown Contract (0x1234...7890)'), findsOneWidget);
    expect(find.text('Token'), findsOneWidget);
    expect(find.text('WETH'), findsWidgets);
    expect(find.text('Hạn mức'), findsOneWidget);
    expect(find.textContaining('Unlimited'), findsWidgets);
    expect(find.text('Ước tính gas'), findsOneWidget);
    expect(find.text('Tác động'), findsOneWidget);
    expect(
      find.textContaining('Không hoàn tác sau khi xác nhận'),
      findsWidgets,
    );
    expect(find.textContaining('mock flow'), findsNothing);
    await tester.tap(find.byKey(WalletTokenApprovalPage.revokeSheetCancelKey));
    await tester.pumpAndSettle();
    expect(find.text('Thu hồi phê duyệt WETH'), findsNothing);

    await tester.tap(
      find.byKey(WalletTokenApprovalPage.tabKey('L\u1ECBch s\u1EED')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Revoked Approvals'), findsOneWidget);
    expect(find.textContaining('SHIB'), findsOneWidget);
    expect(find.text('Funds Protected'), findsOneWidget);

    await tester.tap(
      find.byKey(WalletTokenApprovalPage.tabKey('C\u00E0i \u0111\u1EB7t')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Security Settings'), findsOneWidget);
    expect(find.text('Auto-revoke Unused Approvals'), findsOneWidget);
    expect(find.text('Scan for Risky Approvals'), findsOneWidget);
  });

  testWidgets('SC-150 first viewport reaches approval controls', (
    tester,
  ) async {
    await pumpTokenApprovals(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-150 WalletTokenApprovalPage',
      semanticLabel: 'Phê duyệt token - xem và thu hồi quyền truy cập',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(WalletTokenApprovalPage.tabKey('Ho\u1EA1t \u0111\u1ED9ng')),
      routeName: 'SC-150 WalletTokenApprovalPage',
      actionLabel: 'active approvals tab',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(WalletTokenApprovalPage.approvalKey('a3')),
      routeName: 'SC-150 WalletTokenApprovalPage',
      actionLabel: 'critical approval row',
    );
  });
}
