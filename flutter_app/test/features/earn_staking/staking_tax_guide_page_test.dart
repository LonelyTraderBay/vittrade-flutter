import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/phone/pages/tax_report_center_page.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_history_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_tax_guide_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpTaxGuide(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnStakingTaxGuide,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-356 mock repository exposes staking tax guide BE draft', () async {
    final snapshot = await const MockStakingTaxGuideRepository().getGuide();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-staking-tax-guide');
    expect(snapshot.actionDraft, contains('POST /exports'));
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Hướng dẫn Thuế');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.historyRoute, AppRoutePaths.earnHistory);
    expect(snapshot.taxReportsRoute, AppRoutePaths.taxReports);
    expect(snapshot.tabs.map((tab) => tab.id), [
      'overview',
      'jurisdictions',
      'calculator',
    ]);
    expect(snapshot.countrySummaries, hasLength(5));
    expect(snapshot.jurisdictions, hasLength(6));
    expect(snapshot.faqs, hasLength(4));
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

  testWidgets('SC-356 renders overview baseline in Earn shell', (tester) async {
    await pumpTaxGuide(tester);

    expect(find.byType(StakingTaxGuidePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hướng dẫn Thuế'), findsOneWidget);
    expect(find.byKey(StakingTaxGuidePage.disclaimerKey), findsOneWidget);
    expect(find.byKey(StakingTaxGuidePage.overviewKey), findsOneWidget);
    expect(find.text('Tại sao phải khai báo thuế?'), findsOneWidget);
    expect(find.text('Khi nhận phần thưởng'), findsOneWidget);
    expect(find.byKey(StakingTaxGuidePage.summaryKey), findsOneWidget);
  });

  testWidgets('SC-356 jurisdiction tab switches selected country', (
    tester,
  ) async {
    await pumpTaxGuide(tester);

    await tester.tap(find.text('Theo quốc gia'));
    await tester.pumpAndSettle();

    expect(find.text('Hoa Kỳ (United States)'), findsOneWidget);
    expect(find.text('IRS (Internal Revenue Service)'), findsOneWidget);

    await tester.tap(find.byKey(StakingTaxGuidePage.jurisdictionKey('sg')));
    await tester.pumpAndSettle();

    expect(find.text('Singapore'), findsWidgets);
    expect(
      find.text('IRAS (Inland Revenue Authority of Singapore)'),
      findsOneWidget,
    );
    expect(find.text('IRAS e-Tax Guide on Digital Tokens'), findsOneWidget);
  });

  testWidgets('SC-356 calculator computes tax estimate state', (tester) async {
    await pumpTaxGuide(tester);

    await tester.tap(find.text('Máy tính').first);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('sc356_tax_rewards_input')),
      '1000',
    );
    await tester.enterText(find.byKey(const Key('sc356_tax_rate_input')), '30');
    await tester.pumpAndSettle();

    expect(find.byKey(StakingTaxGuidePage.calculatorResultKey), findsOneWidget);
    expect(find.text(r'$1,000'), findsOneWidget);
    expect(find.text(r'-$300'), findsOneWidget);
    expect(find.text(r'$700'), findsOneWidget);
  });

  testWidgets('SC-356 support tools navigate to safe target routes', (
    tester,
  ) async {
    await pumpTaxGuide(tester);

    final historyTool = find.byKey(StakingTaxGuidePage.historyToolKey);
    await Scrollable.ensureVisible(tester.element(historyTool), alignment: .65);
    await tester.pumpAndSettle();
    await tester.tap(historyTool);
    await tester.pumpAndSettle();

    expect(find.byType(StakingHistoryPage), findsOneWidget);
    expect(find.text('Lịch sử Staking'), findsOneWidget);

    await pumpTaxGuide(tester);

    final taxReportsTool = find.byKey(StakingTaxGuidePage.taxReportsToolKey);
    await Scrollable.ensureVisible(
      tester.element(taxReportsTool),
      alignment: .7,
    );
    await tester.pumpAndSettle();
    await tester.tap(taxReportsTool);
    await tester.pumpAndSettle();

    expect(find.byType(TaxReportCenterPage), findsOneWidget);
  });

  testWidgets('SC-356 header back returns to staking route', (tester) async {
    await pumpTaxGuide(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
