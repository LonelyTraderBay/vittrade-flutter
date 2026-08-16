import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_compliance_overview_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_risk_assessment_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpRiskAssessment(
    WidgetTester tester, {
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pComplianceRiskAssessment,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-271 mock repository exposes risk assessment BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getRiskAssessment();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-compliance-risk-assessment');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.title, 'Risk Assessment');
    expect(snapshot.subtitle, 'Rủi ro · P2P');
    expect(snapshot.overallRisk, 'low');
    expect(snapshot.score, 15);
    expect(snapshot.scoreLabel, 'Low Risk');
    expect(snapshot.factors, hasLength(5));
    expect(snapshot.parentRoute, AppRoutePaths.p2pComplianceOverview);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-271 renders risk assessment baseline', (tester) async {
    await pumpRiskAssessment(tester);

    expect(find.byType(P2PRiskAssessmentPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Risk Assessment'), findsOneWidget);
    expect(find.text('Rủi ro · P2P'), findsOneWidget);
    expect(find.byKey(P2PRiskAssessmentPage.scoreHeroKey), findsOneWidget);
    expect(find.byType(VitModuleHeroCard), findsOneWidget);
    expect(find.byType(VitMetricCard), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('Low Risk'), findsOneWidget);
    expect(find.text('Risk Score: 15/100'), findsOneWidget);
    expect(find.byKey(P2PRiskAssessmentPage.infoKey), findsOneWidget);
    expect(find.text('Risk Factors'), findsOneWidget);
    expect(find.byKey(P2PRiskAssessmentPage.factorsKey), findsOneWidget);
    expect(find.text('KYC Level'), findsOneWidget);
    expect(find.text('Transaction History'), findsOneWidget);
    expect(find.text('AML Screening'), findsOneWidget);
    expect(find.text('Disputes'), findsOneWidget);
    expect(find.text('Transaction Velocity'), findsOneWidget);
    expect(find.text('+5'), findsOneWidget);
    expect(find.text('+3'), findsNWidgets(2));
    expect(find.text('+2'), findsNWidgets(2));
  });

  testWidgets('SC-271 remains stable at 360px phone baseline', (tester) async {
    await pumpRiskAssessment(tester, viewport: const Size(360, 800));

    expect(find.byType(P2PRiskAssessmentPage), findsOneWidget);
    expect(find.byKey(P2PRiskAssessmentPage.scoreHeroKey), findsOneWidget);
    expect(find.byType(VitModuleHeroCard), findsOneWidget);
    expect(find.byType(VitMetricCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-271 back returns to compliance overview', (tester) async {
    await pumpRiskAssessment(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PRiskAssessmentPage), findsNothing);
    expect(find.byType(P2PComplianceOverviewPage), findsOneWidget);
  });
}
