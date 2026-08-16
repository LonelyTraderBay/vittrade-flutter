import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpLaunchpad(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpad,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-295 mock repository exposes launchpad BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getHome();

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Launchpad');
    expect(snapshot.subtitle, 'Dự án mới · Token Launch');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.performanceRoute, AppRoutePaths.launchpadPerformance);
    expect(snapshot.portfolioRoute, AppRoutePaths.launchpadPortfolio);
    expect(snapshot.stakingRoute, AppRoutePaths.launchpadStaking);
    expect(snapshot.projects, hasLength(5));
    expect(snapshot.projects.first.name, 'NexaAI Protocol');
    expect(snapshot.projects.first.status, LaunchpadProjectStatus.active);
    expect(snapshot.projects[2].type, LaunchpadProjectType.launchpool);
    expect(snapshot.advancedTools, hasLength(8));
    expect(snapshot.riskTools, hasLength(4));
    expect(snapshot.contractNotes, contains('launchpadProjects'));
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

  testWidgets('SC-295 renders launchpad home baseline', (tester) async {
    await pumpLaunchpad(tester);

    expect(find.byType(LaunchpadPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Launchpad'), findsWidgets);
    expect(find.text('Dự án mới · Token Launch'), findsOneWidget);
    expect(find.byKey(LaunchpadPage.heroKey), findsOneWidget);
    expect(find.text('Khám phá dự án token mới'), findsOneWidget);
    expect(find.textContaining('dự án đang diễn ra'), findsOneWidget);
    expect(find.byKey(LaunchpadPage.tabsKey), findsOneWidget);
    expect(find.text('Tất cả'), findsOneWidget);
    expect(find.text('Đang mở'), findsOneWidget);
    expect(find.byKey(LaunchpadPage.projectKey('proj1')), findsOneWidget);
    expect(find.text('NexaAI Protocol'), findsOneWidget);
    expect(find.text('MetaVerse Land'), findsOneWidget);
  });

  testWidgets('SC-295 first viewport reaches first launchpad project', (
    tester,
  ) async {
    await pumpLaunchpad(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-295 LaunchpadPage',
      semanticLabel: 'Trung tâm dự án Launchpad',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadPage.projectKey('proj1')),
      routeName: 'SC-295 LaunchpadPage',
      actionLabel: 'the first launchpad project card',
    );
  });

  testWidgets('SC-295 tab filter shows upcoming project', (tester) async {
    await pumpLaunchpad(tester);

    await tester.tap(find.byKey(LaunchpadPage.tabKey('upcoming')));
    await tester.pumpAndSettle();

    expect(find.text('GreenChain Eco'), findsOneWidget);
    expect(find.text('NexaAI Protocol'), findsNothing);
    expect(find.text('Xem chi tiết'), findsOneWidget);
  });

  testWidgets('SC-295 header filter action shows active projects', (
    tester,
  ) async {
    await pumpLaunchpad(tester);

    await tester.tap(find.byKey(LaunchpadPage.filterActionKey));
    await tester.pumpAndSettle();

    expect(find.text('NexaAI Protocol'), findsOneWidget);
    expect(find.text('MetaVerse Land'), findsOneWidget);
    expect(find.text('GreenChain Eco'), findsNothing);
  });

  testWidgets('SC-295 auto-hides header on launchpad scroll', (tester) async {
    await pumpLaunchpad(tester);

    double headerHeight() {
      return tester
          .getSize(find.byKey(VitAutoHideHeaderScaffold.headerHostKey))
          .height;
    }

    expect(headerHeight(), greaterThan(0));

    await tester.drag(
      find.byKey(LaunchpadPage.contentKey),
      const Offset(0, -320),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 220));
    expect(headerHeight(), 0);

    await tester.drag(
      find.byKey(LaunchpadPage.contentKey),
      const Offset(0, 160),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 220));
    expect(headerHeight(), greaterThan(0));
  });

  testWidgets('SC-295 visible launchpad shortcuts navigate safely', (
    tester,
  ) async {
    await pumpLaunchpad(tester);

    await tester.tap(find.byKey(LaunchpadPage.performanceActionKey));
    await tester.pumpAndSettle();
    expect(find.text('Hiệu suất Launchpad'), findsOneWidget);

    await pumpLaunchpad(tester);
    await tester.tap(find.byKey(LaunchpadPage.portfolioActionKey));
    await tester.pumpAndSettle();
    expect(find.text('Danh mục Launchpad'), findsOneWidget);

    await pumpLaunchpad(tester);
    await tester.ensureVisible(find.byKey(LaunchpadPage.stakingKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(LaunchpadPage.stakingKey));
    await tester.pumpAndSettle();
    expect(find.text('Launchpool Staking'), findsOneWidget);
  });

  testWidgets('SC-295 safety section remains visible', (tester) async {
    await pumpLaunchpad(tester);

    await tester.ensureVisible(find.byKey(LaunchpadPage.safetyKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadPage.safetyKey), findsOneWidget);
    expect(find.text('Cảnh báo an toàn'), findsOneWidget);
  });

  testWidgets('SC-295 header back returns to home', (tester) async {
    await pumpLaunchpad(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('VitTrade'), findsOneWidget);
  });
}
