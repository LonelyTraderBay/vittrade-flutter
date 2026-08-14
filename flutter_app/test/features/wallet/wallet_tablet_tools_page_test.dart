import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_gas_optimizer_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_health_score_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_multi_manager_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_token_approval_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/withdraw_limits_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/dust_converter_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/network_status_tablet_page.dart';

void main() {
  Future<void> pumpTabletRoute(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: location,
            surface: AppSurface.tablet,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-148 tablet route uses independent composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.walletMultiManager);

    expect(find.byType(WalletMultiManagerTabletPage), findsOneWidget);
    expect(find.text('Quản lý đa ví'), findsOneWidget);
    expect(
      find.byKey(WalletMultiManagerTabletPage.addWalletKey),
      findsOneWidget,
    );

    await tester.tap(find.byKey(WalletMultiManagerTabletPage.addWalletKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(WalletMultiManagerTabletPage.addWalletNoticeKey),
      findsOneWidget,
    );
  });

  testWidgets('SC-149 tablet route uses independent composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.walletGasOptimizer);

    expect(find.byType(WalletGasOptimizerTabletPage), findsOneWidget);
    expect(find.text('Tối ưu phí gas'), findsOneWidget);
    expect(find.byKey(WalletGasOptimizerTabletPage.refreshKey), findsOneWidget);

    await tester.tap(find.byKey(WalletGasOptimizerTabletPage.refreshKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(WalletGasOptimizerTabletPage.feedbackKey),
      findsOneWidget,
    );
  });

  testWidgets('SC-151 tablet route uses independent composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.walletHealthScore);

    expect(find.byType(WalletHealthScoreTabletPage), findsOneWidget);
    expect(find.text('Điểm sức khỏe ví'), findsOneWidget);
    expect(
      find.byKey(WalletHealthScoreTabletPage.recommendationKey('r1')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(WalletHealthScoreTabletPage.recommendationKey('r1')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(WalletHealthScoreTabletPage.sheetCloseKey),
      findsOneWidget,
    );
    await tester.tap(find.byKey(WalletHealthScoreTabletPage.sheetCloseKey));
    await tester.pumpAndSettle();
    expect(find.byKey(WalletHealthScoreTabletPage.sheetCloseKey), findsNothing);
  });

  testWidgets('SC-150 tablet route keeps revoke preview boundary', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.walletTokenApproval);

    expect(find.byType(WalletTokenApprovalTabletPage), findsOneWidget);
    expect(find.text('Phê duyệt token'), findsOneWidget);
    expect(
      find.byKey(WalletTokenApprovalTabletPage.approvalKey('a3')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(WalletTokenApprovalTabletPage.revokeKey('a3')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(WalletTokenApprovalTabletPage.revokeSheetCancelKey),
      findsOneWidget,
    );
    expect(find.textContaining('Xem lại bên chi tiêu'), findsOneWidget);
    await tester.tap(
      find.byKey(WalletTokenApprovalTabletPage.revokeSheetCancelKey),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(WalletTokenApprovalTabletPage.revokeSheetCancelKey),
      findsNothing,
    );
  });

  testWidgets('SC-153 tablet route renders KYC limit controls', (tester) async {
    await pumpTabletRoute(tester, AppRoutePaths.walletLimits);

    expect(find.byType(WithdrawLimitsTabletPage), findsOneWidget);
    expect(find.text('Hạn mức rút tiền'), findsOneWidget);
    expect(find.byKey(WithdrawLimitsTabletPage.currentTierKey), findsOneWidget);
    expect(find.byKey(WithdrawLimitsTabletPage.dailyUsageKey), findsOneWidget);
    expect(find.byKey(WithdrawLimitsTabletPage.tierKey(3)), findsOneWidget);
  });

  testWidgets('SC-154 tablet route keeps dust conversion preview boundary', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.walletDustConverter);

    expect(find.byType(DustConverterTabletPage), findsOneWidget);
    expect(find.text('Chuyển đổi số dư nhỏ'), findsOneWidget);
    expect(find.byKey(DustConverterTabletPage.assetKey('dot')), findsOneWidget);

    await tester.tap(find.byKey(DustConverterTabletPage.selectAllKey));
    await tester.pumpAndSettle();
    expect(find.byKey(DustConverterTabletPage.ctaKey), findsOneWidget);
    await tester.tap(find.byKey(DustConverterTabletPage.ctaKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(DustConverterTabletPage.confirmCancelKey),
      findsOneWidget,
    );
    await tester.tap(find.byKey(DustConverterTabletPage.confirmCancelKey));
    await tester.pumpAndSettle();
    expect(find.byKey(DustConverterTabletPage.confirmCancelKey), findsNothing);
  });

  testWidgets('SC-155 tablet route renders network monitoring controls', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.walletNetworkStatus);

    expect(find.byType(NetworkStatusTabletPage), findsOneWidget);
    expect(find.text('Trạng thái mạng'), findsOneWidget);
    expect(
      find.byKey(NetworkStatusTabletPage.networkKey('polygon')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(NetworkStatusTabletPage.refreshKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(NetworkStatusTabletPage.refreshFeedbackKey),
      findsOneWidget,
    );

    await tester.tap(find.byKey(NetworkStatusTabletPage.filterKey('issues')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(NetworkStatusTabletPage.filterKey('issues')),
      findsOneWidget,
    );
  });
}
