import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_faq_page.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/support/presentation/phone/pages/support_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpFAQ(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsFAQ,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-336 mock repository exposes savings FAQ BE draft', () async {
    final snapshot = await const MockSavingsFAQRepository().getFAQ();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-faq');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'FAQ Tiết kiệm');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.supportRoute, startsWith('/support?'));
    expect(snapshot.supportRoute, contains('flow=staking'));
    expect(snapshot.supportRoute, contains('savings-faq'));
    expect(snapshot.categories, hasLength(6));
    expect(snapshot.items, hasLength(19));
    expect(
      snapshot.items.where(
        (item) => item.category == SavingsFAQCategory.general,
      ),
      hasLength(4),
    );
    expect(snapshot.contractNotes, contains('earnProducts'));
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

  testWidgets('SC-336 renders FAQ baseline', (tester) async {
    await pumpFAQ(tester);

    expect(find.byType(SavingsFAQPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('FAQ Tiết kiệm'), findsOneWidget);
    expect(find.text(kSavingsToolsHeaderSubtitle), findsOneWidget);
    expect(find.textContaining('APY là ước tính'), findsOneWidget);
    expect(find.text('Câu hỏi thường gặp'), findsOneWidget);
    expect(find.byKey(SavingsFAQPage.searchFieldKey), findsOneWidget);
    expect(find.text('Tất cả 19'), findsOneWidget);
    expect(find.text('19 câu hỏi'), findsOneWidget);
    expect(find.byKey(SavingsFAQPage.faqListKey), findsOneWidget);
    expect(find.text('Tiết kiệm Crypto là gì?'), findsOneWidget);
    expect(find.text('Tiết kiệm có khác Staking không?'), findsOneWidget);
  });

  testWidgets('SC-336 first viewport reaches first FAQ item', (tester) async {
    await pumpFAQ(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-336 SavingsFAQPage',
      semanticLabel: 'Câu hỏi thường gặp về Tiết kiệm',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(SavingsFAQPage.firstFaqKey),
      routeName: 'SC-336 SavingsFAQPage',
      actionLabel: 'the first FAQ item',
    );
  });

  testWidgets('SC-336 filters by category and search query', (tester) async {
    await pumpFAQ(tester);

    await tester.tap(find.byKey(SavingsFAQPage.categoryKey('products')));
    await tester.pumpAndSettle();

    expect(find.text('4 câu hỏi'), findsOneWidget);
    expect(
      find.text('Linh hoạt và Cố định khác nhau thế nào?'),
      findsOneWidget,
    );
    expect(find.text('Tiết kiệm Crypto là gì?'), findsNothing);

    await tester.enterText(find.byKey(SavingsFAQPage.searchFieldKey), 'APY');
    await tester.pumpAndSettle();

    expect(find.textContaining('đã lọc'), findsOneWidget);
  });

  testWidgets('SC-336 expands FAQ answer with feedback controls', (
    tester,
  ) async {
    await pumpFAQ(tester);

    await tester.tap(find.byKey(SavingsFAQPage.firstFaqKey));
    await tester.pumpAndSettle();

    expect(find.textContaining('tài sản kỹ thuật số'), findsOneWidget);
    expect(find.text('Hữu ích?'), findsWidgets);
    expect(find.text('Có'), findsWidgets);
    expect(find.text('Không'), findsWidgets);
  });

  testWidgets('SC-336 support and back navigation edges are wired', (
    tester,
  ) async {
    await pumpFAQ(tester);

    await tester.ensureVisible(find.byKey(SavingsFAQPage.supportButtonKey));
    await tester.tap(find.byKey(SavingsFAQPage.supportButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(SupportPage), findsOneWidget);
    expect(find.text('Hồ sơ hỗ trợ'), findsOneWidget);
    expect(find.text('Savings FAQ support'), findsOneWidget);
    expect(find.text('savings-faq'), findsOneWidget);

    await pumpFAQ(tester);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();
    expect(find.byType(SavingsPage), findsOneWidget);
  });
}
