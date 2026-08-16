import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/referral/data/referral_repository.dart';
import 'package:vit_trade_flutter/features/referral/presentation/phone/pages/referral_rules_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRules(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.referralRules,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-288 mock repository exposes referral rules BE draft', () async {
    final snapshot = await const MockReferralRepository(
      loadDelay: Duration.zero,
    ).getRules();

    expect(snapshot.endpoint, '/api/mobile/referral/referral-rules');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Quy tắc chương trình');
    expect(snapshot.subtitle, 'Quy tắc · Referral');
    expect(snapshot.backRoute, AppRoutePaths.referral);
    expect(snapshot.tiers.length, 5);
    expect(snapshot.tiers[1].name, 'Bạc');
    expect(snapshot.currentTierIndex, 1);
    expect(snapshot.rewardTypes.length, 2);
    expect(snapshot.terms.length, 6);
    expect(snapshot.faqs.length, 6);
    expect(snapshot.contractNotes, contains('read-only reference'));
    expect(
      snapshot.supportedStates,
      containsAll([
        ReferralScreenState.loading,
        ReferralScreenState.empty,
        ReferralScreenState.error,
        ReferralScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-288 renders referral rules baseline', (tester) async {
    await pumpRules(tester);

    expect(find.byType(ReferralRulesPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Quy tắc chương trình'), findsOneWidget);
    expect(find.text('Quy tắc · Referral'), findsOneWidget);
    expect(find.byKey(ReferralRulesPage.tierTableKey), findsOneWidget);
    expect(find.byKey(ReferralRulesPage.tierKey('silver')), findsOneWidget);
    expect(find.text('Hiện tại'), findsOneWidget);
    expect(find.text('25%'), findsOneWidget);
    expect(find.text('\$8.00'), findsOneWidget);
    expect(find.byKey(ReferralRulesPage.rewardTypesKey), findsOneWidget);
    expect(find.text('Thưởng KYC cố định'), findsOneWidget);
    expect(find.text('Hoa hồng giao dịch'), findsOneWidget);
  });

  testWidgets('SC-288 first viewport reaches referral tier table', (
    tester,
  ) async {
    await pumpRules(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-288 ReferralRulesPage',
      semanticLabel: 'Quy tắc chương trình',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ReferralRulesPage.tierTableKey),
      routeName: 'SC-288 ReferralRulesPage',
      actionLabel: 'the referral tier table',
    );
  });

  testWidgets('SC-288 FAQ accordion updates state', (tester) async {
    await pumpRules(tester);

    expect(
      find.textContaining('Chia sẻ mã hoặc link giới thiệu'),
      findsOneWidget,
    );
    await tester.ensureVisible(find.byKey(ReferralRulesPage.faqToggleKey(0)));
    await tester.tap(find.byKey(ReferralRulesPage.faqToggleKey(0)));
    await tester.pumpAndSettle();
    expect(find.byKey(ReferralRulesPage.faqToggleKey(0)), findsOneWidget);
    await tester.ensureVisible(find.byKey(ReferralRulesPage.faqToggleKey(3)));
    await tester.tap(find.byKey(ReferralRulesPage.faqToggleKey(3)));
    await tester.pumpAndSettle();
    expect(find.textContaining('Mời càng nhiều bạn bè'), findsOneWidget);
  });

  testWidgets('SC-288 back navigation opens migrated referral home', (
    tester,
  ) async {
    await pumpRules(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('Giới thiệu bạn bè'), findsOneWidget);
  });
}
