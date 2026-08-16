import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_compliance_overview_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_kyc_status_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_source_of_funds_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpSourceOfFunds(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.p2pComplianceSourceOfFunds,
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-269 mock repository exposes source of funds BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getSourceOfFunds();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-compliance-source-of-funds');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.title, 'Source of Funds');
    expect(snapshot.subtitle, 'Tuân thủ · P2P');
    expect(snapshot.heroTitle, 'Khai báo nguồn vốn');
    expect(snapshot.sources, hasLength(5));
    expect(snapshot.sources.first.label, 'Lương/Thu nhập');
    expect(snapshot.parentRoute, AppRoutePaths.p2pComplianceOverview);
    expect(snapshot.successRoute, AppRoutePaths.p2pKycStatus);
    expect(snapshot.highRiskContractId, 'p2p_source_of_funds_review');
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

  testWidgets('SC-269 renders source of funds baseline', (tester) async {
    await pumpSourceOfFunds(tester);

    expect(find.byType(P2PSourceOfFundsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Source of Funds'), findsOneWidget);
    expect(find.text('Tuân thủ · P2P'), findsOneWidget);
    expect(find.byKey(P2PSourceOfFundsPage.heroKey), findsOneWidget);
    expect(find.text('Khai báo nguồn vốn'), findsOneWidget);
    expect(
      find.text(
        'Yêu cầu cho giao dịch lớn hoặc Tier 3. Thông tin được bảo mật.',
      ),
      findsOneWidget,
    );
    expect(find.text('Nguồn tiền chính'), findsOneWidget);
    expect(find.byKey(P2PSourceOfFundsPage.sourceListKey), findsOneWidget);
    expect(find.text('Lương/Thu nhập'), findsOneWidget);
    expect(find.text('Kinh doanh'), findsOneWidget);
    expect(find.text('Đầu tư'), findsOneWidget);
    expect(find.text('Bất động sản'), findsOneWidget);
    expect(find.text('Quà tặng/Thừa kế'), findsOneWidget);
    expect(find.text('Chi tiết bổ sung'), findsOneWidget);
    expect(
      find.text('VD: Lương từ công ty ABC, vị trí Senior Engineer'),
      findsOneWidget,
    );
    expect(find.byKey(P2PSourceOfFundsPage.ctaKey), findsOneWidget);
    expect(find.text('Gửi khai báo'), findsOneWidget);
    expect(find.byType(VitHighRiskStatePanel), findsOneWidget);
  });

  testWidgets('SC-269 remains stable at 360px phone baseline', (tester) async {
    await pumpSourceOfFunds(tester, viewport: const Size(360, 800));

    expect(find.byType(P2PSourceOfFundsPage), findsOneWidget);
    expect(find.byKey(P2PSourceOfFundsPage.heroKey), findsOneWidget);
    expect(find.byType(VitHighRiskStatePanel), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-269 is reachable from compliance overview', (tester) async {
    await pumpSourceOfFunds(
      tester,
      initialLocation: AppRoutePaths.p2pComplianceOverview,
    );

    await tester.tap(P2PComplianceOverviewPage.itemKey('sof').finder);
    await tester.pumpAndSettle();

    expect(find.byType(P2PSourceOfFundsPage), findsOneWidget);
    expect(find.text('Khai báo nguồn vốn'), findsOneWidget);
  });

  testWidgets('SC-269 enables submit and opens KYC status', (tester) async {
    await pumpSourceOfFunds(tester);

    await tester.tap(P2PSourceOfFundsPage.sourceKey('salary').finder);
    await tester.enterText(
      find.byKey(P2PSourceOfFundsPage.inputKey),
      'Lương từ công ty ABC, vị trí Senior Engineer',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PSourceOfFundsPage.ctaKey));
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận gửi khai báo nguồn vốn'), findsOneWidget);
    await tester.tap(find.byKey(P2PSourceOfFundsPage.confirmKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PKycStatusPage), findsOneWidget);
  });

  testWidgets('SC-269 back returns to compliance overview', (tester) async {
    await pumpSourceOfFunds(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PSourceOfFundsPage), findsNothing);
    expect(find.byType(P2PComplianceOverviewPage), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
