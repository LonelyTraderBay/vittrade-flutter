import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_history_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_receipt_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpHistory(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsHistory,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-334 mock repository exposes savings history BE draft', () async {
    final snapshot = await const MockSavingsHistoryRepository().getHistory();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-history');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Lịch sử Tiết kiệm');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.receiptRoute, AppRoutePaths.earnSavingsReceipt);
    expect(snapshot.transactions, hasLength(12));
    expect(snapshot.contractNotes, contains('earnProducts'));
    expect(snapshot.supportedStates, contains(EarnScreenState.loading));
    expect(snapshot.supportedStates, contains(EarnScreenState.empty));
    expect(snapshot.supportedStates, contains(EarnScreenState.error));
    expect(snapshot.supportedStates, contains(EarnScreenState.offline));
  });

  testWidgets('SC-334 renders savings history baseline', (tester) async {
    await pumpHistory(tester);

    expect(find.byType(SavingsHistoryPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Lịch sử Tiết kiệm'), findsOneWidget);
    expect(find.text('12 giao dịch'), findsOneWidget);
    expect(find.text('08/03/2026'), findsOneWidget);
    expect(find.text('Rút sớm'), findsAtLeastNWidgets(1));
    expect(find.text('-10.0000 SOL'), findsOneWidget);
  });

  testWidgets('SC-334 first viewport reaches first transaction', (
    tester,
  ) async {
    await pumpHistory(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-334 SavingsHistoryPage',
      semanticLabel: 'Lịch sử Tiết kiệm',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(SavingsHistoryPage.firstTransactionKey),
      routeName: 'SC-334 SavingsHistoryPage',
      actionLabel: 'the first savings transaction',
    );
  });

  testWidgets('SC-334 type filter narrows to interest transactions', (
    tester,
  ) async {
    await pumpHistory(tester);

    await tester.tap(find.text('Lãi'));
    await tester.pumpAndSettle();

    expect(find.text('5 giao dịch'), findsOneWidget);
    expect(find.text('Nhận lãi'), findsAtLeastNWidgets(1));
    expect(find.text('-10.0000 SOL'), findsNothing);
  });

  testWidgets('SC-334 transaction edge opens savings receipt', (tester) async {
    await pumpHistory(tester);

    await tester.tap(find.byKey(SavingsHistoryPage.firstTransactionKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsReceiptPage), findsOneWidget);
  });
}
