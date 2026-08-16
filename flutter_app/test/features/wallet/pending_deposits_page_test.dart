import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/support/presentation/phone/pages/support_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/deposit_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/pending_deposits_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  const creditedDeposit = WalletPendingDeposit(
    id: 'credited-only',
    asset: 'USDT',
    amountLabel: '10.0000',
    network: 'TRC20',
    txHash: 'test-hash',
    confirmations: 1,
    requiredConfirmations: 1,
    status: 'credited',
    createdAt: '24/07/2026 01:00',
    estimatedArrival: 'Đã xong',
    fromAddress: 'test-address',
  );

  Future<void> pumpPendingDeposits(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
    WalletPendingDepositsSnapshot? snapshot,
    Object? error,
    Future<WalletPendingDepositsSnapshot> Function()? pendingDepositsLoader,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (pendingDepositsLoader != null)
            walletPendingDepositsProvider.overrideWith(
              (ref) => pendingDepositsLoader(),
            )
          else if (snapshot != null || error != null)
            walletPendingDepositsProvider.overrideWith((ref) {
              if (error != null) throw error;
              return snapshot!;
            }),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletPendingDeposits,
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

  test('SC-152 mock repository exposes pending deposits BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getPendingDeposits();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-pending-deposits');
    expect(snapshot.actionDraft, 'POST /wallet/deposit-intent');
    expect(snapshot.deposits.length, 4);
    expect(snapshot.pendingCount, 2);
    expect(snapshot.deposits.first.asset, 'USDT');
    expect(snapshot.deposits.first.status, 'credited');
    expect(snapshot.deposits[1].progress, .5);
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

  testWidgets('SC-152 renders pending deposits baseline shell', (tester) async {
    await pumpPendingDeposits(tester);

    expect(find.byType(PendingDepositsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('N\u1EA1p ti\u1EC1n \u0111ang ch\u1EDD'), findsWidgets);
    expect(
      find.text('Theo d\u00F5i x\u00E1c nh\u1EADn \u00B7 Wallet'),
      findsOneWidget,
    );
    expect(
      find.text('2 giao d\u1ECBch \u0111ang ch\u1EDD x\u00E1c nh\u1EADn'),
      findsOneWidget,
    );
    expect(find.text('T\u1EA5t c\u1EA3'), findsOneWidget);
    expect(find.text('\u0110ang ch\u1EDD (2)'), findsOneWidget);
    expect(find.text('Ho\u00E0n t\u1EA5t'), findsOneWidget);
    expect(find.text('N\u1EA1p USDT'), findsWidgets);
    expect(find.text('\u0110\u00E3 ghi nh\u1EADn'), findsWidgets);
    expect(find.text('N\u1EA1p BTC'), findsOneWidget);
    expect(find.text('\u0110ang x\u00E1c nh\u1EADn'), findsWidgets);
    expect(find.text('1/2 y\u00EAu c\u1EA7u'), findsOneWidget);
    expect(find.text('X\u00E1c nh\u1EADn y\u00EAu c\u1EA7u'), findsNothing);
    expect(find.text('+5,000.00'), findsOneWidget);
    expect(find.text('+0.050000'), findsOneWidget);
    expect(find.text('X\u00E1c nh\u1EADn blockchain'), findsWidgets);
    expect(find.text('Chi tiết giao dịch'), findsWidgets);
    expect(
      semanticsLabel('Làm mới trạng thái nạp tiền đang chờ'),
      findsOneWidget,
    );
    expect(
      semanticsLabel(RegExp(r'Sao chép mã giao dịch của .+')),
      findsNothing,
    );
  });

  testWidgets('SC-152 ẩn chi tiết mặc định và chỉ hiện khi mở rộng', (
    tester,
  ) async {
    await pumpPendingDeposits(tester);

    expect(find.text('Mạng'), findsNothing);
    expect(find.text('Thời điểm gửi'), findsNothing);

    final expand = find.text('Chi tiết giao dịch').first;
    await tester.ensureVisible(expand);
    await tester.tap(expand);
    await tester.pumpAndSettle();

    expect(find.text('Mạng'), findsOneWidget);
    expect(find.text('Xác nhận yêu cầu'), findsOneWidget);
    expect(find.text('Thời điểm gửi'), findsNothing);
    expect(find.text('Ẩn chi tiết'), findsOneWidget);
  });

  testWidgets('SC-152 first viewport reaches first pending deposit', (
    tester,
  ) async {
    await pumpPendingDeposits(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'PendingDepositsPage',
      semanticLabel: 'Nạp tiền đang chờ xác nhận',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(PendingDepositsPage.depositKey('pd001')),
      routeName: 'PendingDepositsPage',
      actionLabel: 'the first pending deposit card',
    );
  });

  testWidgets('SC-152 filters and copy action are local', (tester) async {
    await pumpPendingDeposits(tester);
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (methodCall) async => null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await tester.tap(find.byKey(PendingDepositsPage.filterKey('pending')));
    await tester.pumpAndSettle();
    expect(find.byKey(PendingDepositsPage.depositKey('pd002')), findsOneWidget);
    expect(find.byKey(PendingDepositsPage.depositKey('pd003')), findsOneWidget);
    expect(find.byKey(PendingDepositsPage.depositKey('pd001')), findsNothing);

    await tester.tap(find.byKey(PendingDepositsPage.filterKey('done')));
    await tester.pumpAndSettle();
    expect(find.byKey(PendingDepositsPage.depositKey('pd001')), findsOneWidget);
    expect(find.byKey(PendingDepositsPage.depositKey('pd004')), findsOneWidget);
    final expand = find.text('Chi tiết giao dịch').first;
    await tester.ensureVisible(expand);
    await tester.tap(expand);
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(PendingDepositsPage.copyKey('pd001')),
    );
    await tester.tap(find.byKey(PendingDepositsPage.copyKey('pd001')));
    await tester.pumpAndSettle();
    expect(find.text('\u0110\u00E3 ch\u00E9p'), findsOneWidget);
    expect(semanticsLabel('Đã sao chép mã giao dịch của USDT'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Sao chép'), findsOneWidget);
    expect(semanticsLabel('Sao chép mã giao dịch của USDT'), findsOneWidget);
  });

  testWidgets('SC-152 banner không claim cập nhật tự động 5 giây', (
    tester,
  ) async {
    await pumpPendingDeposits(tester);
    expect(find.textContaining('5 giây'), findsNothing);
    expect(
      find.text('Nhấn làm mới để cập nhật trạng thái xác nhận'),
      findsOneWidget,
    );
  });

  testWidgets('SC-152 refresh invalidates and shows notice sheet', (
    tester,
  ) async {
    await pumpPendingDeposits(tester);

    // Refresh must await provider reload before showing the notice sheet.
    await tester.tap(find.byKey(PendingDepositsPage.refreshKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã làm mới'), findsOneWidget);
    expect(
      find.textContaining('Trạng thái nạp tiền đang chờ đã được cập nhật'),
      findsOneWidget,
    );
  });

  testWidgets('SC-152 refresh lỗi chỉ hiện notice thất bại', (tester) async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getPendingDeposits();
    var loadCount = 0;

    await pumpPendingDeposits(
      tester,
      pendingDepositsLoader: () async {
        if (loadCount++ > 0) throw Exception('refresh failed');
        return snapshot;
      },
    );

    await tester.tap(find.byKey(PendingDepositsPage.refreshKey));
    await tester.pumpAndSettle();

    expect(find.text('Không làm mới được'), findsOneWidget);
    expect(find.text('Đã làm mới'), findsNothing);
  });

  testWidgets('SC-152 offline có banner và CTA thử lại', (tester) async {
    await pumpPendingDeposits(
      tester,
      error: Exception('SocketException: Failed host lookup'),
    );

    expect(find.text('Mất kết nối mạng'), findsOneWidget);
    expect(find.text('Đang offline'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
  });

  testWidgets('SC-152 empty global có CTA Nạp tiền', (tester) async {
    await pumpPendingDeposits(
      tester,
      snapshot: const WalletPendingDepositsSnapshot(
        deposits: [],
        endpoint: '/api/mobile/wallet/wallet-pending-deposits',
        actionDraft: 'POST /wallet/deposit-intent',
        supportedStates: [WalletScreenState.empty],
      ),
    );

    expect(find.text('Chưa có nạp đang chờ'), findsOneWidget);
    await tester.tap(find.text('Nạp tiền'));
    await tester.pumpAndSettle();
    expect(find.byType(DepositPage), findsOneWidget);
  });

  testWidgets('SC-152 empty filter có CTA Xem tất cả', (tester) async {
    await pumpPendingDeposits(
      tester,
      snapshot: const WalletPendingDepositsSnapshot(
        deposits: [creditedDeposit],
        endpoint: '/api/mobile/wallet/wallet-pending-deposits',
        actionDraft: 'POST /wallet/deposit-intent',
        supportedStates: [WalletScreenState.empty],
      ),
    );

    await tester.tap(find.byKey(PendingDepositsPage.filterKey('pending')));
    await tester.pumpAndSettle();
    expect(find.text('Xem tất cả'), findsOneWidget);

    await tester.tap(find.text('Xem tất cả'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(PendingDepositsPage.depositKey(creditedDeposit.id)),
      findsOneWidget,
    );
  });

  testWidgets('SC-152 failed deposit mở hỗ trợ theo giao dịch', (tester) async {
    await pumpPendingDeposits(tester);

    await tester.tap(find.byKey(PendingDepositsPage.filterKey('done')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Liên hệ hỗ trợ'));
    await tester.tap(find.text('Liên hệ hỗ trợ'));
    await tester.pumpAndSettle();

    expect(find.byType(SupportPage), findsOneWidget);
    expect(find.byKey(SupportPage.contextKey), findsOneWidget);
    expect(find.text('Nạp USDT thất bại'), findsOneWidget);
    expect(find.text('pd004'), findsOneWidget);
  });
}
