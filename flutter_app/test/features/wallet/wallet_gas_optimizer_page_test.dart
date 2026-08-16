import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/wallet_gas_optimizer_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpGasOptimizer(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);
    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletGasOptimizer,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-149 mock repository exposes gas optimizer BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getGasOptimizer();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-gas-optimizer');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.levels.map((level) => level.speed), [
      'slow',
      'standard',
      'fast',
    ]);
    expect(snapshot.recommendedLevel.label, 'Standard');
    expect(snapshot.recommendedLevel.gwei, 25);
    expect(snapshot.vsAveragePct, closeTo(-10.71, .01));
    expect(snapshot.comparisons.length, 4);
    expect(snapshot.history.length, 7);
    expect(snapshot.tips.first.title, 'Transact During Low Activity');
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

  testWidgets('SC-149 renders gas optimizer current baseline shell', (
    tester,
  ) async {
    await pumpGasOptimizer(tester);

    expect(find.byType(WalletGasOptimizerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Tối ưu phí gas'), findsOneWidget);
    expect(find.text('Hiện tại'), findsOneWidget);
    expect(find.text('Xu hướng'), findsOneWidget);
    expect(find.text('Mẹo tiết kiệm'), findsOneWidget);
    expect(find.text('Gas is below 24h average'), findsOneWidget);
    expect(find.textContaining('11% below'), findsOneWidget);
    expect(find.text('Chọn tốc độ giao dịch'), findsOneWidget);
    expect(find.text('Slow'), findsOneWidget);
    expect(find.text('15 Gwei'), findsOneWidget);
    expect(find.text('Standard'), findsWidgets);
    expect(find.text('RECOMMENDED'), findsOneWidget);
    expect(find.text('25 Gwei'), findsOneWidget);
    expect(find.text('Fast'), findsOneWidget);
    expect(find.text('35 Gwei'), findsOneWidget);
    expect(find.text('Transaction Type Comparison'), findsOneWidget);
    expect(find.text('Simple Transfer'), findsOneWidget);
    expect(find.text('~\$3.50'), findsWidgets);
    expect(find.text('Refresh Prices'), findsOneWidget);
  });

  testWidgets('SC-149 first viewport reaches gas comparison fee row', (
    tester,
  ) async {
    await pumpGasOptimizer(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-149 WalletGasOptimizerPage',
      semanticLabel: 'Tối ưu phí gas giao dịch trên mạng',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(WalletGasOptimizerPage.comparisonKey('Simple Transfer')),
      targetLabel: 'the first gas comparison fee row',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-149 speed selection and secondary tabs are local', (
    tester,
  ) async {
    await pumpGasOptimizer(tester);

    await tester.tap(find.byKey(WalletGasOptimizerPage.speedKey('slow')));
    await tester.pumpAndSettle();
    expect(find.text('Slow'), findsOneWidget);

    await tester.tap(find.byKey(WalletGasOptimizerPage.refreshKey));
    await tester.pumpAndSettle();
    expect(find.byKey(WalletGasOptimizerPage.feedbackKey), findsOneWidget);
    expect(
      find.text('Đã làm mới ước tính gas. Xác nhận phí trước khi ký.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(WalletGasOptimizerPage.tabKey('Xu hướng')));
    await tester.pumpAndSettle();
    expect(find.text('24h Gas Price Trends'), findsOneWidget);
    expect(find.text('Network Activity'), findsOneWidget);
    expect(find.text('Lower Activity Window'), findsOneWidget);

    await tester.tap(
      find.byKey(WalletGasOptimizerPage.tabKey('Mẹo tiết kiệm')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Gas Optimization Tips'), findsOneWidget);
    expect(find.text('Transact During Low Activity'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
  });
}
