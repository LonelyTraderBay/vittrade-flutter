import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/referral_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/referral_spacing_tokens.dart';

part '../../widgets/referral_history_page_sections.dart';
part '../../widgets/referral_history_page_common.dart';

class ReferralHistoryPage extends ConsumerStatefulWidget {
  const ReferralHistoryPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc286_referral_history_content');
  static const statsKey = Key('sc286_referral_history_stats');
  static const searchKey = Key('sc286_referral_history_search');
  static const filtersKey = Key('sc286_referral_history_filters');
  static const sortKey = Key('sc286_referral_history_sort');
  static const emptyKey = Key('sc286_referral_history_empty');

  static Key filterKey(ReferralFriendFilter filter) =>
      Key('sc286_filter_${filter.name}');
  static Key sortOptionKey(ReferralHistorySort sort) =>
      Key('sc286_sort_${sort.name}');
  static Key friendKey(String id) => Key('sc286_friend_$id');
  static Key remindKey(String id) => Key('sc286_remind_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ReferralHistoryPage> createState() =>
      _ReferralHistoryPageState();
}

class _ReferralHistoryPageState extends ConsumerState<ReferralHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  ReferralFriendFilter _filter = ReferralFriendFilter.all;
  ReferralHistorySort _sort = ReferralHistorySort.date;
  String? _remindedFriend;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(
      referralHistorySnapshotProvider((
        filter: _filter,
        sort: _sort,
        query: _searchController.text,
      )),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lịch sử giới thiệu',
      semanticIdentifier: 'SC-286',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Lịch sử giới thiệu',
            subtitle: 'Lịch sử · Referral',
            showBack: true,
            onBack: () => context.go(
              historyAsync.value?.backRoute ?? AppRoutePaths.referral,
            ),
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
                    key: ReferralHistoryPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsetsDirectional.only(bottom: bottomInset),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      children: historyAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được lịch sử',
                            message: 'Thử lại sau hoặc quay lại trang chủ.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              referralHistorySnapshotProvider((
                                filter: _filter,
                                sort: _sort,
                                query: _searchController.text,
                              )),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          VitCard(
                            padding: AppSpacing.zeroInsets,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding:
                                      ReferralSpacingTokens.referralCardPadding,
                                  child: _StatsRow(stats: snapshot.stats),
                                ),
                                const Divider(
                                  height: 1,
                                  color: AppColors.divider,
                                ),
                                VitSearchBar(
                                  key: ReferralHistoryPage.searchKey,
                                  controller: _searchController,
                                  placeholder: snapshot.searchHint,
                                  variant: VitSearchBarVariant.compact,
                                  onChanged: (_) => setState(() {}),
                                ),
                                const Divider(
                                  height: 1,
                                  color: AppColors.divider,
                                ),
                                Padding(
                                  padding:
                                      ReferralSpacingTokens.referralCardPadding,
                                  child: _ReferralFriendFilters(
                                    filters: snapshot.filters,
                                    active: snapshot.filter,
                                    onChanged: (value) {
                                      unawaited(
                                        HapticFeedback.selectionClick(),
                                      );
                                      setState(() => _filter = value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _SortRail(
                            options: snapshot.sortOptions,
                            active: snapshot.sort,
                            onChanged: (value) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _sort = value);
                            },
                          ),
                          if (snapshot.friends.isEmpty)
                            const VitEmptyState(
                              key: ReferralHistoryPage.emptyKey,
                              title: 'Không tìm thấy',
                              message: 'Thử thay đổi bộ lọc hoặc từ khóa',
                              icon: Icons.search_rounded,
                            )
                          else
                            for (final friend in snapshot.friends) ...[
                              _FriendCard(
                                friend: friend,
                                reminded: _remindedFriend == friend.id,
                                onOpen: () => context.go(friend.route),
                                onRemind: () {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() => _remindedFriend = friend.id);
                                },
                              ),
                            ],
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
}
