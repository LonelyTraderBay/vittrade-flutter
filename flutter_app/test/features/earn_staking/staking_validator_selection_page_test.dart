import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_validator_selection_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpValidatorSelection(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnValidatorSelection,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-362 mock repository exposes validator selection BE draft', () async {
    final snapshot = await const MockStakingValidatorSelectionRepository()
        .getSelection();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-validator-selection');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.actionDraft, contains('validator-preference'));
    expect(snapshot.title, 'Chọn Validator');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.validators, hasLength(7));
    expect(snapshot.validators.first.name, 'Coinbase Cloud');
    expect(snapshot.validators[2].apy, 6.15);
    expect(snapshot.validators.last.slashingHistory, 1);
    expect(snapshot.contractNotes, contains('riskData'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-362 renders validator selection baseline', (tester) async {
    await pumpValidatorSelection(tester);

    expect(find.byType(StakingValidatorSelectionPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chọn Validator'), findsOneWidget);
    expect(find.byKey(StakingValidatorSelectionPage.infoKey), findsOneWidget);
    expect(find.text('Tính năng Nâng cao'), findsOneWidget);
    expect(
      find.byKey(StakingValidatorSelectionPage.summaryKey),
      findsOneWidget,
    );
    expect(find.text('6.15%'), findsAtLeastNWidgets(1));
    expect(find.text('99.96%'), findsAtLeastNWidgets(1));
    expect(find.text('8.1%'), findsOneWidget);
    expect(find.byKey(StakingValidatorSelectionPage.searchKey), findsOneWidget);
    expect(
      find.byKey(StakingValidatorSelectionPage.resultCountKey),
      findsOneWidget,
    );
    expect(find.text('7 validators'), findsOneWidget);
    expect(
      find.byKey(StakingValidatorSelectionPage.validatorKey('v3')),
      findsOneWidget,
    );
    expect(find.text('Figment'), findsAtLeastNWidgets(1));
  });

  testWidgets('SC-362 search and tier filter narrow validators', (
    tester,
  ) async {
    await pumpValidatorSelection(tester);

    await tester.enterText(
      find.byKey(StakingValidatorSelectionPage.searchKey),
      'kraken',
    );
    await tester.pumpAndSettle();
    expect(find.text('1 validators (đã lọc từ 7)'), findsOneWidget);
    expect(find.text('Kraken Staking'), findsOneWidget);
    expect(
      find.byKey(StakingValidatorSelectionPage.validatorKey('v3')),
      findsNothing,
    );

    await tester.enterText(
      find.byKey(StakingValidatorSelectionPage.searchKey),
      '',
    );
    await tester.tap(find.byKey(StakingValidatorSelectionPage.filterButtonKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(StakingValidatorSelectionPage.filterPanelKey),
      findsOneWidget,
    );

    final standardChip = find.descendant(
      of: find.byKey(StakingValidatorSelectionPage.filterPanelKey),
      matching: find.text('Standard'),
    );
    await tester.tap(standardChip);
    await tester.pumpAndSettle();

    expect(find.text('2 validators (đã lọc từ 7)'), findsOneWidget);
    expect(find.text('Everstake'), findsOneWidget);
    expect(find.text('Staked.us'), findsOneWidget);
  });

  testWidgets('SC-362 validator detail state opens from card', (tester) async {
    await pumpValidatorSelection(tester);

    await tester.tap(
      find.byKey(StakingValidatorSelectionPage.validatorKey('v3')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(StakingValidatorSelectionPage.detailKey), findsOneWidget);
    expect(find.text('Chi tiết Validator'), findsOneWidget);
    expect(
      find.text('Highest APY with excellent track record'),
      findsOneWidget,
    );
    expect(find.text('Chọn Validator này'), findsOneWidget);

    await tester.ensureVisible(find.text('Chọn Validator này'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chọn Validator này'));
    await tester.pumpAndSettle();

    expect(find.text('Đã chọn Figment làm validator'), findsOneWidget);
    expect(find.byKey(StakingValidatorSelectionPage.detailKey), findsNothing);
  });

  testWidgets('SC-362 header back returns to staking hub', (tester) async {
    await pumpValidatorSelection(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
