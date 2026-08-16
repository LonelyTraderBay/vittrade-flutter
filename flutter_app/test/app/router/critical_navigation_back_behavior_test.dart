import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/admin_home_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_methods_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/wallet/p2p_wallet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/address_book_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/wallet_page.dart';

void main() {
  Future<void> pumpRoute(WidgetTester tester, String initialLocation) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  final cases = [
    const _BackCase(
      id: 'SC-139 withdraw',
      path: AppRoutePaths.walletWithdraw,
      expectedParent: WalletPage,
    ),
    const _BackCase(
      id: 'SC-143 address add',
      path: AppRoutePaths.walletAddressBookAdd,
      expectedParent: AddressBookPage,
    ),
    const _BackCase(
      id: 'SC-150 token approval',
      path: AppRoutePaths.walletTokenApproval,
      expectedParent: WalletPage,
    ),
    const _BackCase(
      id: 'SC-232 P2P payment add',
      path: AppRoutePaths.p2pPaymentMethodAdd,
      expectedParent: P2PPaymentMethodsPage,
    ),
    const _BackCase(
      id: 'SC-261 P2P wallet transfer',
      path: AppRoutePaths.p2pWalletTransfer,
      expectedParent: P2PWalletPage,
    ),
    const _BackCase(
      id: 'SC-036 prediction risk calculator',
      path: AppRoutePaths.marketsPredictionsRiskCalculator,
      expectedParent: PredictionsHomePage,
    ),
    const _BackCase(
      id: 'SC-181 admin analytics',
      path: AppRoutePaths.adminAnalytics,
      expectedParent: AdminHomePage,
    ),
    const _BackCase(
      id: 'SC-182 admin A/B tests',
      path: AppRoutePaths.adminAbtests,
      expectedParent: AdminHomePage,
    ),
    const _BackCase(
      id: 'SC-183 admin funnels',
      path: AppRoutePaths.adminFunnels,
      expectedParent: AdminHomePage,
    ),
  ];

  for (final routeCase in cases) {
    testWidgets('${routeCase.id} header back returns to parent route', (
      tester,
    ) async {
      await pumpRoute(tester, routeCase.path);

      expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(routeCase.expectedParent), findsOneWidget);
    });
  }
}

final class _BackCase {
  const _BackCase({
    required this.id,
    required this.path,
    required this.expectedParent,
  });

  final String id;
  final String path;
  final Type expectedParent;
}
