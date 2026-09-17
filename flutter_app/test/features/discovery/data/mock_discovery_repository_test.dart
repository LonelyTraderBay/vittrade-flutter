import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/discovery/data/discovery_repository.dart';

/// Direct smoke test for [MockDiscoveryRepository]: exercises every method
/// on [DiscoveryRepository] and pins fixture literals from
/// lib/features/discovery/data/repositories/mock_discovery_repository_fixtures.dart
/// that test/features/discovery/mock_discovery_repository_test.dart only
/// asserts the shape of (hasLength/isNotEmpty). Query and topic id literals
/// reuse the values already proven in discovery_controller_test.dart and
/// topic_hub_page_test.dart.
void main() {
  const repository = MockDiscoveryRepository(loadDelay: Duration.zero);

  group('MockDiscoveryRepository smoke test', () {
    test('getUnifiedSearch with an empty query pins the trending queries and '
        'module fixtures', () async {
      final snapshot = await repository.getUnifiedSearch();

      expect(snapshot, isA<UnifiedSearchSnapshot>());
      expect(snapshot.endpoint, '/api/mobile/discovery/search');
      expect(snapshot.trendingQueries, hasLength(6));
      expect(snapshot.trendingQueries.first.label, 'Bitcoin');
      expect(snapshot.modules, hasLength(3));
      expect(snapshot.modules.first.id, 'predictions');
      expect(snapshot.modules.first.route, '/predictions');
      expect(snapshot.results.totalCount, 0);
      expect(snapshot.results.isEmpty, isTrue);
      expect(snapshot.hasQuery, isFalse);
    });

    test('getUnifiedSearch with a matching query pins the cross-module result '
        'ids', () async {
      final snapshot = await repository.getUnifiedSearch(query: 'bitcoin');

      expect(snapshot.query, 'bitcoin');
      expect(snapshot.hasQuery, isTrue);
      expect(snapshot.results.predictions.map((e) => e.id), ['pred-1']);
      expect(snapshot.results.arenaRooms.map((e) => e.id), ['ch003']);
      expect(snapshot.results.tradingPairs.map((e) => e.id), ['btcusdt']);
      expect(snapshot.results.totalCount, 3);
      expect(snapshot.results.isEmpty, isFalse);
    });

    test(
      'getUnifiedSearch falls back to empty results for an unmatched query',
      () async {
        final snapshot = await repository.getUnifiedSearch(
          query: 'zzz-no-match',
        );

        expect(snapshot.results.isEmpty, isTrue);
      },
    );

    test(
      'getTopicHub with defaults pins the crypto topic fixture counts',
      () async {
        final snapshot = await repository.getTopicHub();

        expect(snapshot, isA<TopicHubSnapshot>());
        expect(snapshot.endpoint, '/api/mobile/discovery/topics');
        expect(snapshot.topics, hasLength(8));
        expect(snapshot.selectedTopic.id, 'crypto');
        expect(snapshot.predictions, hasLength(5));
        expect(snapshot.predictions.first.id, 'pred-1');
        expect(snapshot.arenaRooms, hasLength(2));
        expect(snapshot.arenaRooms.first.id, 'ch003');
        expect(snapshot.arenaModes, hasLength(2));
        expect(snapshot.creators, hasLength(2));
        expect(snapshot.creators.first.id, 'cr001');
        expect(snapshot.hasContent, isTrue);
      },
    );

    test(
      'getTopicHub with detailEndpoint true uses a topic-scoped endpoint',
      () async {
        final snapshot = await repository.getTopicHub(detailEndpoint: true);

        expect(snapshot.endpoint, '/api/mobile/discovery/topic-crypto');
      },
    );

    test(
      'getTopicHub for a known non-default topic pins its scoped content',
      () async {
        final snapshot = await repository.getTopicHub(topicId: 'macro');

        expect(snapshot.selectedTopic.id, 'macro');
        expect(snapshot.predictions, hasLength(1));
        expect(snapshot.predictions.first.id, 'pred-2');
        expect(snapshot.arenaRooms, isEmpty);
        expect(snapshot.arenaModes, isEmpty);
        expect(snapshot.creators, isEmpty);
      },
    );

    test(
      'getTopicHub falls back to the crypto topic for an unrecognized id',
      () async {
        final snapshot = await repository.getTopicHub(
          topicId: 'does-not-exist',
        );

        expect(snapshot.selectedTopic.id, 'crypto');
        expect(snapshot.predictions, isNotEmpty);
      },
    );
  });
}
