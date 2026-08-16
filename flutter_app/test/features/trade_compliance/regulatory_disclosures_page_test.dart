import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/disclosures/regulatory_disclosures_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRegulatoryDisclosures(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyRegulatoryDisclosures,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-084 mock repository exposes regulatory disclosures BE draft',
    () async {
      final snapshot = await const MockTradeRegulatoryRepository(
        loadDelay: Duration.zero,
      ).getRegulatoryDisclosures();

      expect(snapshot.defaultTabId, 'mifid');
      expect(snapshot.tabs.map((tab) => tab.id), [
        'mifid',
        'protection',
        'restrictions',
        'liability',
        'contact',
      ]);
      expect(snapshot.heroTitle, 'Legal & Regulatory Framework');
      expect(snapshot.mifidArticles, hasLength(4));
      expect(snapshot.protection.coverage.title, 'Coverage Limit');
      expect(snapshot.restrictions.unavailableCountries, contains('Iran'));
      expect(snapshot.contacts, hasLength(3));
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

  testWidgets('SC-084 renders MiFID baseline inside the Trade shell', (
    tester,
  ) async {
    await pumpRegulatoryDisclosures(tester);

    expect(find.byType(RegulatoryDisclosuresPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Regulatory Disclosures'), findsOneWidget);
    expect(find.text('Legal & Regulatory Framework'), findsOneWidget);
    expect(find.text('MiFID II Compliance Statement'), findsOneWidget);
    expect(find.text('Article 24: Information to Clients'), findsOneWidget);
    expect(
      find.text('Article 25: Assessment of Suitability and Appropriateness'),
      findsOneWidget,
    );
    expect(find.text('Article 58: Record Keeping'), findsOneWidget);
  });

  testWidgets('SC-084 first viewport reaches MiFID article', (tester) async {
    await pumpRegulatoryDisclosures(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'RegulatoryDisclosuresPage',
      semanticLabel: 'Công bố thông tin quy định pháp lý',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Article 24: Information to Clients'),
      minVisibleHeight: 18,
      targetLabel: 'first MiFID article',
      reason:
          'Regulatory disclosures must show the first MiFID article above '
          'bottom navigation after the legal hero and disclosure tabs.',
    );
  });

  testWidgets('SC-084 tabs expose protection, restrictions, and contact copy', (
    tester,
  ) async {
    await pumpRegulatoryDisclosures(tester);

    await tester.tap(RegulatoryDisclosuresPage.tabKey('protection').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Investor Protection Scheme'), findsOneWidget);
    expect(find.text('Coverage Limit'), findsOneWidget);

    await tester.tap(
      RegulatoryDisclosuresPage.tabKey('restrictions').asFinder(),
    );
    await tester.pumpAndSettle();
    expect(find.text('Jurisdictional Restrictions'), findsOneWidget);
    expect(
      find.textContaining('Copy Trading Not Available In'),
      findsOneWidget,
    );

    await tester.tap(RegulatoryDisclosuresPage.tabKey('contact').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Regulatory Contact Information'), findsOneWidget);
    expect(find.text('Financial Conduct Authority (FCA)'), findsOneWidget);
    expect(find.text('Terms & Privacy'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
