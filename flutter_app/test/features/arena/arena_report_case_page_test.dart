import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_report_case_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpReportCase(
    WidgetTester tester, {
    String caseId = 'case001',
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaReportCase(caseId),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-202 mock repository exposes Arena report case BE draft', () async {
    const repository = MockArenaRepository(loadDelay: Duration.zero);
    final missing = await repository.getArenaReportCase('case001');
    final report = await repository.getArenaReportCase('rpt001');

    expect(missing.endpoint, '/api/mobile/arena/arena-report-case001');
    expect(
      missing.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable; POST /exports',
    );
    expect(missing.reportCase, isNull);
    expect(missing.emptyTitle, 'Không tìm thấy');
    expect(missing.emptySubtitle, 'Báo cáo không tồn tại');
    expect(report.reportCase?.id, 'rpt001');
    expect(report.reportCase?.status, ArenaReportCaseStatus.actionTaken);
    expect(report.reportCase?.relatedChallengeId, 'ch006');
    expect(report.relatedReports.map((item) => item.id), ['rpt002', 'rpt003']);
    expect(report.disclaimer, contains('không có giá trị tiền tệ'));
    expect(
      report.supportedStates,
      containsAll([
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-202 renders not-found baseline for case001', (tester) async {
    await pumpReportCase(tester);

    expect(find.byType(ArenaReportCasePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chi tiết báo cáo'), findsOneWidget);
    expect(find.text('An toàn · Open Arena'), findsOneWidget);
    expect(find.byKey(ArenaReportCasePage.emptyKey), findsOneWidget);
    expect(find.text('Không tìm thấy'), findsOneWidget);
    expect(find.text('Báo cáo không tồn tại'), findsOneWidget);
    expect(find.text('#RPT001'), findsNothing);
  });

  testWidgets('SC-202 renders valid case detail and appeal state', (
    tester,
  ) async {
    await pumpReportCase(tester, caseId: 'rpt001');

    expect(find.text('Moderation review state'), findsOneWidget);
    expect(find.text('#RPT001'), findsOneWidget);
    expect(find.text('GameMaker_HN'), findsOneWidget);
    expect(find.text('Thao túng kết quả'), findsOneWidget);
    expect(find.text('Tiến trình xử lý'), findsOneWidget);
    expect(find.text('Kết luận: Vi phạm xác nhận'), findsOneWidget);
    expect(find.text('Bạn có thể khiếu nại'), findsOneWidget);

    await tester.ensureVisible(find.text('Mở khiếu nại'));
    await tester.tap(find.text('Mở khiếu nại'));
    await tester.pumpAndSettle();

    expect(find.text('Khiếu nại đã ghi nhận'), findsOneWidget);
    expect(find.text('Đã gửi yêu cầu xem xét'), findsOneWidget);
  });

  testWidgets('SC-202 first viewport reaches report review state', (
    tester,
  ) async {
    await pumpReportCase(tester, caseId: 'rpt001');

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ArenaReportCasePage',
      semanticLabel: 'Chi tiết báo cáo an toàn trong Open Arena',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ArenaReportCasePage.reviewStateKey),
      targetLabel: 'report review state',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-202 related challenge link uses challenge route', (
    tester,
  ) async {
    await pumpReportCase(tester, caseId: 'rpt001');

    await tester.ensureVisible(
      find.byKey(ArenaReportCasePage.relatedChallengeKey),
    );
    await tester.tap(find.byKey(ArenaReportCasePage.relatedChallengeKey));
    await tester.pumpAndSettle();

    expect(find.byType(ArenaChallengeDetailPage), findsOneWidget);
    expect(find.text('Chi tiết challenge'), findsOneWidget);
  });

  testWidgets('SC-202 report links navigate to local preview/detail routes', (
    tester,
  ) async {
    await pumpReportCase(tester, caseId: 'rpt001');

    await tester.ensureVisible(find.byKey(ArenaReportCasePage.myReportsKey));
    await tester.tap(find.byKey(ArenaReportCasePage.myReportsKey));
    await tester.pumpAndSettle();
    expect(find.text('Báo cáo của tôi'), findsOneWidget);

    await pumpReportCase(tester, caseId: 'rpt001');
    await tester.ensureVisible(
      find.byKey(ArenaReportCasePage.relatedReportKey('rpt002')),
    );
    await tester.tap(
      find.byKey(ArenaReportCasePage.relatedReportKey('rpt002')),
    );
    await tester.pumpAndSettle();
    expect(find.text('#RPT002'), findsOneWidget);
    expect(find.text('SpamBot_X'), findsOneWidget);
  });
}
