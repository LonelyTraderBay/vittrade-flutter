import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_risk_analytics_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRiskAnalytics(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadRiskAnalytics,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-317 mock repository exposes launchpad risk analytics BE draft',
    () async {
      final snapshot = await const MockLaunchpadRepository(
        loadDelay: Duration.zero,
      ).getRiskAnalytics();

      expect(
        snapshot.endpoint,
        '/api/mobile/launchpad/launchpad-risk-analytics',
      );
      expect(
        snapshot.actionDraft,
        'POST /launchpad/subscribe|claim|bridge where applicable',
      );
      expect(snapshot.title, 'Risk Analytics');
      expect(snapshot.backRoute, AppRoutePaths.launchpad);
      expect(snapshot.tabs, ['Tong quan', 'Due Diligence', 'Bao cao']);
      expect(snapshot.project.name, 'VitToken');
      expect(snapshot.project.score.overall, 78);
      expect(snapshot.project.level, LaunchpadRiskLevel.medium);
      expect(snapshot.metrics, hasLength(6));
      expect(snapshot.comparisonProjects, hasLength(4));
      expect(snapshot.auditReports, hasLength(2));
      expect(snapshot.resources, hasLength(4));
      expect(snapshot.contractNotes, contains('realtime refresh'));
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

  testWidgets('SC-317 renders risk overview baseline', (tester) async {
    await pumpRiskAnalytics(tester);

    expect(find.byType(LaunchpadRiskAnalyticsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Risk Analytics'), findsOneWidget);
    expect(find.byKey(LaunchpadRiskAnalyticsPage.tabsKey), findsOneWidget);
    expect(find.byKey(LaunchpadRiskAnalyticsPage.scoreKey), findsOneWidget);
    expect(find.byKey(LaunchpadRiskAnalyticsPage.breakdownKey), findsOneWidget);
    expect(
      find.byKey(LaunchpadRiskAnalyticsPage.quickChecksKey),
      findsOneWidget,
    );
    expect(find.text('78/100'), findsOneWidget);
    expect(find.text('MEDIUM RISK'), findsOneWidget);
    expect(find.text('Audit Verified'), findsOneWidget);
    expect(find.text('Team Doxxed'), findsOneWidget);
    expect(find.text('Contract Verified'), findsOneWidget);
    expect(find.text('Liquidity Locked'), findsOneWidget);
    expect(
      find.text('High token concentration in top 10 wallets (45%)'),
      findsOneWidget,
    );
    expect(find.text('Multiple security audits passed'), findsOneWidget);
  });

  testWidgets('SC-317 first viewport reaches risk score', (tester) async {
    await pumpRiskAnalytics(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-317 LaunchpadRiskAnalyticsPage',
      semanticLabel: 'Phân tích rủi ro dự án Launchpad',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(LaunchpadRiskAnalyticsPage.scoreKey),
      targetLabel: 'the risk score card',
    );
  });

  testWidgets('SC-317 switches to due diligence tab', (tester) async {
    await pumpRiskAnalytics(tester);

    await tester.tap(find.text('Due Diligence'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(LaunchpadRiskAnalyticsPage.dueDiligenceKey),
      findsOneWidget,
    );
    expect(find.text('Team & Governance'), findsOneWidget);
    expect(find.text('Security Audit'), findsOneWidget);
    expect(find.text('Tokenomics Analysis'), findsOneWidget);
    expect(find.text('CertiK'), findsOneWidget);
    expect(find.text('Quantstamp'), findsOneWidget);
    expect(find.text('Top 10 Holders'), findsOneWidget);
  });

  testWidgets('SC-317 switches to report tab', (tester) async {
    await pumpRiskAnalytics(tester);

    await tester.tap(find.text('Bao cao'));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadRiskAnalyticsPage.reportKey), findsOneWidget);
    expect(
      find.byKey(LaunchpadRiskAnalyticsPage.projectKey('safe')),
      findsOneWidget,
    );
    expect(
      find.byKey(LaunchpadRiskAnalyticsPage.projectKey('rug')),
      findsOneWidget,
    );
    expect(
      find.byKey(LaunchpadRiskAnalyticsPage.distributionKey),
      findsOneWidget,
    );
    expect(find.text('Risk Distribution (Market)'), findsOneWidget);
    expect(find.text('Official Website'), findsOneWidget);
    expect(find.text('CertiK Audit Report'), findsOneWidget);
  });

  testWidgets('SC-317 header back returns to launchpad', (tester) async {
    await pumpRiskAnalytics(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}
