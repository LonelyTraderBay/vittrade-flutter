import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/governance/client_categorization_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/disclosures/regulatory_disclosures_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/security_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpClientCategorization(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyClientCategorization,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpClientOptUp(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyClientOptUpRequest,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-099 mock repository exposes client categorization BE draft',
    () async {
      final snapshot = await const MockTradeRegulatoryRepository(
        loadDelay: Duration.zero,
      ).getClientCategorization();

      expect(snapshot.defaultTab, 'overview');
      expect(snapshot.currentCategoryId, 'retail');
      expect(snapshot.categories.map((category) => category.label), [
        'Khách hàng bán lẻ',
        'Khách hàng chuyên nghiệp',
        'Đối tác đủ điều kiện',
      ]);
      expect(snapshot.categories.first.protections.length, 8);
      expect(snapshot.categories.first.requirements.length, 3);
      expect(snapshot.history.map((entry) => entry.action), [
        'categorized',
        'opt-up-requested',
      ]);
      expect(
        snapshot.supportedStates,
        containsAll([
          TradeScreenState.loading,
          TradeScreenState.empty,
          TradeScreenState.error,
          TradeScreenState.offline,
          TradeScreenState.realtimeRefresh,
        ]),
      );
    },
  );

  testWidgets('SC-099 renders client categorization inside Trade shell', (
    tester,
  ) async {
    await pumpClientCategorization(tester);

    expect(find.byType(ClientCategorizationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân loại khách hàng'), findsOneWidget);
    expect(find.text('Phân loại MiFID II'), findsWidgets);
    expect(find.text('Đang áp dụng bảo vệ tối đa'), findsOneWidget);
    expect(find.text('Hạng khách hàng'), findsOneWidget);
    expect(
      find.byKey(ClientCategorizationPage.categoryKey('retail')),
      findsOneWidget,
    );
    expect(find.text('Khách hàng chuyên nghiệp'), findsOneWidget);
  });

  testWidgets('SC-099 first viewport reaches classification review panel', (
    tester,
  ) async {
    await pumpClientCategorization(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ClientCategorizationPage',
      semanticLabel: 'Phân loại khách hàng theo quy định MiFID II',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Rà soát phân loại khách hàng'),
      minVisibleHeight: 24,
      targetLabel: 'client classification review panel',
      reason:
          'Client categorization must expose the compliance review panel above '
          'bottom navigation before category inventory and tab content.',
    );
  });

  testWidgets('SC-411 opt-up first viewport reaches criteria review', (
    tester,
  ) async {
    await pumpClientOptUp(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ClientOptUpRequestPage',
      semanticLabel:
          'Yêu cầu nâng hạng lên khách hàng chuyên nghiệp (MiFID II)',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ClientOptUpRequestPage.criteriaKey),
      minVisibleHeight: 24,
      targetLabel: 'professional criteria confirmation',
      reason:
          'Opt-up request must show the first required acknowledgement above '
          'bottom navigation before the submit action.',
    );
  });

  testWidgets('SC-099 switches protections, requirements, and history tabs', (
    tester,
  ) async {
    await pumpClientCategorization(tester);

    // The segmented tab row sits low enough in the compact layout that it
    // initially renders behind the fixed bottom navigation bar's hit-test
    // band; scroll it clear before interacting.
    await tester.scrollUntilVisible(
      ClientCategorizationPage.tabKey('protections').asFinder(),
      120,
      scrollable: find
          .descendant(
            of: find.byType(ClientCategorizationPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();

    await tester.tap(ClientCategorizationPage.tabKey('protections').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('So sánh bảo vệ'), findsOneWidget);
    expect(find.text('Bắt buộc kiểm tra phù hợp đầy đủ'), findsOneWidget);

    await tester.tap(
      ClientCategorizationPage.tabKey('requirements').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.text('Yêu cầu đủ điều kiện'), findsOneWidget);
    expect(find.text('Danh mục trên EUR 500.000'), findsOneWidget);

    await tester.tap(ClientCategorizationPage.tabKey('history').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Lịch sử hạng'), findsOneWidget);
    expect(find.text('Phân loại ban đầu'), findsOneWidget);
    expect(find.text('Đã gửi yêu cầu nâng hạng'), findsOneWidget);
  });

  testWidgets('SC-411 opt-up edge uses scoped request route', (tester) async {
    await pumpClientCategorization(tester);

    await tester.ensureVisible(find.byKey(ClientCategorizationPage.optUpKey));
    await tester.tap(find.byKey(ClientCategorizationPage.optUpKey));
    await tester.pumpAndSettle();

    expect(find.byType(ClientOptUpRequestPage), findsOneWidget);
    expect(find.text('Yêu cầu nâng hạng khách hàng'), findsOneWidget);
  });

  testWidgets('SC-099 quick links resolve to disclosure and settings routes', (
    tester,
  ) async {
    await pumpClientCategorization(tester);

    await tester.scrollUntilVisible(
      find.byKey(ClientCategorizationPage.disclosuresKey),
      120,
      scrollable: find
          .descendant(
            of: find.byType(ClientCategorizationPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.drag(
      find.byKey(ClientCategorizationPage.contentKey),
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ClientCategorizationPage.disclosuresKey));
    await tester.pumpAndSettle();

    expect(find.byType(RegulatoryDisclosuresPage), findsOneWidget);
    expect(find.text('Regulatory Disclosures'), findsOneWidget);

    await pumpClientCategorization(tester);
    await tester.scrollUntilVisible(
      find.byKey(ClientCategorizationPage.settingsKey),
      120,
      scrollable: find
          .descendant(
            of: find.byType(ClientCategorizationPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.drag(
      find.byKey(ClientCategorizationPage.contentKey),
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ClientCategorizationPage.settingsKey));
    await tester.pumpAndSettle();

    expect(find.byType(SecurityPage), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
