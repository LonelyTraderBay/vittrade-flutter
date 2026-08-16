import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_redeem_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpRedeem(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsRedeemPos001,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-331 mock repository exposes redeem BE draft', () async {
    final snapshot = await const MockSavingsRedeemRepository().getRedeem(
      positionId: 'pos001',
    );

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-redeem-pos001');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.positionId, 'pos001');
    expect(snapshot.position, isNull);
    expect(snapshot.title, 'Rút Tiết kiệm');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.receiptRoute, AppRoutePaths.earnSavingsReceipt);
    expect(snapshot.notFoundMessage, 'Không tìm thấy vị thế');
    expect(snapshot.contractNotes, contains('earnProducts'));
    expect(snapshot.supportedStates, contains(EarnScreenState.submitting));
    expect(snapshot.supportedStates, contains(EarnScreenState.success));
  });

  testWidgets('SC-331 renders savings redeem not-found baseline', (
    tester,
  ) async {
    await pumpRedeem(tester);

    expect(find.byType(SavingsRedeemPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Rút Tiết kiệm'), findsOneWidget);
    expect(find.text('Không tìm thấy vị thế'), findsOneWidget);
    expect(find.text('Quay lại'), findsOneWidget);
  });

  testWidgets('SC-331 back CTA returns to savings overview', (tester) async {
    await pumpRedeem(tester);

    await tester.tap(find.byKey(SavingsRedeemPage.backButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });
}
