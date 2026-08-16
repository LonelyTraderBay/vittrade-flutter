import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_universal_preset_library_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPresetLibrary(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaStudioPresets,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-187 mock repository exposes Preset Library BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaPresetLibrary();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-studio-presets');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.sections.map((section) => section.id), [
      'domains',
      'suggestions',
      'dropdowns',
      'demo_flows',
      'titles',
    ]);
    expect(snapshot.domainPacks.length, 10);
    expect(snapshot.domainPacks.map((pack) => pack.id), contains('crypto'));
    expect(snapshot.suggestionsByDomain.keys, contains('sports'));
    expect(snapshot.demoFlows.map((flow) => flow.domainId), contains('crypto'));
    expect(
      snapshot.supportedStates,
      containsAll([
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-187 renders Universal Preset Library baseline', (
    tester,
  ) async {
    await pumpPresetLibrary(tester);

    expect(find.byType(ArenaUniversalPresetLibraryPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Preset Library'), findsOneWidget);
    expect(find.text('Preset an toàn · Points only'), findsOneWidget);
    expect(find.text('Domain Packs'), findsWidgets);
    expect(find.text('10 lĩnh vực bao phủ mọi loại challenge'), findsOneWidget);
    expect(find.text('Thể thao'), findsOneWidget);
    expect(find.text('Esports / Game'), findsOneWidget);
    expect(find.text('Crypto / Markets'), findsOneWidget);
    expect(find.text('Khác / Custom'), findsOneWidget);
  });

  testWidgets('SC-187 expands a domain pack with examples', (tester) async {
    await pumpPresetLibrary(tester);

    await tester.tap(
      find.byKey(ArenaUniversalPresetLibraryPage.domainKey('crypto')),
    );
    await tester.pumpAndSettle();

    expect(find.text('CHALLENGE TYPES HỖ TRỢ'), findsOneWidget);
    expect(find.text('BTC vượt mốc \$100K không?'), findsOneWidget);
    expect(find.text('ETH ở mức nào tại thời điểm Y?'), findsOneWidget);
  });

  testWidgets('SC-187 first viewport reaches first domain pack', (
    tester,
  ) async {
    await pumpPresetLibrary(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-187 ArenaUniversalPresetLibraryPage',
      semanticLabel: 'Thư viện preset Arena Studio cho thử thách bằng điểm',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaUniversalPresetLibraryPage.sectionTabsKey),
      routeName: 'SC-187 ArenaUniversalPresetLibraryPage',
      actionLabel: 'the preset section tabs',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaUniversalPresetLibraryPage.domainKey('crypto')),
      routeName: 'SC-187 ArenaUniversalPresetLibraryPage',
      actionLabel: 'the crypto domain pack',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-187 section tabs expose suggestion and dropdown states', (
    tester,
  ) async {
    await pumpPresetLibrary(tester);

    await tester.tap(
      find.byKey(ArenaUniversalPresetLibraryPage.sectionKey('suggestions')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Suggestion Library'), findsOneWidget);
    expect(find.text('Gợi ý — Thể thao'), findsOneWidget);

    await tester.tap(find.text('Tỷ số gần đúng nhất?').first);
    await tester.pumpAndSettle();
    expect(
      find.byKey(ArenaUniversalPresetLibraryPage.selectedSuggestionKey),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(ArenaUniversalPresetLibraryPage.sectionKey('dropdowns')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(ArenaUniversalPresetLibraryPage.sectionKey('dropdowns')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Dropdown / Autocomplete'), findsOneWidget);
    expect(find.text('SEARCHABLE DROPDOWN — LĨNH VỰC'), findsOneWidget);
    expect(find.text('STATE — DISABLED'), findsOneWidget);
  });
}
