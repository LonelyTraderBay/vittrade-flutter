import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_performance_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPerformance(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadPerformance,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-297 mock repository exposes launchpad performance BE draft',
    () async {
      final snapshot = await const MockLaunchpadRepository(
        loadDelay: Duration.zero,
      ).getPerformance();

      expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-performance');
      expect(
        snapshot.actionDraft,
        'POST /launchpad/subscribe|claim|bridge where applicable',
      );
      expect(snapshot.title, 'Hiệu suất Launchpad');
      expect(snapshot.subtitle, 'Lịch sử · Thống kê');
      expect(snapshot.backRoute, AppRoutePaths.launchpad);
      expect(snapshot.summary.averageRoiAth, 193);
      expect(snapshot.summary.bestProjectName, 'MetaPay');
      expect(snapshot.projects, hasLength(8));
      expect(snapshot.chartPoints, hasLength(7));
      expect(snapshot.contractNotes, contains('performanceSummary'));
      expect(
        snapshot.supportedStates,
        containsAll([
          LaunchpadScreenState.loading,
          LaunchpadScreenState.empty,
          LaunchpadScreenState.error,
          LaunchpadScreenState.offline,
        ]),
      );
    },
  );

  testWidgets('SC-297 renders performance overview baseline', (tester) async {
    await pumpPerformance(tester);

    expect(find.byType(LaunchpadPerformancePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hiệu suất Launchpad'), findsWidgets);
    expect(find.text('Lịch sử · Thống kê'), findsOneWidget);
    expect(find.byKey(LaunchpadPerformancePage.tabsKey), findsOneWidget);
    expect(find.byKey(LaunchpadPerformancePage.heroKey), findsOneWidget);
    expect(find.text('ROI trung bình (ATH)'), findsOneWidget);
    expect(find.text('+193%'), findsOneWidget);
    expect(find.text('MetaPay'), findsOneWidget);
    expect(find.text('-55%'), findsOneWidget);
    expect(
      find.byKey(LaunchpadPerformancePage.distributionKey),
      findsOneWidget,
    );
  });

  testWidgets('SC-297 first viewport reaches best and worst projects', (
    tester,
  ) async {
    await pumpPerformance(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-297 LaunchpadPerformancePage',
      semanticLabel: 'Hiệu suất lịch sử các dự án Launchpad',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadPerformancePage.bestWorstKey),
      routeName: 'SC-297 LaunchpadPerformancePage',
      actionLabel: 'the best and worst project comparison',
    );
  });

  testWidgets('SC-297 tabs switch to projects and chart content', (
    tester,
  ) async {
    await pumpPerformance(tester);

    await tester.tap(find.byKey(LaunchpadPerformancePage.tabKey('projects')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(LaunchpadPerformancePage.projectKey('hp6')),
      findsOneWidget,
    );
    expect(find.text('ZetaPay Finance'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadPerformancePage.tabKey('chart')));
    await tester.pumpAndSettle();
    expect(find.text('ROI trung bình theo tháng (ATH)'), findsOneWidget);
    expect(find.text('Khối lượng huy động theo tháng'), findsOneWidget);
  });

  testWidgets('SC-297 header back returns to launchpad', (tester) async {
    await pumpPerformance(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
    expect(find.text('Launchpad'), findsOneWidget);
  });
}
