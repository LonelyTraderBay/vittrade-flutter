import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_faq_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpFAQ(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.earnFAQ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-370 mock repository exposes staking FAQ BE draft', () async {
    final snapshot = await const MockStakingFAQRepository().getFAQ();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-faq');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'FAQ');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.supportRoute, startsWith('/support?'));
    expect(snapshot.supportRoute, contains('flow=staking'));
    expect(snapshot.supportRoute, contains('staking-faq'));
    expect(snapshot.searchPlaceholder, 'Tìm câu hỏi...');
    expect(snapshot.items, hasLength(20));
    expect(
      snapshot.items.where(
        (item) => item.category == StakingFAQCategory.general,
      ),
      hasLength(5),
    );
    expect(snapshot.contractNotes, contains('riskData'));
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

  testWidgets('SC-370 renders FAQ general baseline', (tester) async {
    await pumpFAQ(tester);

    expect(find.byType(StakingFAQPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('FAQ'), findsOneWidget);
    expect(find.byKey(StakingFAQPage.searchFieldKey), findsOneWidget);
    expect(find.byKey(StakingFAQPage.tabsKey), findsOneWidget);
    expect(find.text('Cơ bản'), findsOneWidget);
    expect(find.text('Kỹ thuật'), findsOneWidget);
    expect(find.text('Nâng cao'), findsOneWidget);
    expect(find.byKey(StakingFAQPage.faqListKey), findsOneWidget);
    expect(find.byKey(StakingFAQPage.firstFaqKey), findsOneWidget);
    expect(
      find.text('Staking là gì và hoạt động như thế nào?'),
      findsOneWidget,
    );
    expect(find.text('Tôi cần bao nhiêu để bắt đầu stake?'), findsOneWidget);
    expect(find.byKey(StakingFAQPage.supportKey), findsOneWidget);
  });

  testWidgets('SC-370 expands FAQ answer', (tester) async {
    await pumpFAQ(tester);

    await tester.tap(find.byKey(StakingFAQPage.firstFaqKey));
    await tester.pumpAndSettle();

    expect(find.textContaining('hỗ trợ mạng blockchain'), findsOneWidget);
  });

  testWidgets('SC-370 switches categories and filters search', (tester) async {
    await pumpFAQ(tester);

    await tester.tap(find.text('Phí'));
    await tester.pumpAndSettle();

    expect(find.text('Có phí gì khi stake không?'), findsOneWidget);
    expect(find.text('Staking là gì và hoạt động như thế nào?'), findsNothing);

    await tester.enterText(find.byKey(StakingFAQPage.searchFieldKey), 'gas');
    await tester.pumpAndSettle();

    expect(find.text('Tìm thấy 1 kết quả'), findsOneWidget);
    expect(find.text('Gas fee có ảnh hưởng không?'), findsOneWidget);
  });

  testWidgets('SC-370 empty search and back navigation are wired', (
    tester,
  ) async {
    await pumpFAQ(tester);

    await tester.enterText(
      find.byKey(StakingFAQPage.searchFieldKey),
      'khong co ket qua',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(StakingFAQPage.emptyKey), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });

  testWidgets('SC-370 support opens contextual staking support', (
    tester,
  ) async {
    await pumpFAQ(tester);

    await tester.ensureVisible(find.byKey(StakingFAQPage.supportKey));
    await tester.tap(find.text('Live Chat'));
    await tester.pumpAndSettle();

    expect(find.text('Hồ sơ hỗ trợ'), findsOneWidget);
    expect(find.text('Staking FAQ support'), findsOneWidget);
    expect(find.text('staking-faq'), findsOneWidget);
  });
}
