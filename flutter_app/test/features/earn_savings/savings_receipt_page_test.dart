import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_receipt_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpReceipt(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsReceipt,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-332 mock repository exposes savings receipt BE draft', () async {
    final snapshot = await const MockSavingsReceiptRepository().getReceipt();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-receipt');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Biên nhận');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.earnRoute, AppRoutePaths.earn);
    expect(snapshot.receipt, isNull);
    expect(snapshot.emptyMessage, 'Không có dữ liệu biên nhận');
    expect(snapshot.contractNotes, contains('earnProducts'));
    expect(snapshot.supportedStates, contains(EarnScreenState.loading));
    expect(snapshot.supportedStates, contains(EarnScreenState.empty));
    expect(snapshot.supportedStates, contains(EarnScreenState.error));
    expect(snapshot.supportedStates, contains(EarnScreenState.offline));
  });

  testWidgets('SC-332 renders missing receipt baseline', (tester) async {
    await pumpReceipt(tester);

    expect(find.byType(SavingsReceiptPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Biên nhận'), findsOneWidget);
    expect(find.text('Không có dữ liệu biên nhận'), findsOneWidget);
    expect(find.text('Về Tiết kiệm'), findsOneWidget);
  });

  testWidgets('SC-332 savings CTA returns to savings overview', (tester) async {
    await pumpReceipt(tester);

    await tester.tap(find.byKey(SavingsReceiptPage.savingsButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });
}
