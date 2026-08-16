import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/discovery_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
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

part '../../widgets/unified_search_shell.dart';
part '../../widgets/unified_search_results.dart';
part '../../widgets/unified_search_prediction_arena_cards.dart';
part '../../widgets/unified_search_entity_cards.dart';
part '../../widgets/unified_search_common.dart';

class UnifiedSearchPage extends ConsumerStatefulWidget {
  const UnifiedSearchPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc283_unified_search_content');
  static const searchKey = Key('sc283_unified_search_field');
  static const offlineKey = Key('sc283_unified_search_offline');
  static const trendingKey = Key('sc283_unified_search_trending');
  static const emptyKey = Key('sc283_unified_search_empty');
  static const loadingKey = Key('sc283_unified_search_loading');
  static const errorKey = Key('sc283_unified_search_error');
  static const disclosureKey = Key('sc283_unified_search_disclosure');

  static Key moduleKey(String id) => Key('sc283_module_$id');
  static Key trendingQueryKey(String label) => Key('sc283_trending_$label');
  static Key resultKey(String kind, String id) =>
      Key('sc283_result_${kind}_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<UnifiedSearchPage> createState() => _UnifiedSearchPageState();
}

class _UnifiedSearchPageState extends ConsumerState<UnifiedSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      unifiedSearchSnapshotProvider(_searchController.text),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tìm kiếm',
      semanticIdentifier: 'SC-283',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tìm kiếm',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.home),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SearchBand(
                controller: _searchController,
                hint: 'Tìm sự kiện, mode, room, creator, coin...',
                onChanged: () => setState(() {}),
              ),
              Expanded(
                child: snapshotAsync.when(
                  loading: () =>
                      const VitSkeletonList(key: UnifiedSearchPage.loadingKey),
                  error: (error, stackTrace) => VitErrorState(
                    key: UnifiedSearchPage.errorKey,
                    title: 'Không tải được dữ liệu khám phá',
                    message: 'Vui lòng thử lại.',
                    actionLabel: 'Thử lại',
                    onAction: () => ref.invalidate(
                      unifiedSearchSnapshotProvider(_searchController.text),
                    ),
                  ),
                  data: (snapshot) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (snapshot.showOfflineBanner)
                        Padding(
                          key: UnifiedSearchPage.offlineKey,
                          padding: LaunchpadSpacingTokens
                              .discoveryOfflineBannerPadding,
                          child: VitOfflineBanner(
                            message: snapshot.staleMessage,
                            detail: snapshot.staleDetail,
                          ),
                        ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(
                            context,
                          ).copyWith(scrollbars: false),
                          child: SingleChildScrollView(
                            key: UnifiedSearchPage.contentKey,
                            physics: const ClampingScrollPhysics(),
                            padding:
                                LaunchpadSpacingTokens.discoveryContentScrollPadding(
                                  scrollEndClearance,
                                ),
                            child: VitPageContent(
                              rhythm: VitPageRhythm.compact,
                              padding: VitContentPadding.none,
                              gap: VitContentGap.tight,
                              fullBleed: true,
                              children: _unifiedSearchPageChildren(
                                snapshot: snapshot,
                                onQuerySelected: (value) => setState(() {
                                  _searchController.text = value;
                                }),
                                onRetry: () => ref.invalidate(
                                  unifiedSearchSnapshotProvider(
                                    _searchController.text,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
