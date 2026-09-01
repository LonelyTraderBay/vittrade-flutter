import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_viewport_padding.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/challenge/arena_navigation_actions.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part '../../../widgets/studio/arena_creator_hero_trust.dart';
part '../../../widgets/studio/arena_creator_tabs.dart';
part '../../../widgets/studio/arena_creator_common.dart';

const _arenaAccent = AppModuleAccents.arena;
const _creatorAboutLineRatio = ArenaSpacingTokens.arenaCreatorAboutLineHeight;
const _creatorSectionMarkerExtent =
    ArenaSpacingTokens.arenaCreatorSectionMarkerHeight;
const _creatorTabButtonExtent = ArenaSpacingTokens.arenaCreatorTabButtonHeight;

enum _CreatorTab { modes, live, history, about }

class ArenaCreatorPage extends ConsumerStatefulWidget {
  const ArenaCreatorPage({
    super.key,
    required this.creatorId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc193_creator_content');
  static const trustDetailKey = Key('sc193_trust_detail');
  static const viewModeKey = Key('sc193_view_mode');
  static const useModeKey = Key('sc193_use_mode');
  static const policyKey = Key('sc193_policy');

  static Key modeKey(String id) => Key('sc193_mode_$id');

  final String creatorId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaCreatorPage> createState() => _ArenaCreatorPageState();
}

class _ArenaCreatorPageState extends ConsumerState<ArenaCreatorPage> {
  _CreatorTab _activeTab = _CreatorTab.modes;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      arenaCreatorSnapshotProvider(widget.creatorId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hồ sơ nhà sáng tạo (creator) trong Open Arena',
      semanticIdentifier: 'SC-193',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Hồ sơ creator',
            subtitle: 'Nhà sáng tạo · Open Arena',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: ArenaCreatorPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      footerPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      density: VitDensity.compact,
                      children: snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được hồ sơ creator',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              arenaCreatorSnapshotProvider(widget.creatorId),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          _CreatorHero(
                            creator: snapshot.creator,
                            onTrust: () => context.goHaptic(
                              AppRoutePaths.arenaTrust(snapshot.creator.id),
                            ),
                          ),
                          _TrustSection(
                            metrics: snapshot.trustMetrics,
                            onDetails: () => context.goHaptic(
                              AppRoutePaths.arenaTrust(snapshot.creator.id),
                            ),
                          ),
                          VitTabBar(
                            tabs: const [
                              VitTabItem(key: 'modes', label: 'Modes'),
                              VitTabItem(key: 'live', label: 'Live Rooms'),
                              VitTabItem(key: 'history', label: 'Lịch sử'),
                              VitTabItem(key: 'about', label: 'Giới thiệu'),
                            ],
                            activeKey: _activeTab.name,
                            variant: VitTabBarVariant.segment,
                            onChanged: (key) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _activeTab = _tabFromKey(key));
                            },
                          ),
                          _TabContent(
                            activeTab: _activeTab,
                            snapshot: snapshot,
                            onMode: (id) =>
                                context.goHaptic(AppRoutePaths.arenaMode(id)),
                            onUseMode: () =>
                                context.goHaptic(AppRoutePaths.arenaStudio),
                            onGuide: () =>
                                context.goHaptic(AppRoutePaths.arenaGuide),
                          ),
                          _PolicyLink(
                            label: snapshot.policyLabel,
                            onTap: () =>
                                context.goHaptic(AppRoutePaths.arenaSafety),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _CreatorTab _tabFromKey(String key) {
    return _CreatorTab.values.firstWhere(
      (tab) => tab.name == key,
      orElse: () => _CreatorTab.modes,
    );
  }

  void _close() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.arena,
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}
