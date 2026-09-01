import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../../../widgets/tools/network_status_cards_stats.dart';
part '../../../widgets/tools/network_status_legend_common.dart';
part '../../../widgets/tools/network_status_summary.dart';

const _networkBorder = AppColors.overlayStroke;
const _networkGreen = AppColors.buy;
const _networkAmber = AppColors.caution;
const _networkOrange = AppColors.riskHigh;
const _networkRed = AppColors.sell;
const _networkMuted = AppColors.text3;
const _networkInlineGap = AppSpacing.x2;
const _networkTinyGap = AppSpacing.x1;
const _networkCardGap = AppSpacing.x2;
const _networkSummaryIconSize = WalletSpacingTokens.walletNetworkSummaryIcon;
const _networkSummaryStatHeight =
    WalletSpacingTokens.walletNetworkSummaryStatHeight;
const _networkLogoSize = AppSpacing.buttonCompact;
const _networkActionIconBoxSize =
    WalletSpacingTokens.walletNetworkActionIconBox;
const _networkStatHeight = WalletSpacingTokens.walletNetworkStatHeight;
const _networkAvailabilityHeight =
    WalletSpacingTokens.walletNetworkAvailabilityHeight;
const _networkCompactStatPadding = WalletSpacingTokens.walletNetworkStatPadding;

double _networkScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? WalletSpacingTokens.walletVisualChromePad
          : WalletSpacingTokens.walletNativeChromePad) +
      MediaQuery.paddingOf(context).bottom;
}

enum _NetworkStatusFilter { all, issues, maintenance }

extension _NetworkStatusFilterX on _NetworkStatusFilter {
  String get key {
    return switch (this) {
      _NetworkStatusFilter.all => 'all',
      _NetworkStatusFilter.issues => 'issues',
      _NetworkStatusFilter.maintenance => 'maintenance',
    };
  }

  String get label {
    return switch (this) {
      _NetworkStatusFilter.all => 'T\u1EA5t c\u1EA3',
      _NetworkStatusFilter.issues => 'C\u1EA7n ch\u00FA \u00FD',
      _NetworkStatusFilter.maintenance => 'B\u1EA3o tr\u00EC',
    };
  }

  IconData get icon {
    return switch (this) {
      _NetworkStatusFilter.all => Icons.hub_outlined,
      _NetworkStatusFilter.issues => Icons.warning_amber_rounded,
      _NetworkStatusFilter.maintenance => Icons.wifi_off_rounded,
    };
  }

  bool includes(WalletNetworkInfo network) {
    return switch (this) {
      _NetworkStatusFilter.all => true,
      _NetworkStatusFilter.issues => network.health != 'operational',
      _NetworkStatusFilter.maintenance => network.health == 'down',
    };
  }
}

_NetworkStatusFilter _networkFilterFromKey(String key) {
  return _NetworkStatusFilter.values.firstWhere(
    (filter) => filter.key == key,
    orElse: () => _NetworkStatusFilter.all,
  );
}

String _networkStatusFilterTabLabel(
  _NetworkStatusFilter filter,
  WalletNetworkStatusSnapshot snapshot,
) {
  return switch (filter) {
    _NetworkStatusFilter.all => '${filter.label} ${snapshot.networks.length}',
    _NetworkStatusFilter.issues =>
      '${filter.label} ${snapshot.issueCount + snapshot.downCount}',
    _NetworkStatusFilter.maintenance => '${filter.label} ${snapshot.downCount}',
  };
}

class NetworkStatusPage extends ConsumerStatefulWidget {
  const NetworkStatusPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc155_network_status_content');
  static const refreshKey = Key('sc155_network_status_refresh');
  static const refreshFeedbackKey = Key(
    'sc155_network_status_refresh_feedback',
  );
  static Key filterKey(String id) => Key('sc155_network_status_filter_$id');
  static Key networkKey(String id) => Key('sc155_network_status_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<NetworkStatusPage> createState() => _NetworkStatusPageState();
}

class _NetworkStatusPageState extends ConsumerState<NetworkStatusPage> {
  _NetworkStatusFilter _filter = _NetworkStatusFilter.all;
  String? _refreshFeedback;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletNetworkStatusProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _networkScrollBottomInset(context, mode);

    return VitAutoHidePageScaffold(
      semanticLabel: 'Trạng thái mạng - phí, độ trễ và tắc nghẽn',
      semanticIdentifier: 'SC-155',
      header: VitHeader(
        title: 'Tr\u1EA1ng th\u00E1i m\u1EA1ng',
        showBack: true,
        onBack: () => context.go(AppRoutePaths.wallet),
      ),
      body: VitInsetScrollView(
        key: NetworkStatusPage.contentKey,
        bottomInset: bottomInset,
        physics: const ClampingScrollPhysics(),
        child: VitPageContent(
          rhythm: VitPageRhythm.standard,
          padding: VitContentPadding.compact,
          density: VitDensity.compact,
          gap: VitContentGap.tight,
          children: [
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Xem lại trạng thái mạng',
              message:
                  'Kiểm tra phí, độ trễ, tắc nghẽn và trạng thái xác nhận trước khi nạp hoặc rút.',
              density: VitDensity.compact,
            ),
            ...snapshotAsync.when(
              loading: () => const [VitSkeletonList()],
              error: (error, stackTrace) => [
                VitErrorState(
                  title: 'Không tải được trạng thái mạng',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(walletNetworkStatusProvider),
                ),
              ],
              data: (snapshot) {
                final networks = _visibleNetworks(snapshot.networks);
                return [
                  _SummaryCard(
                    snapshot: snapshot,
                    refreshFeedback: _refreshFeedback,
                    onRefresh: _refreshNetworkStatus,
                  ),
                  VitTabBar(
                    variant: VitTabBarVariant.segment,
                    activeKey: _filter.key,
                    onChanged: (key) => setState(() {
                      _filter = _networkFilterFromKey(key);
                    }),
                    tabs: [
                      for (final filter in _NetworkStatusFilter.values)
                        VitTabItem(
                          key: filter.key,
                          label: _networkStatusFilterTabLabel(filter, snapshot),
                          icon: filter.icon,
                          widgetKey: NetworkStatusPage.filterKey(filter.key),
                        ),
                    ],
                  ),
                  VitPageSection(
                    label: _filter == _NetworkStatusFilter.all
                        ? 'M\u1EA1ng theo m\u1EE9c \u01B0u ti\u00EAn'
                        : '${_filter.label} (${networks.length})',
                    headerIcon: Icons.route_rounded,
                    headerVariant: VitSectionHeaderVariant.plain,
                    headerDensity: VitDensity.compact,
                    innerGap: AppSpacing.pageRhythmStandardInnerGap,
                    children: [
                      if (networks.isEmpty)
                        const VitEmptyState(
                          title:
                              'Kh\u00F4ng c\u00F3 m\u1EA1ng ph\u00F9 h\u1EE3p',
                          message:
                              'Th\u1EED b\u1ED9 l\u1ECDc kh\u00E1c ho\u1EB7c l\u00E0m m\u1EDBi tr\u1EA1ng th\u00E1i m\u1EA1ng.',
                          icon: Icons.wifi_find_rounded,
                        )
                      else
                        for (final network in networks)
                          _NetworkCard(network: network),
                    ],
                  ),
                  const _LegendCard(),
                  const _DisclaimerCard(),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  List<WalletNetworkInfo> _visibleNetworks(List<WalletNetworkInfo> networks) {
    return [...networks.where(_filter.includes)]..sort((a, b) {
      final priority = _networkPriority(a).compareTo(_networkPriority(b));
      if (priority != 0) return priority;
      return b.congestionPct.compareTo(a.congestionPct);
    });
  }

  void _refreshNetworkStatus() {
    ref.invalidate(walletNetworkStatusProvider);
    setState(() {
      _refreshFeedback =
          '\u0110\u00E3 l\u00E0m m\u1EDBi tr\u1EA1ng th\u00E1i m\u1EA1ng';
    });
  }
}
