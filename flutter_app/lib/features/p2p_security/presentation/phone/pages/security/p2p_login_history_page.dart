import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/security/p2p_login_history_summary_filters.dart';
part '../../../widgets/security/p2p_login_history_events.dart';
part '../../../widgets/security/p2p_login_history_common.dart';

const double _p2pLoginHistoryVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pLoginHistoryNativeNavClearance =
    _p2pLoginHistoryVisualNavClearance - AppSpacing.x4;
const double _p2pLoginHistoryVisualClearance = AppSpacing.x3;
const double _p2pLoginHistoryNativeClearance = AppSpacing.x2;

class P2PLoginHistoryPage extends ConsumerStatefulWidget {
  const P2PLoginHistoryPage({super.key, this.shellRenderMode});

  static const statsKey = Key('sc257_p2p_login_history_stats');
  static const filtersKey = Key('sc257_p2p_login_history_filters');
  static const warningKey = Key('sc257_p2p_login_history_warning');
  static const eventsKey = Key('sc257_p2p_login_history_events');
  static const infoKey = Key('sc257_p2p_login_history_info');
  static const emptyKey = Key('sc257_p2p_login_history_empty');
  static const downloadKey = Key('sc257_p2p_login_history_download');

  static Key filterKey(String id) => Key('sc257_p2p_login_history_filter_$id');

  static Key eventKey(String id) => Key('sc257_p2p_login_history_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PLoginHistoryPage> createState() =>
      _P2PLoginHistoryPageState();
}

class _P2PLoginHistoryPageState extends ConsumerState<P2PLoginHistoryPage> {
  String _filter = 'all';
  String? _expandedEventId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pLoginHistoryProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pLoginHistoryVisualNavClearance +
                  _p2pLoginHistoryVisualClearance
            : _p2pLoginHistoryNativeNavClearance +
                  _p2pLoginHistoryNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lịch sử đăng nhập P2P',
      semanticIdentifier: 'SC-257',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pSecurityCenter),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pSecurityCenter),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pLoginHistoryProvider),
            ),
          ),
          data: (snapshot) {
            final filteredEvents = snapshot.events
                .where((event) {
                  if (_filter == 'success') return event.status == 'success';
                  if (_filter == 'suspicious') return event.isRiskEvent;
                  return true;
                })
                .toList(growable: false);
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Lịch sử đăng nhập',
                subtitle: 'Bảo mật · P2P',
                showBack: true,
                onBack: () => context.go(snapshot.parentRoute),
                actions: [
                  VitHeaderActionItem(
                    key: P2PLoginHistoryPage.downloadKey,
                    type: VitHeaderActionType.export,
                    onPressed: () => HapticFeedback.selectionClick(),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: AppModuleAccents.p2p,
                      backgroundColor: AppColors.surface2,
                      onRefresh: () async {
                        unawaited(HapticFeedback.selectionClick());
                        await Future<void>.delayed(
                          const Duration(milliseconds: 120),
                        );
                      },
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(
                          context,
                        ).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: ClampingScrollPhysics(),
                          ),
                          padding:
                              P2PSpacingTokens.p2pLoginHistoryPageScrollPadding(
                                scrollEndPadding,
                              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _LoginStats(snapshot: snapshot),
                              const SizedBox(
                                height: AppSpacing.pageRhythmCompactInnerGap,
                              ),
                              VitSegmentedChoice<String>(
                                key: P2PLoginHistoryPage.filtersKey,
                                selected: _filter,
                                onChanged: (value) {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() {
                                    _filter = value;
                                    _expandedEventId = null;
                                  });
                                },
                                options: [
                                  VitSegmentedChoiceOption(
                                    value: 'all',
                                    label: 'Tất cả',
                                    key: P2PLoginHistoryPage.filterKey('all'),
                                    accentColor: AppModuleAccents.p2p,
                                  ),
                                  VitSegmentedChoiceOption(
                                    value: 'success',
                                    label: 'Thành công',
                                    key: P2PLoginHistoryPage.filterKey(
                                      'success',
                                    ),
                                    accentColor: AppModuleAccents.p2p,
                                  ),
                                  VitSegmentedChoiceOption(
                                    value: 'suspicious',
                                    label: 'Đáng ngờ',
                                    key: P2PLoginHistoryPage.filterKey(
                                      'suspicious',
                                    ),
                                    accentColor: AppModuleAccents.p2p,
                                  ),
                                ],
                              ),
                              if (snapshot.riskEventCount > 0 &&
                                  _filter != 'success') ...[
                                const SizedBox(
                                  height: AppSpacing.pageRhythmCompactInnerGap,
                                ),
                                _RiskWarning(snapshot: snapshot),
                              ],
                              const SizedBox(
                                height: AppSpacing.pageRhythmCompactInnerGap,
                              ),
                              if (filteredEvents.isEmpty)
                                _EmptyState(snapshot: snapshot)
                              else
                                _LoginEventList(
                                  events: filteredEvents,
                                  expandedEventId: _expandedEventId,
                                  onToggle: _toggleExpanded,
                                ),
                              const SizedBox(
                                height: AppSpacing.pageRhythmStandardInnerGap,
                              ),
                              _SecurityInfo(snapshot: snapshot),
                              const VitPageContent(
                                rhythm: VitPageRhythm.standard,
                                padding: VitContentPadding.none,
                                fullBleed: true,
                                children: [
                                  VitHighRiskStatePanel(
                                    state: VitHighRiskUiState.riskReview,
                                    title: 'Rà soát lịch sử đăng nhập',
                                    message:
                                        'Bộ lọc rủi ro, sự kiện đáng ngờ, chi tiết phiên mở rộng, xuất dữ liệu và hướng dẫn bảo mật vẫn hiển thị trước khi thao tác truy cập P2P.',
                                    contractId: 'SC-257',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _toggleExpanded(String eventId) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _expandedEventId = _expandedEventId == eventId ? null : eventId;
    });
  }
}
