import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/phone/pages/unified_search_page.dart';
import 'package:vit_trade_flutter/features/home/data/home_mock_data.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/news/presentation/phone/pages/news_page.dart';
import 'package:vit_trade_flutter/features/notifications/presentation/phone/pages/notifications_page.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

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

  testWidgets('SC-007 market ticker opens the pair route', (tester) async {
    await pumpHome(tester);

    // Ticker previews top movers (distinct from the Market section's
    // default "Hot" tab below) — SOL/USDT is the top 24h gainer in mock data.
    final tickerSol = find.descendant(
      of: find.byKey(HomePage.marketTickerKey),
      matching: find.text('SOL/USDT'),
    );

    expect(tickerSol, findsOneWidget);

    await tester.drag(find.byKey(HomePage.contentKey), const Offset(0, -220));
    await tester.pumpAndSettle();
    await tester.tap(tickerSol);
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
  });

  testWidgets(
    'SC-007 exposes Home outgoing navigation without porting targets',
    (tester) async {
      await pumpHome(tester);

      await tester.tap(find.byTooltip('Tìm kiếm toàn cục'));
      await tester.pumpAndSettle();

      expect(find.byType(UnifiedSearchPage), findsOneWidget);
      expect(find.text('Tìm kiếm'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.notifications_none_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationsPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Tin tức'));
      await tester.pumpAndSettle();

      expect(find.byType(NewsPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();

      final p2pAction = find.text('P2P').last;
      await tester.ensureVisible(p2pAction);
      await tester.tap(p2pAction);
      await tester.pumpAndSettle();

      expect(find.text('P2P'), findsOneWidget);
    },
  );

  testWidgets('SC-007 notification badge follows global unread state', (
    tester,
  ) async {
    await pumpHome(tester);

    expect(
      find.descendant(
        of: find.byKey(const Key('vit_bottom_nav_home')),
        matching: find.text('7'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(NotificationsPage.markAllReadKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('vit_bottom_nav_home')),
        matching: find.text('7'),
      ),
      findsNothing,
    );
  });

  testWidgets('SC-007 shows loading skeleton before snapshot resolves', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            const MockHomeRepository(loadDelay: Duration(milliseconds: 500)),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(VitSkeleton), findsWidgets);

    await tester.pumpAndSettle();
  });

  testWidgets('SC-007 error state retries home fetch', (tester) async {
    final flakyRepository = _FlakyHomeRepository();

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [homeRepositoryProvider.overrideWithValue(flakyRepository)],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tải được dữ liệu'), findsOneWidget);

    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();

    expect(find.text('Tổng tài sản ước tính'), findsOneWidget);
  });
}

final class _FlakyHomeRepository implements HomeRepository {
  var _attempts = 0;

  @override
  Future<HomeSnapshot> fetchHome() async {
    _attempts++;
    if (_attempts == 1) {
      throw StateError('home_fetch_failed');
    }
    return HomeMockData.snapshot;
  }
}

final class _StaticHomeRepository implements HomeRepository {
  const _StaticHomeRepository(this.snapshot);

  final HomeSnapshot snapshot;

  @override
  Future<HomeSnapshot> fetchHome() async => snapshot;
}
