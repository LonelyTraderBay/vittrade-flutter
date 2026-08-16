import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/claim/launchpad_batch_claim_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/claim/launchpad_claim_receipt_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_staking_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpBatchClaim(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadBatchClaim,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-304 mock repository exposes batch claim BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getBatchClaim();

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-batch-claim');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Nhận hàng loạt');
    expect(snapshot.backRoute, AppRoutePaths.launchpadStaking);
    expect(
      snapshot.claimReceiptRoute,
      AppRoutePaths.launchpadClaimReceiptPos001,
    );
    expect(snapshot.positions, hasLength(2));
    expect(snapshot.summary.totalClaimableUsd, 250.52);
    expect(snapshot.summary.totalClaimable['NEXA'], 462.5);
    expect(snapshot.summary.totalClaimable['OMX'], 646);
    expect(snapshot.contractNotes, contains('claimable positions'));
    expect(
      snapshot.supportedStates,
      containsAll([
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      ]),
    );
  });

  testWidgets('SC-304 renders batch claim select baseline', (tester) async {
    await pumpBatchClaim(tester);

    expect(find.byType(LaunchpadBatchClaimPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Nhận hàng loạt'), findsOneWidget);
    expect(find.byKey(LaunchpadBatchClaimPage.heroKey), findsOneWidget);
    expect(find.text(r'$250.52'), findsOneWidget);
    expect(find.byKey(LaunchpadBatchClaimPage.gasKey), findsOneWidget);
    expect(find.text('Chọn vị trí (2/2)'), findsOneWidget);
    expect(
      find.byKey(LaunchpadBatchClaimPage.positionKey('sp1')),
      findsOneWidget,
    );
    expect(
      find.byKey(LaunchpadBatchClaimPage.positionKey('sp2')),
      findsOneWidget,
    );
    expect(find.byKey(LaunchpadBatchClaimPage.ctaKey), findsOneWidget);
  });

  testWidgets('SC-304 selection state and review success flow work', (
    tester,
  ) async {
    await pumpBatchClaim(tester);

    await tester.tap(find.byKey(LaunchpadBatchClaimPage.positionKey('sp2')));
    await tester.pumpAndSettle();
    expect(find.text('Chọn vị trí (1/2)'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadBatchClaimPage.ctaKey));
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadBatchClaimPage.reviewKey), findsOneWidget);
    expect(find.byKey(LaunchpadBatchClaimPage.reviewStateKey), findsOneWidget);
    expect(find.text('Rà soát trước khi nhận'), findsOneWidget);
    expect(find.text('Xác nhận nhận hàng loạt'), findsOneWidget);

    await tester.tap(find.text('Nhận tất cả'));
    await tester.pumpAndSettle();
    expect(find.text('Nhận hàng loạt thành công!'), findsOneWidget);
    expect(
      find.textContaining('Đã nhận phần thưởng từ 1 vị trí'),
      findsOneWidget,
    );

    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadStakingPage), findsOneWidget);
  });

  testWidgets('SC-304 safe detail edge opens claim receipt', (tester) async {
    await pumpBatchClaim(tester);

    await tester.tap(find.byKey(LaunchpadBatchClaimPage.detailKey('sp1')));
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadClaimReceiptPage), findsOneWidget);
    expect(find.text('Phần thưởng'), findsOneWidget);
  });

  testWidgets('SC-304 header back returns to launchpad staking', (
    tester,
  ) async {
    await pumpBatchClaim(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadStakingPage), findsOneWidget);
    expect(find.text('Launchpool Staking'), findsWidgets);
  });
}
