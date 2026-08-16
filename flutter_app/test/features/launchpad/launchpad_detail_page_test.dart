import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_detail_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadSample,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpValidProjectDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: LaunchpadDetailPage(projectId: 'proj1')),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-318 mock repository exposes launchpad detail BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getDetail('sample');

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-sample');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Launchpad');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.projectId, 'sample');
    expect(snapshot.project, isNull);
    expect(snapshot.contractRoute, '/launchpad/contract/sample');
    expect(snapshot.idoBridgeRoute, '/launchpad/idobridge/sample');
    expect(snapshot.receiptRoute, AppRoutePaths.launchpadReceiptSub001);
    expect(snapshot.stakingRoute, AppRoutePaths.launchpadStaking);
    expect(snapshot.contractNotes, contains('Flutter error state'));
    expect(
      snapshot.supportedStates,
      containsAll([
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-318 renders Flutter sample error state', (tester) async {
    await pumpDetail(tester);

    expect(find.byType(LaunchpadDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Launchpad'), findsOneWidget);
    expect(find.byKey(LaunchpadDetailPage.contentKey), findsOneWidget);
    expect(find.byKey(LaunchpadDetailPage.errorKey), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    expect(find.text('Không tải được dữ liệu'), findsOneWidget);
    expect(
      find.text('Vui lòng kiểm tra kết nối mạng và thử lại.'),
      findsOneWidget,
    );
  });

  testWidgets('SC-318 renders project detail summary surfaces', (tester) async {
    await pumpValidProjectDetail(tester);

    expect(find.byKey(LaunchpadDetailPage.summaryKey), findsOneWidget);
    expect(find.text('NexaAI Protocol'), findsOneWidget);
    expect(find.text('IEO'), findsOneWidget);
    expect(find.text('Đang diễn ra'), findsOneWidget);
    expect(find.text('Giá token'), findsOneWidget);
    expect(find.text(r'$0.05'), findsOneWidget);
    expect(find.text('Đã huy động'), findsOneWidget);
    expect(find.text(r'$2,500,000'), findsOneWidget);
    expect(find.text('Cần rà soát staking Launchpad'), findsOneWidget);
    expect(find.text('Bước tiếp theo'), findsOneWidget);
  });

  testWidgets('SC-318 header back returns to launchpad', (tester) async {
    await pumpDetail(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}
