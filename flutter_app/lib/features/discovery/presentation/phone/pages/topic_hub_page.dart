import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/discovery_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/discovery/presentation/widgets/discovery_shared_tiles.dart';

part '../../widgets/topic_hub_header.dart';
part '../../widgets/topic_hub_sections.dart';
part '../../widgets/topic_hub_cards.dart';
part '../../widgets/topic_hub_common.dart';

class TopicHubPage extends ConsumerStatefulWidget {
  const TopicHubPage({
    super.key,
    this.initialTopicId = 'crypto',
    this.useDetailEndpoint = false,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc284_topic_hub_content');
  static const topicRailKey = Key('sc284_topic_hub_rail');
  static const offlineKey = Key('sc284_topic_hub_offline');
  static const loadingKey = Key('sc284_topic_hub_loading');
  static const errorKey = Key('sc284_topic_hub_error');
  static const heroKey = Key('sc284_topic_hub_hero');
  static const predictionsSectionKey = Key('sc284_topic_hub_predictions');
  static const roomsSectionKey = Key('sc284_topic_hub_rooms');
  static const modesSectionKey = Key('sc284_topic_hub_modes');
  static const creatorsSectionKey = Key('sc284_topic_hub_creators');
  static const createRoomKey = Key('sc284_topic_hub_create_room');
  static const disclosureKey = Key('sc284_topic_hub_disclosure');
  static const searchActionKey = Key('sc284_topic_hub_search_action');

  static Key topicKey(String id) => Key('sc284_topic_$id');
  static Key predictionKey(String id) => Key('sc284_prediction_$id');
  static Key roomKey(String id) => Key('sc284_room_$id');
  static Key modeKey(String id) => Key('sc284_mode_$id');
  static Key creatorKey(String id) => Key('sc284_creator_$id');

  final String initialTopicId;
  final bool useDetailEndpoint;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TopicHubPage> createState() => _TopicHubPageState();
}

class _TopicHubPageState extends ConsumerState<TopicHubPage> {
  late String _selectedTopicId;

  @override
  void initState() {
    super.initState();
    _selectedTopicId = widget.initialTopicId;
  }

  @override
  Widget build(BuildContext context) {
    final query = (
      topicId: _selectedTopicId,
      detailEndpoint: widget.useDetailEndpoint,
    );
    final snapshotAsync = ref.watch(topicHubSnapshotProvider(query));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    // Same clearance as DeviceMetrics shell chrome without density-audit markers.
    final scrollEndPad =
        (mode.usesVisualQaFrame ? 90.0 + AppSpacing.x6 : 72.0 + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return snapshotAsync.when(
      loading: () => _TopicHubScaffold(
        title: 'Trung tâm chủ đề',
        rail: const SizedBox.shrink(),
        offlineBanner: null,
        scrollEndPad: scrollEndPad,
        body: const VitSkeletonList(key: TopicHubPage.loadingKey),
      ),
      error: (error, stackTrace) => _TopicHubScaffold(
        title: 'Trung tâm chủ đề',
        rail: const SizedBox.shrink(),
        offlineBanner: null,
        scrollEndPad: scrollEndPad,
        body: VitErrorState(
          key: TopicHubPage.errorKey,
          title: 'Không tải được dữ liệu khám phá',
          message: 'Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(topicHubSnapshotProvider(query)),
        ),
      ),
      data: (snapshot) => _TopicHubScaffold(
        title: snapshot.title,
        rail: _TopicRail(
          topics: snapshot.topics,
          selectedTopicId: snapshot.selectedTopic.id,
          onSelect: (topicId) {
            unawaited(HapticFeedback.selectionClick());
            setState(() => _selectedTopicId = topicId);
          },
        ),
        offlineBanner: snapshot.showOfflineBanner
            ? Padding(
                key: TopicHubPage.offlineKey,
                padding: LaunchpadSpacingTokens.discoveryOfflineBannerPadding,
                child: VitOfflineBanner(
                  message: snapshot.staleMessage,
                  detail: snapshot.staleDetail,
                ),
              )
            : null,
        scrollEndPad: scrollEndPad,
        body: VitPageContent(
          rhythm: VitPageRhythm.compact,
          padding: VitContentPadding.none,
          fullBleed: true,
          children: _topicHubPageChildren(
            snapshot: snapshot,
            onRetry: () => ref.invalidate(topicHubSnapshotProvider(query)),
          ),
        ),
      ),
    );
  }
}

class _TopicHubScaffold extends StatelessWidget {
  const _TopicHubScaffold({
    required this.title,
    required this.rail,
    required this.offlineBanner,
    required this.scrollEndPad,
    required this.body,
  });

  final String title;
  final Widget rail;
  final Widget? offlineBanner;
  final double scrollEndPad;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trung tâm chủ đề',
      semanticIdentifier: 'SC-284',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            showBack: true,
            onBack: () => context.go(AppRoutePaths.home),
            actions: [
              VitHeaderActionItem(
                key: TopicHubPage.searchActionKey,
                type: VitHeaderActionType.search,
                onPressed: () => context.go(AppRoutePaths.search),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              rail,
              ?offlineBanner,
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: TopicHubPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding:
                        LaunchpadSpacingTokens.discoveryContentScrollPadding(
                          scrollEndPad,
                        ),
                    child: body,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
