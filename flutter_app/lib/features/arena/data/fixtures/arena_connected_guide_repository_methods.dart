part of '../repositories/mock_arena_repository.dart';

mixin _MockArenaRepositoryConnectedGuideMethods on _MockArenaRepositoryBase {
  @override
  Future<ConnectedEcosystemProductionSnapshot>
  getConnectedEcosystemProduction() async {
    await _simulateNetwork();
    return const ConnectedEcosystemProductionSnapshot(
      endpoint: '/api/mobile/arena/arena-ecosystem',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      canonicalScreens: [
        ConnectedScreenDraft(
          name: 'HomePage_vFinal_Connected',
          route: '/',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B',
          bridgeComponents: ['HomeDiscoverySection'],
          notes:
              'Discovery cards cho Predictions và Arena. Mỗi card có disclosure badge rõ module. Không merge metrics.',
        ),
        ConnectedScreenDraft(
          name: 'ProfilePage_vFinal_Connected',
          route: '/profile',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09A + 09B',
          bridgeComponents: ['ProfileModuleBlocks', 'DualModuleStatCard'],
          notes:
              'Dual surface tách biệt: Prediction Portfolio vs MyArena. Stats không bao giờ gộp.',
        ),
        ConnectedScreenDraft(
          name: 'MarketListPage_vFinal_Connected',
          route: '/markets',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B',
          bridgeComponents: ['DiscoverMoreSection'],
          notes:
              'Khám phá thêm section cuối page. Safe bridge dẫn đến Predictions hoặc Arena, có disclosure.',
        ),
        ConnectedScreenDraft(
          name: 'PredictionsHomePage_vFinal_Connected',
          route: '/predictions',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09A',
          bridgeComponents: ['TopicChipBar (shared taxonomy)'],
          notes:
              'Topic chips dùng shared taxonomy. Discovery card Arena ở cuối với badge Points only.',
        ),
        ConnectedScreenDraft(
          name: 'PredictionEventDetailPage_vFinal_Connected',
          route: '/predictions/event/:id',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B + 09C + 09D',
          bridgeComponents: [
            'ArenaRelatedRoomsSection',
            'ArenaBridgeConfirmSheet',
            'mapCategoryToTopic',
          ],
          notes:
              'Arena rooms bridge section + CTA tạo Arena từ event này, qua confirmation sheet trước khi mở Arena Studio.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaHomePage_vFinal_Connected',
          route: '/arena',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09B',
          bridgeComponents: ['PredictionInsightSection'],
          notes:
              'Prediction insight section ở cuối. Badge Market context only, không ảnh hưởng Arena Points.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaStudioPage_vFinal_Connected',
          route: '/arena/studio',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09D',
          bridgeComponents: [
            'BridgeSourceBar',
            'ModuleBoundaryBanner',
            'Bridge Safety Snapshot',
            'Linked Event rows',
          ],
          notes:
              'Khi mở từ Prediction: source bar top, suggest templates, prefill context, safety snapshot và linked event rows.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaModeDetailPage_vFinal_Connected',
          route: '/arena/mode/:id',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09C',
          bridgeComponents: ['PredictionContextCard', 'mapArenaTagToTopic'],
          notes:
              'Mode có tags liên quan prediction topic hiển thị context card với CTA xem thị trường dự đoán.',
        ),
        ConnectedScreenDraft(
          name: 'ArenaChallengeDetailPage_vFinal_Connected',
          route: '/arena/challenge/:id',
          status: ConnectedEcosystemScreenStatus.vFinal,
          source: '09C + 09D',
          bridgeComponents: [
            'PredictionContextCard',
            'LinkedSourceCard',
            'ModuleBoundaryBanner',
            'BoundaryInfoRow',
            'Boundary sheet',
          ],
          notes:
              'Prediction context bridge + linked source card. Disclosure: kết quả room Arena không phải kết quả trade.',
        ),
      ],
      bridgeStates: [
        ConnectedBridgeStateDraft(
          id: 'linked_available',
          label: 'Linked context available',
          description:
              'Bridge context tồn tại và valid. Hiển thị bridge card + disclosure.',
          tone: ArenaBridgeTone.disclosure,
          affectedScreens: [
            'PredictionEventDetail',
            'ArenaStudio',
            'ArenaChallengeDetail',
            'ArenaModeDetail',
          ],
          behavior:
              'Show bridge card, context bar, related rooms/events. Disclosure badge luôn hiện.',
        ),
        ConnectedBridgeStateDraft(
          id: 'linked_unavailable',
          label: 'Linked context unavailable',
          description: 'Event hoặc room nguồn không còn tồn tại hoặc bị xoá.',
          tone: ArenaBridgeTone.blocked,
          affectedScreens: ['ArenaChallengeDetail', 'ArenaStudio'],
          behavior:
              'Show fallback card, disable CTA xem event gốc, giữ room hoạt động bình thường.',
        ),
        ConnectedBridgeStateDraft(
          id: 'stale_context',
          label: 'Stale context',
          description: 'Context quá cũ hoặc event đã resolved/expired.',
          tone: ArenaBridgeTone.arena,
          affectedScreens: ['ArenaChallengeDetail', 'ArenaStudio'],
          behavior:
              'Show warning chip Context cũ. CTA vẫn navigate đến event ở trạng thái resolved.',
        ),
        ConnectedBridgeStateDraft(
          id: 'no_arena_rooms',
          label: 'No related Arena rooms',
          description: 'Prediction event chưa có rooms Arena liên quan.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['PredictionEventDetail'],
          behavior:
              'Ẩn ArenaRelatedRoomsSection, vẫn giữ CTA tạo Arena từ event này.',
        ),
        ConnectedBridgeStateDraft(
          id: 'no_prediction_events',
          label: 'No related Prediction events',
          description:
              'Arena mode/challenge không có Prediction events match topic.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['ArenaChallengeDetail', 'ArenaModeDetail'],
          behavior:
              'Ẩn PredictionContextCard và link hiểu ranh giới. Room hoạt động bình thường.',
        ),
        ConnectedBridgeStateDraft(
          id: 'bridge_disabled',
          label: 'Bridge disabled',
          description:
              'Feature flag tắt bridge do maintenance hoặc chưa launch.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['All connected screens'],
          behavior:
              'Ẩn toàn bộ bridge sections, không hiện error hay empty state.',
        ),
        ConnectedBridgeStateDraft(
          id: 'context_removed',
          label: 'Context removed by user',
          description: 'User bấm bỏ liên kết trên BridgeSourceBar.',
          tone: ArenaBridgeTone.neutral,
          affectedScreens: ['ArenaStudio'],
          behavior:
              'Ẩn BridgeSourceBar, steps trở về trạng thái tạo room thường.',
        ),
        ConnectedBridgeStateDraft(
          id: 'verified_locked',
          label: 'Verified future locked',
          description: 'Bridge features chưa mở cho verified/future screens.',
          tone: ArenaBridgeTone.prediction,
          affectedScreens: ['VerifiedChallengesPage'],
          behavior:
              'Hien release-gated preview message, khong navigate va khong CTA.',
        ),
      ],
      connectedFlows: [
        ConnectedFlowDraft(
          id: 'prediction_to_arena',
          name: 'Prediction to Arena Studio',
          tone: ArenaBridgeTone.arena,
          steps: [
            ConnectedFlowStepDraft(
              label: 'Home',
              route: '/',
              description: 'Discovery section -> tap Predictions card.',
            ),
            ConnectedFlowStepDraft(
              label: 'PredictionsHome',
              route: '/predictions',
              description: 'Browse events, filter by topic.',
            ),
            ConnectedFlowStepDraft(
              label: 'EventDetail',
              route: '/predictions/event/:id',
              description: 'Xem event, scroll đến Arena section.',
            ),
            ConnectedFlowStepDraft(
              label: 'ConfirmSheet',
              route: '/predictions/event/:id',
              description:
                  'Tạo room Arena từ event này? Confirmation sheet có 3 disclosure bullets.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'ArenaStudio',
              route: '/arena/studio',
              description:
                  'BridgeSourceBar top, suggested templates, prefill context.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'ChallengeDetail',
              route: '/arena/challenge/:id',
              description: 'Room created, linked source card hiện event gốc.',
              isBridge: true,
            ),
          ],
        ),
        ConnectedFlowDraft(
          id: 'arena_to_prediction',
          name: 'Arena to Prediction Market',
          tone: ArenaBridgeTone.content,
          steps: [
            ConnectedFlowStepDraft(
              label: 'ArenaHome',
              route: '/arena',
              description: 'Browse modes and rooms.',
            ),
            ConnectedFlowStepDraft(
              label: 'ModeDetail',
              route: '/arena/mode/:id',
              description:
                  'PredictionContextCard hiện khi mode có related topic.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'ChallengeDetail',
              route: '/arena/challenge/:id',
              description: 'Context card + sheet hiểu ranh giới.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'PredictionEvent',
              route: '/predictions/event/:id',
              description: 'Navigate qua CTA xem thị trường dự đoán.',
              isBridge: true,
            ),
          ],
        ),
        ConnectedFlowDraft(
          id: 'profile_dual',
          name: 'Profile dual surfaces',
          tone: ArenaBridgeTone.prediction,
          steps: [
            ConnectedFlowStepDraft(
              label: 'Profile',
              route: '/profile',
              description: 'ProfileModuleBlocks: 2 cards tách biệt.',
            ),
            ConnectedFlowStepDraft(
              label: 'PredictionPortfolio',
              route: '/predictions/portfolio',
              description: 'Prediction card -> positions and P/L.',
            ),
            ConnectedFlowStepDraft(
              label: 'MyArena',
              route: '/profile/arena',
              description:
                  'Arena card -> Points, rooms, trust score, non-financial.',
              isBridge: true,
            ),
          ],
        ),
        ConnectedFlowDraft(
          id: 'market_discover',
          name: 'MarketList to Khám phá thêm',
          tone: ArenaBridgeTone.disclosure,
          steps: [
            ConnectedFlowStepDraft(
              label: 'MarketList',
              route: '/markets',
              description: 'Browse crypto, scroll đến cuối.',
            ),
            ConnectedFlowStepDraft(
              label: 'DiscoverMore',
              route: '/markets',
              description: 'Predictions card + Arena card.',
              isBridge: true,
            ),
            ConnectedFlowStepDraft(
              label: 'Choice: Predictions',
              route: '/predictions',
              description: 'Tap Dự đoán thị trường -> PredictionsHome.',
            ),
            ConnectedFlowStepDraft(
              label: 'Choice: Arena',
              route: '/arena',
              description: 'Tap Open Arena -> ArenaHome.',
            ),
          ],
        ),
      ],
      sharedItems: [
        ConnectedRegistryItemDraft(
          name: 'Topic Taxonomy',
          description: '8 shared topics dùng chung cho Predictions và Arena.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Context Cards',
          description:
              'PredictionContextCard và ArenaRelatedRoomCard bridge by content, not value.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Discovery Cards',
          description:
              'HomeDiscoverySection và DiscoverMoreSection là entry points an toàn.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Profile Surface',
          description:
              'ProfileModuleBlocks đặt 2 blocks tách biệt trên cùng một profile page.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Bridge Disclosures',
          description:
              'ModuleBoundaryBanner, BoundaryInfoRow, ModuleLabelBadge dùng chung.',
        ),
      ],
      separateItems: [
        ConnectedRegistryItemDraft(
          name: 'Wallet',
          description: 'Prediction có real wallet. Arena không có wallet.',
        ),
        ConnectedRegistryItemDraft(
          name: 'PnL',
          description:
              'Prediction có profit/loss bằng tiền thật. Arena chỉ có net points change.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Points Ledger',
          description: 'Arena only. Prediction không dùng points system.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Order Receipts',
          description:
              'Prediction trade receipts khác Arena result receipt points-only.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Settlement',
          description:
              'Prediction settlement tách biệt với Arena points redistribution.',
        ),
        ConnectedRegistryItemDraft(
          name: 'Leaderboard Metrics',
          description: 'Prediction ranking và Arena ranking không bao giờ gộp.',
        ),
      ],
      forbiddenPatterns: [
        ConnectedForbiddenPatternDraft(
          pattern: 'Points cạnh PnL',
          reason:
              'Arena Points là điểm chơi, PnL là tiền thật. Đặt cạnh nhau gây nhầm lẫn.',
          severity: ConnectedRuleSeverity.critical,
        ),
        ConnectedForbiddenPatternDraft(
          pattern: 'Merged leaderboard',
          reason: 'Gộp points Arena với PnL Prediction sai bản chất 2 module.',
          severity: ConnectedRuleSeverity.critical,
        ),
        ConnectedForbiddenPatternDraft(
          pattern: 'Wallet wording trong Arena',
          reason: 'Không dùng Ví, Số dư, Tài sản trong Arena bridge context.',
          severity: ConnectedRuleSeverity.critical,
        ),
        ConnectedForbiddenPatternDraft(
          pattern: 'Arena card thiếu disclosure',
          reason:
              'Mọi bridge card Arena phải có badge Points only hoặc Market context only.',
          severity: ConnectedRuleSeverity.high,
        ),
      ],
      routeRegistry: [
        ConnectedRouteEntryDraft(
          route: '/',
          page: 'HomePage',
          bridgeType: ConnectedBridgeType.source,
          bridgeComponents: ['HomeDiscoverySection'],
        ),
        ConnectedRouteEntryDraft(
          route: '/profile',
          page: 'ProfilePage',
          bridgeType: ConnectedBridgeType.bidirectional,
          bridgeComponents: ['ProfileModuleBlocks'],
        ),
        ConnectedRouteEntryDraft(
          route: '/markets',
          page: 'MarketListPage',
          bridgeType: ConnectedBridgeType.source,
          bridgeComponents: ['DiscoverMoreSection'],
        ),
        ConnectedRouteEntryDraft(
          route: '/predictions',
          page: 'PredictionsHomePage',
          bridgeType: ConnectedBridgeType.source,
          bridgeComponents: ['TopicChipBar'],
        ),
        ConnectedRouteEntryDraft(
          route: '/predictions/event/:id',
          page: 'PredictionEventDetailPage',
          bridgeType: ConnectedBridgeType.source,
          bridgeComponents: ['ArenaRelatedRoomsSection'],
        ),
        ConnectedRouteEntryDraft(
          route: '/arena',
          page: 'ArenaHomePage',
          bridgeType: ConnectedBridgeType.target,
          bridgeComponents: ['PredictionInsightSection'],
        ),
        ConnectedRouteEntryDraft(
          route: '/arena/studio',
          page: 'ArenaStudioPage',
          bridgeType: ConnectedBridgeType.target,
          bridgeComponents: ['BridgeSourceBar'],
        ),
        ConnectedRouteEntryDraft(
          route: '/arena/mode/:id',
          page: 'ArenaModeDetailPage',
          bridgeType: ConnectedBridgeType.target,
          bridgeComponents: ['PredictionContextCard'],
        ),
        ConnectedRouteEntryDraft(
          route: '/arena/challenge/:id',
          page: 'ArenaChallengeDetailPage',
          bridgeType: ConnectedBridgeType.bidirectional,
          bridgeComponents: ['PredictionContextCard', 'LinkedSourceCard'],
        ),
      ],
      componentRegistry: [
        ConnectedComponentEntryDraft(
          name: 'HomeDiscoverySection',
          file: 'ArenaPredictionBridges.tsx',
          module: '07D',
          usedIn: ['HomePage'],
          disclosure: 'Mỗi card có badge module.',
        ),
        ConnectedComponentEntryDraft(
          name: 'PredictionContextCard',
          file: 'ArenaPredictionBridges.tsx',
          module: '07D',
          usedIn: ['ArenaChallengeDetail', 'ArenaModeDetail'],
          disclosure: 'Market context only badge.',
        ),
        ConnectedComponentEntryDraft(
          name: 'BridgeSourceBar',
          file: 'ArenaPredictionFoundation.tsx',
          module: '09A',
          usedIn: ['ArenaStudio'],
          disclosure: 'Nguồn bối cảnh + remove action.',
        ),
        ConnectedComponentEntryDraft(
          name: 'DualModuleStatCard',
          file: 'ArenaPredictionFoundation.tsx',
          module: '09A',
          usedIn: ['ProfileModuleBlocks'],
          disclosure: 'Separate stat blocks.',
        ),
      ],
      bridgeRules: [
        ConnectedBridgeRuleDraft(
          field: 'eventId',
          allowed: true,
          reason: 'Identify prediction event nguồn, chỉ dùng để link back.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'topic',
          allowed: true,
          reason: 'Shared topic taxonomy. Neutral content classification.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'wallet balance',
          allowed: false,
          reason: 'Số dư ví là dữ liệu tài chính, không carry qua Arena.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'PnL',
          allowed: false,
          reason: 'Profit/loss là dữ liệu giao dịch thật, Arena chỉ có points.',
        ),
        ConnectedBridgeRuleDraft(
          field: 'settlement records',
          allowed: false,
          reason: 'Arena chỉ settle points, không nhận settlement tài chính.',
        ),
      ],
      qaChecklist: [
        ConnectedQaCheckDraft(
          id: 'qa1',
          category: 'Disclosure',
          check: 'Mọi bridge card có disclosure badge.',
          severity: ConnectedQaSeverity.must,
        ),
        ConnectedQaCheckDraft(
          id: 'qa2',
          category: 'Boundary',
          check: 'Prediction và Arena stats tách biệt, không gộp.',
          severity: ConnectedQaSeverity.must,
        ),
        ConnectedQaCheckDraft(
          id: 'qa3',
          category: 'Navigation',
          check:
              'Prediction -> Arena flow có confirmation sheet trước navigate.',
          severity: ConnectedQaSeverity.must,
        ),
        ConnectedQaCheckDraft(
          id: 'qa4',
          category: 'State',
          check: 'Bridge disabled state ẩn sạch bridge sections.',
          severity: ConnectedQaSeverity.should,
        ),
      ],
      footerDisclosure:
          'Trang này dành cho PM / Designer / Dev / QA, không phải user-facing. Toàn bộ nội dung là handoff documentation cho hệ sinh thái kết nối giữa Open Arena (points-only) và Prediction Markets (real positions).',
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }

  @override
  Future<ArenaGuideSnapshot> getArenaGuide() async {
    await _simulateNetwork();
    return const ArenaGuideSnapshot(
      endpoint: '/api/mobile/arena/arena-guide',
      actionDraft:
          'POST /arena/challenges|join|resolve|report where applicable',
      heroTitle: 'Tạo challenge đầu tiên trong 5 phút',
      heroSubtitle:
          'Chỉ 6 bước đơn giản - có gợi ý thông minh giúp bạn tạo challenge hấp dẫn',
      createSteps: [
        ArenaGuideStepDraft(
          step: 1,
          iconKey: 'layers',
          title: 'Chọn Template',
          description:
              'Chọn template phù hợp: Dự đoán, Thử thách, Cá cược bạn bè. Mỗi template có luật và cấu trúc sẵn giúp bạn bắt đầu nhanh.',
          tip: 'Bắt đầu với "Dự đoán giá" - đơn giản và phổ biến nhất.',
          tone: ArenaGuideTone.accent,
        ),
        ArenaGuideStepDraft(
          step: 2,
          iconKey: 'users',
          title: 'Thiết lập cấu trúc',
          description:
              'Chọn format: 1v1, team vs team hoặc Open Lobby. Cài đặt số người tham gia tối đa và kiểu tham gia.',
          tip: 'Open Lobby phù hợp khi bạn muốn nhiều người tham gia.',
          tone: ArenaGuideTone.info,
        ),
        ArenaGuideStepDraft(
          step: 3,
          iconKey: 'file',
          title: 'Viết luật chơi',
          description:
              'Đặt tên, mô tả rõ ràng, chọn điều kiện thắng, luật hòa và luật hủy. Luật càng rõ - tranh chấp càng ít.',
          tip: 'Dùng Smart Rule Builder để tạo luật chuyên nghiệp tự động.',
          tone: ArenaGuideTone.success,
        ),
        ArenaGuideStepDraft(
          step: 4,
          iconKey: 'target',
          title: 'Chọn cách xác nhận kết quả',
          description:
              'Auto, Mutual Confirm, Referee hoặc Community Vote. Chọn phương án phù hợp với loại challenge.',
          tip: 'Auto resolution ít tranh chấp nhất - ưu tiên khi có thể.',
          tone: ArenaGuideTone.warning,
        ),
        ArenaGuideStepDraft(
          step: 5,
          iconKey: 'gift',
          title: 'Cài đặt Points & Phần thưởng',
          description:
              'Đặt entry points, chọn kiểu chia pool điểm như Winner All, Top 3 hoặc chia đều. Xem trước pool dự kiến.',
          tip: 'Entry 50-200 pts thu hút nhiều người nhất theo thống kê.',
          tone: ArenaGuideTone.danger,
        ),
        ArenaGuideStepDraft(
          step: 6,
          iconKey: 'check',
          title: 'Review & Đăng',
          description:
              'Kiểm tra toàn bộ thông tin, preview trước khi publish. Hệ thống sẽ kiểm tra Rule Clarity Score và đưa gợi ý.',
          tip: 'Rule Clarity Score >= 80% - challenge ít bị tranh chấp.',
          tone: ArenaGuideTone.arena,
        ),
      ],
      joinSteps: [
        ArenaGuideStepDraft(
          step: 1,
          iconKey: 'search',
          title: 'Tìm challenge phù hợp',
          description:
              'Duyệt phòng đang mở, lọc theo category, format, entry points hoặc tìm kiếm theo tên.',
          tip: 'Lọc theo Fair Play để chơi an toàn hơn.',
          tone: ArenaGuideTone.info,
        ),
        ArenaGuideStepDraft(
          step: 2,
          iconKey: 'eye',
          title: 'Xem chi tiết & luật chơi',
          description:
              'Đọc kỹ luật, điều kiện thắng và cách xác nhận kết quả. Kiểm tra Trust Score của creator.',
          tip: 'Creator có Trust >= 85% thường tạo challenge chất lượng.',
          tone: ArenaGuideTone.accent,
        ),
        ArenaGuideStepDraft(
          step: 3,
          iconKey: 'zap',
          title: 'Tham gia bằng Arena Points',
          description:
              'Xác nhận entry points và chọn vị trí hoặc đội nếu có. Points được khóa trong pool đến khi có kết quả.',
          tip: 'Points được khóa an toàn - không ai rút trước kết quả.',
          tone: ArenaGuideTone.warning,
        ),
        ArenaGuideStepDraft(
          step: 4,
          iconKey: 'trophy',
          title: 'Chờ kết quả & nhận points',
          description:
              'Kết quả tự xác nhận hoặc cần vote. Nếu thắng, Arena Points được cộng theo luật pool đã công bố.',
          tip: 'Theo dõi timeline trực tiếp trên trang challenge.',
          tone: ArenaGuideTone.success,
        ),
      ],
      proTips: [
        ArenaGuideTipDraft(
          iconKey: 'target',
          title: 'Đặt tên hấp dẫn, rõ ràng',
          description:
              'Tên tốt: "BTC phá 100K trước 30/6?" - ngắn, rõ chủ đề, có deadline. Tránh tiêu đề mơ hồ.',
          category: 'naming',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'file',
          title: 'Viết luật chơi chi tiết',
          description:
              'Nêu rõ nguồn dữ liệu, điều kiện thắng, cách xử lý hòa hoặc hủy. Smart Rule Builder giúp chuẩn hóa luật.',
          category: 'rules',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'points',
          title: 'Entry points vừa phải',
          description:
              'Entry 50-200 pts thu hút nhiều người và giảm áp lực cho người mới. Entry cao chỉ nên dùng khi creator đã có uy tín.',
          category: 'points',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'clock',
          title: 'Thời hạn hợp lý',
          description:
              'Challenge 1-7 ngày hoạt động tốt nhất. Quá ngắn thì ít người kịp join, quá dài thì giảm hứng thú.',
          category: 'timing',
          impact: ArenaGuideImpact.medium,
        ),
        ArenaGuideTipDraft(
          iconKey: 'tag',
          title: 'Gắn tag đúng category',
          description:
              'Tag chính xác giúp challenge xuất hiện đúng đối tượng. Crypto, Sports, Tech - chọn theo nội dung.',
          category: 'discovery',
          impact: ArenaGuideImpact.medium,
        ),
        ArenaGuideTipDraft(
          iconKey: 'shield',
          title: 'Bật Fair Play badge',
          description:
              'Lưu challenge thành Mode và xây dựng Trust Score. Badge giúp người tham gia hiểu tiêu chuẩn an toàn.',
          category: 'trust',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'auto',
          title: 'Ưu tiên Auto Resolution',
          description:
              'Kết quả tự động giúp giảm tranh chấp. Dùng nguồn dữ liệu uy tín nếu loại challenge cho phép.',
          category: 'resolution',
          impact: ArenaGuideImpact.high,
        ),
        ArenaGuideTipDraft(
          iconKey: 'trophy',
          title: 'Phân thưởng dễ hiểu',
          description:
              'Top 3 hoặc Top 5 phù hợp khi có nhiều người. Winner Takes All chỉ nên dùng cho 1v1 hoặc nhóm nhỏ.',
          category: 'rewards',
          impact: ArenaGuideImpact.medium,
        ),
      ],
      safetyTips: [
        ArenaGuideSafetyTipDraft(
          iconKey: 'shield',
          title: 'Points, không phải tiền thật',
          description:
              'Arena chỉ dùng Arena Points - không liên quan đến tài sản crypto hay fiat.',
          tone: ArenaGuideTone.info,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'lock',
          title: 'Pool điểm được khóa an toàn',
          description:
              'Entry points được khóa trong pool đến khi challenge kết thúc và có kết quả. Creator không thể rút riêng.',
          tone: ArenaGuideTone.accent,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'warning',
          title: 'Đọc kỹ luật trước khi join',
          description:
              'Luôn đọc hết luật chơi, điều kiện thắng thua và cách xác nhận kết quả trước khi tham gia.',
          tone: ArenaGuideTone.warning,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'eye',
          title: 'Kiểm tra Trust Score creator',
          description:
              'Ưu tiên challenge từ creator có Trust Score cao và Fair Play badge. Xem lịch sử tranh chấp khi cần.',
          tone: ArenaGuideTone.success,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'report',
          title: 'Báo cáo nếu nghi ngờ',
          description:
              'Thấy challenge bất thường? Báo cáo để đội ngũ kiểm tra trong 24h và bảo vệ cộng đồng.',
          tone: ArenaGuideTone.danger,
        ),
        ArenaGuideSafetyTipDraft(
          iconKey: 'file',
          title: 'Tranh chấp có quy trình rõ ràng',
          description:
              'Resolution Center cho phép gửi bằng chứng, theo dõi timeline và nhận kết luận minh bạch.',
          tone: ArenaGuideTone.arena,
        ),
      ],
      faqs: [
        ArenaGuideFaqDraft(
          question: 'Arena Points là gì?',
          answer:
              'Arena Points là đơn vị dùng trong Open Arena để tham gia challenge. Points không phải tiền thật và không liên quan đến crypto hoặc fiat.',
        ),
        ArenaGuideFaqDraft(
          question: 'Tạo challenge có mất phí không?',
          answer:
              'Không mất phí tạo. Nếu đặt entry points, creator có thể cần góp points vào pool theo cấu hình đã công bố.',
        ),
        ArenaGuideFaqDraft(
          question: 'Làm sao để challenge thu hút nhiều người?',
          answer:
              'Đặt tên rõ, entry points vừa phải, luật minh bạch, ưu tiên Auto Resolution và chia sẻ link đúng cộng đồng.',
        ),
        ArenaGuideFaqDraft(
          question: 'Kết quả được xác nhận như thế nào?',
          answer:
              'Có 4 cách: Auto, Mutual Confirm, Referee hoặc Community Vote. Auto thường ít tranh chấp nhất khi có nguồn dữ liệu phù hợp.',
        ),
        ArenaGuideFaqDraft(
          question: 'Nếu tôi không đồng ý kết quả thì sao?',
          answer:
              'Bạn có thể mở tranh chấp trong Resolution Center, gửi bằng chứng và theo dõi quy trình xử lý minh bạch.',
        ),
        ArenaGuideFaqDraft(
          question: 'Rule Clarity Score là gì?',
          answer:
              'Điểm đánh giá mức rõ ràng của luật chơi từ 0-100%. Score cao giúp giảm tranh chấp và tăng độ tin cậy.',
        ),
      ],
      examples: [
        ArenaGuideExampleDraft(
          title: 'BTC phá 100K trước 30/6?',
          template: 'Dự đoán giá',
          entryPoints: 100,
          format: 'Open Lobby',
          resolution: 'Auto',
          rating: 'Tốt',
          tone: ArenaGuideTone.success,
          reasons: [
            'Tên rõ ràng, có deadline',
            'Entry vừa phải',
            'Auto resolution',
          ],
        ),
        ArenaGuideExampleDraft(
          title: 'Ai đoán đúng?',
          template: 'Dự đoán',
          entryPoints: 500,
          format: '1v1',
          resolution: 'Mutual',
          rating: 'Cần cải thiện',
          tone: ArenaGuideTone.warning,
          reasons: [
            'Tên mơ hồ, thiếu chủ đề',
            'Entry cao cho beginner',
            'Thiếu mô tả chi tiết',
          ],
        ),
      ],
      keyConcepts: [
        ArenaGuideConceptDraft(
          term: 'Arena Points',
          definition:
              'Đơn vị dùng trong Open Arena để tham gia challenge. Không phải tiền thật.',
        ),
        ArenaGuideConceptDraft(
          term: 'Template',
          definition:
              'Mẫu challenge có sẵn cấu trúc và luật - bạn chỉ cần điền nội dung.',
        ),
        ArenaGuideConceptDraft(
          term: 'Mode',
          definition:
              'Challenge template đã hoàn chỉnh, có thể chia sẻ và clone bởi người khác.',
        ),
        ArenaGuideConceptDraft(
          term: 'Resolution',
          definition:
              'Cách xác nhận kết quả: Auto, Mutual, Referee hoặc Community Vote.',
        ),
        ArenaGuideConceptDraft(
          term: 'Trust Score',
          definition:
              'Điểm uy tín của creator dựa trên lịch sử tạo challenge và tỷ lệ tranh chấp.',
        ),
        ArenaGuideConceptDraft(
          term: 'Rule Clarity',
          definition:
              'Điểm rõ ràng của luật chơi. Càng cao càng ít tranh chấp.',
        ),
        ArenaGuideConceptDraft(
          term: 'Fair Play',
          definition:
              'Huy hiệu cho challenge hoặc creator tuân thủ quy tắc cộng đồng.',
        ),
      ],
      checklist: [
        'Tên challenge rõ ràng, có chủ đề và deadline',
        'Mô tả đầy đủ điều kiện thắng/thua',
        'Entry points phù hợp đối tượng (50-200 pts)',
        'Chọn Resolution method, ưu tiên Auto khi có thể',
        'Kiểm tra Rule Clarity Score >= 80%',
        'Thiết lập luật hòa và luật hủy',
        'Preview và đọc lại toàn bộ trước khi đăng',
      ],
      supportedStates: {
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      },
    );
  }
}
