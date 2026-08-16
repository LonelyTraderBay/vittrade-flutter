import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_report_case_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/my_arena_reports_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpReports(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaMyReports,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-204 mock repository exposes my Arena reports BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getMyArenaReports();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-my-reports');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable; POST /exports',
    );
    expect(snapshot.summary.total, 4);
    expect(snapshot.summary.inReview, 1);
    expect(snapshot.summary.resolved, 2);
    expect(snapshot.filters.map((filter) => filter.id), [
      'all',
      'submitted',
      'under_review',
      'action_taken',
      'closed',
      'appeal_open',
    ]);
    expect(snapshot.reports.map((report) => report.id), [
      'rpt001',
      'rpt002',
      'rpt003',
      'rpt004',
    ]);
    expect(snapshot.disclaimer, contains('Không sử dụng ví'));
    expect(
      snapshot.supportedStates,
      containsAll([
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-204 renders my reports baseline', (tester) async {
    await pumpReports(tester);

    expect(find.byType(MyArenaReportsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Báo cáo của tôi'), findsOneWidget);
    expect(find.text('Báo cáo · Open Arena'), findsOneWidget);
    expect(find.text('Tổng cộng'), findsOneWidget);
    expect(find.text('Đang xử lý'), findsOneWidget);
    expect(find.text('Đã giải quyết'), findsOneWidget);
    expect(find.text('Về quy trình xử lý'), findsOneWidget);
    expect(find.text('GameMaker_HN'), findsOneWidget);
    expect(find.text('SpamBot_X'), findsOneWidget);
    expect(find.text('ToxicTrader'), findsOneWidget);
    expect(find.text('ArenaKing'), findsOneWidget);
    expect(find.text('4 báo cáo'), findsOneWidget);
  });

  testWidgets('SC-204 first viewport exposes report filters and preview', (
    tester,
  ) async {
    await pumpReports(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-204 MyArenaReportsPage',
      semanticLabel: 'Báo cáo của tôi trong Open Arena',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(MyArenaReportsPage.filterKey('submitted')),
      routeName: 'SC-204 MyArenaReportsPage',
      actionLabel: 'the submitted reports filter',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(MyArenaReportsPage.reportKey('rpt001')),
      routeName: 'SC-204 MyArenaReportsPage',
      actionLabel: 'the first report row',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-204 filters reports by status', (tester) async {
    await pumpReports(tester);

    await tester.tap(find.byKey(MyArenaReportsPage.filterKey('under_review')));
    await tester.pumpAndSettle();
    expect(find.text('SpamBot_X'), findsOneWidget);
    expect(find.text('GameMaker_HN'), findsNothing);
    expect(find.text('1 báo cáo (Đang xem xét)'), findsOneWidget);

    await tester.tap(find.byKey(MyArenaReportsPage.filterKey('submitted')));
    await tester.pumpAndSettle();
    expect(find.byKey(MyArenaReportsPage.emptyKey), findsOneWidget);
    expect(find.text('Chưa có báo cáo'), findsOneWidget);
    expect(
      find.text('Không có báo cáo nào ở trạng thái "Đã gửi".'),
      findsOneWidget,
    );
  });

  testWidgets('SC-204 report row opens report detail route', (tester) async {
    await pumpReports(tester);

    await tester.tap(find.byKey(MyArenaReportsPage.reportKey('rpt001')));
    await tester.pumpAndSettle();

    expect(find.byType(ArenaReportCasePage), findsOneWidget);
    expect(find.text('#RPT001'), findsOneWidget);
    expect(find.text('Thao túng kết quả'), findsOneWidget);
  });
}
