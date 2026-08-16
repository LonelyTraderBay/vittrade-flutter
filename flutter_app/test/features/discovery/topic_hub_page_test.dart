import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_challenge_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_studio_page.dart';
import 'package:vit_trade_flutter/features/discovery/data/discovery_repository.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/phone/pages/topic_hub_page.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/phone/pages/unified_search_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpTopics(
    WidgetTester tester, {
    DiscoveryRepository? repository,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          discoveryRepositoryProvider.overrideWithValue(
            repository ??
                const MockDiscoveryRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.topics),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpTopicCrypto(
    WidgetTester tester, {
    DiscoveryRepository? repository,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          discoveryRepositoryProvider.overrideWithValue(
            repository ??
                const MockDiscoveryRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.topicCrypto,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-284 mock repository exposes Topic Hub BE draft', () async {
    final snapshot = await const MockDiscoveryRepository().getTopicHub();

    expect(snapshot.endpoint, '/api/mobile/discovery/topics');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Trung tâm chủ đề');
    expect(snapshot.searchRoute, AppRoutePaths.search);
    expect(snapshot.predictionsRoute, AppRoutePaths.marketsPredictions);
    expect(snapshot.arenaRoute, AppRoutePaths.arena);
    expect(snapshot.createArenaRoute, AppRoutePaths.arenaStudio);
    expect(snapshot.selectedTopic.id, 'crypto');
    expect(snapshot.predictions.length, 5);
    expect(snapshot.arenaRooms.length, 2);
    expect(snapshot.arenaModes.length, 2);
    expect(snapshot.creators.length, 2);
    expect(snapshot.contractNotes, contains('vị thế Prediction'));
    expect(snapshot.contractNotes, contains('Điểm Arena'));
    expect(
      snapshot.supportedStates,
      containsAll([
        DiscoveryScreenState.loading,
        DiscoveryScreenState.empty,
        DiscoveryScreenState.error,
        DiscoveryScreenState.offline,
      ]),
    );
  });

  test('SC-285 mock repository exposes Topic Crypto BE draft', () async {
    final snapshot = await const MockDiscoveryRepository().getTopicHub(
      topicId: 'crypto',
      detailEndpoint: true,
    );

    expect(snapshot.endpoint, '/api/mobile/discovery/topic-crypto');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.selectedTopic.id, 'crypto');
    expect(snapshot.predictions.length, 5);
    expect(snapshot.arenaRooms.length, 2);
    expect(snapshot.supportedStates, contains(DiscoveryScreenState.offline));
  });

  testWidgets('SC-284 renders Topic Hub Crypto baseline', (tester) async {
    await pumpTopics(tester);

    expect(find.byType(TopicHubPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Trung tâm chủ đề'), findsOneWidget);
    expect(find.byKey(TopicHubPage.searchActionKey), findsOneWidget);
    expect(find.byKey(TopicHubPage.topicRailKey), findsOneWidget);
    expect(find.byKey(TopicHubPage.topicKey('crypto')), findsOneWidget);
    expect(find.byKey(TopicHubPage.offlineKey), findsNothing);
    expect(find.byKey(TopicHubPage.heroKey), findsOneWidget);
    expect(find.text('Crypto'), findsWidgets);
    expect(find.text('Bitcoin, Ethereum, altcoin, DeFi'), findsOneWidget);
    expect(find.byKey(TopicHubPage.predictionsSectionKey), findsOneWidget);
    expect(find.byKey(TopicHubPage.roomsSectionKey), findsOneWidget);
    expect(find.byKey(TopicHubPage.modesSectionKey), findsOneWidget);
    expect(find.byKey(TopicHubPage.creatorsSectionKey), findsOneWidget);
    expect(find.text('Bitcoin đạt \$150K trước tháng 7/2026?'), findsOneWidget);
    expect(find.text('BTC \$70K? — Tuần 9'), findsOneWidget);
    expect(find.text('Dự đoán BTC hàng tuần'), findsOneWidget);
    expect(find.text('CryptoMaster_VN'), findsWidgets);
    expect(find.byKey(TopicHubPage.createRoomKey), findsOneWidget);
    expect(find.byKey(TopicHubPage.disclosureKey), findsOneWidget);
  });

  testWidgets('SC-284 renders offline banner only for cached offline topic', (
    tester,
  ) async {
    await pumpTopics(tester, repository: const _OfflineDiscoveryRepository());

    expect(find.byType(TopicHubPage), findsOneWidget);
    expect(find.byKey(TopicHubPage.offlineKey), findsOneWidget);
  });

  testWidgets('SC-284 topic rail switches local topic state', (tester) async {
    await pumpTopics(tester);

    await tester.tap(find.byKey(TopicHubPage.topicKey('macro')));
    await tester.pumpAndSettle();

    expect(find.text('Vĩ mô'), findsWidgets);
    expect(find.text('Kinh tế vĩ mô, lãi suất, GDP, CPI'), findsOneWidget);
    expect(find.text('Fed rate cut trong kỳ họp tới?'), findsOneWidget);
  });

  testWidgets('SC-284 navigation edges are wired', (tester) async {
    await pumpTopics(tester);

    await tester.tap(find.byKey(TopicHubPage.searchActionKey));
    await tester.pumpAndSettle();
    expect(find.byType(UnifiedSearchPage), findsOneWidget);

    await pumpTopics(tester);
    await tester.tap(find.byKey(TopicHubPage.predictionKey('pred-1')));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionEventDetailPage), findsOneWidget);

    await pumpTopics(tester);
    await tester.ensureVisible(find.byKey(TopicHubPage.roomKey('ch003')));
    await tester.tap(find.byKey(TopicHubPage.roomKey('ch003')));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaChallengeDetailPage), findsOneWidget);

    await pumpTopics(tester);
    await tester.ensureVisible(find.byKey(TopicHubPage.createRoomKey));
    await tester.tap(find.text('Tạo room').last);
    await tester.pumpAndSettle();
    expect(find.byType(ArenaStudioPage), findsOneWidget);
  });

  testWidgets('SC-285 /topic/crypto renders the crypto topic detail route', (
    tester,
  ) async {
    await pumpTopicCrypto(tester);

    expect(find.byType(TopicHubPage), findsOneWidget);
    expect(find.text('Trung tâm chủ đề'), findsOneWidget);
    expect(find.byKey(TopicHubPage.topicKey('crypto')), findsOneWidget);
    expect(find.text('Crypto'), findsWidgets);
    expect(find.text('Bitcoin đạt \$150K trước tháng 7/2026?'), findsOneWidget);

    await tester.tap(find.byKey(TopicHubPage.searchActionKey));
    await tester.pumpAndSettle();
    expect(find.byType(UnifiedSearchPage), findsOneWidget);
  });
}

final class _OfflineDiscoveryRepository implements DiscoveryRepository {
  const _OfflineDiscoveryRepository();

  static const _base = MockDiscoveryRepository(loadDelay: Duration.zero);

  @override
  Future<UnifiedSearchSnapshot> getUnifiedSearch({String query = ''}) async {
    return (await _base.getUnifiedSearch(
      query: query,
    )).copyWith(currentState: DiscoveryScreenState.offline);
  }

  @override
  Future<TopicHubSnapshot> getTopicHub({
    String topicId = 'crypto',
    bool detailEndpoint = false,
  }) async {
    return (await _base.getTopicHub(
      topicId: topicId,
      detailEndpoint: detailEndpoint,
    )).copyWith(currentState: DiscoveryScreenState.offline);
  }
}
