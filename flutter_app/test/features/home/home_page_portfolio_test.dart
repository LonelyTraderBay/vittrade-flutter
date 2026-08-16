import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/data/home_mock_data.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/wallet_page.dart';

void main() {
  Future<void> pumpHome(
    WidgetTester tester, {
    HomeSnapshot? snapshot,
    bool simulateError = false,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            snapshot != null
                ? _StaticHomeRepository(snapshot)
                : MockHomeRepository(
                    simulateError: simulateError,
                    loadDelay: Duration.zero,
                  ),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-007 keeps advanced quick actions in the more sheet', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(
      find.descendant(
        of: find.byKey(HomePage.productsSectionKey),
        matching: find.text('DCA'),
      ),
      findsWidgets,
    );
    expect(
      find.descendant(
        of: find.byKey(HomePage.productsSectionKey),
        matching: find.text('Phần thưởng'),
      ),
      findsWidgets,
    );

    final moreProducts = find.descendant(
      of: find.byKey(HomePage.productsSectionKey),
      matching: find.textContaining('Xem thêm'),
    );
    await tester.ensureVisible(moreProducts);
    await tester.tap(moreProducts);
    await tester.pumpAndSettle();

    expect(find.byKey(HomePage.moreProductsSheetKey), findsOneWidget);
    expect(find.text('Thêm hành động'), findsOneWidget);
    expect(find.text('Tiết kiệm'), findsWidgets);
    expect(find.text('Launchpad'), findsWidgets);
    expect(find.text('Margin'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(HomePage.moreProductsSheetKey),
        matching: find.text('Phần thưởng'),
      ),
      findsNothing,
    );
    expect(find.text('Hỗ trợ'), findsNothing);
    expect(find.text('Giới thiệu'), findsNothing);
  });

  testWidgets('SC-007 flags leveraged products with a risk badge', (
    tester,
  ) async {
    await pumpHome(tester);

    final moreProducts = find.descendant(
      of: find.byKey(HomePage.productsSectionKey),
      matching: find.textContaining('Xem thêm'),
    );
    await tester.ensureVisible(moreProducts);
    await tester.tap(moreProducts);
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel(RegExp('Margin.*Rủi ro cao')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Bot.*Rủi ro cao')), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('Launchpad.*Rủi ro cao')),
      findsWidgets,
    );
  });

  testWidgets('SC-007 portfolio card toggles USD and BTC display', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(find.text('≈ 0.57133463 BTC'), findsOneWidget);

    await tester.tap(find.byTooltip('Chạm để đổi hiển thị USD/BTC'));
    await tester.pumpAndSettle();

    expect(find.text('0.57133463 BTC'), findsOneWidget);
    expect(find.text('\$54,276.79'), findsOneWidget);
  });

  testWidgets('SC-007 portfolio card shows onboarding empty state', (
    tester,
  ) async {
    await pumpHome(tester, snapshot: _emptyHomeSnapshot());

    expect(find.text('Chưa có tài sản'), findsOneWidget);
    expect(find.byKey(HomePage.portfolioDepositKey), findsOneWidget);
    expect(find.text('Nạp ngay'), findsOneWidget);
    expect(find.text('Xem thị trường'), findsOneWidget);
    expect(find.text('PnL hôm nay'), findsNothing);
  });

  testWidgets('SC-007 supports balance toggle and market tabs', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();

    expect(find.text('••••••'), findsOneWidget);

    final gainersTab = find.textContaining('Tăng');
    await tester.ensureVisible(gainersTab);
    await tester.pumpAndSettle();
    await tester.tap(gainersTab);
    await tester.pump();

    expect(find.text('SOL/USDT'), findsWidgets);
  });

  testWidgets('SC-007 recent products empty state offers markets CTA', (
    tester,
  ) async {
    await pumpHome(tester, snapshot: _homeSnapshotWithoutRecentProducts());

    expect(find.text('Chưa có hoạt động gần đây'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(HomePage.recentProductsSectionKey),
        matching: find.text('Khám phá thị trường'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-007 portfolio breakdown opens wallet from spot pill', (
    tester,
  ) async {
    await pumpHome(tester);

    final spotPill = find.descendant(
      of: find.byKey(HomePage.portfolioCardKey),
      matching: find.text('Spot'),
    );
    await tester.tap(spotPill);
    await tester.pumpAndSettle();

    expect(find.byType(WalletPage), findsOneWidget);
  });
}

final class _StaticHomeRepository implements HomeRepository {
  const _StaticHomeRepository(this.snapshot);

  final HomeSnapshot snapshot;

  @override
  Future<HomeSnapshot> fetchHome() async => snapshot;
}

HomeSnapshot _homeSnapshotWithoutRecentProducts() {
  final snapshot = HomeMockData.snapshot;
  return HomeSnapshot(
    totalBalance: snapshot.totalBalance,
    totalBtc: snapshot.totalBtc,
    spotBalance: snapshot.spotBalance,
    earnBalance: snapshot.earnBalance,
    fundingBalance: snapshot.fundingBalance,
    dailyPnl: snapshot.dailyPnl,
    dailyPct: snapshot.dailyPct,
    portfolioTrend7d: snapshot.portfolioTrend7d,
    notifications: snapshot.notifications,
    announcements: snapshot.announcements,
    quickActions: snapshot.quickActions,
    nextAction: snapshot.nextAction,
    recentProducts: const [],
    pairs: snapshot.pairs,
  );
}

HomeSnapshot _emptyHomeSnapshot() {
  final snapshot = HomeMockData.snapshot;
  return HomeSnapshot(
    totalBalance: 0,
    totalBtc: 0,
    spotBalance: 0,
    earnBalance: 0,
    fundingBalance: 0,
    dailyPnl: 0,
    dailyPct: 0,
    portfolioTrend7d: const [0, 0, 0, 0, 0, 0, 0],
    notifications: snapshot.notifications,
    announcements: snapshot.announcements,
    quickActions: snapshot.quickActions,
    nextAction: snapshot.nextAction,
    recentProducts: snapshot.recentProducts,
    pairs: snapshot.pairs,
  );
}
