import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_notice_widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/security/p2p_transaction_limits_page_sections.dart';
part '../../../widgets/security/p2p_transaction_limits_page_common.dart';

const double _p2pLimitsVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pLimitsNativeNavClearance =
    _p2pLimitsVisualNavClearance - AppSpacing.x4;
const double _p2pLimitsVisualClearance = AppSpacing.x3;
const double _p2pLimitsNativeClearance = AppSpacing.x2;
const double _p2pLimitsSectionGap = AppSpacing.x2;
const double _p2pLimitsMajorGap = AppSpacing.x3;

class P2PTransactionLimitsPage extends ConsumerWidget {
  const P2PTransactionLimitsPage({super.key, this.shellRenderMode});

  static const tierHeroKey = Key('sc266_p2p_limits_tier_hero');
  static const usageKey = Key('sc266_p2p_limits_usage');
  static const trackerLinkKey = Key('sc266_p2p_limits_tracker_link');
  static const detailsKey = Key('sc266_p2p_limits_details');
  static const upgradeKey = Key('sc266_p2p_limits_upgrade');
  static const upgradeCtaKey = Key('sc266_p2p_limits_upgrade_cta');
  static const infoKey = Key('sc266_p2p_limits_info');

  static Key usageItemKey(String id) => Key('sc266_p2p_limits_usage_$id');

  static Key detailItemKey(String id) => Key('sc266_p2p_limits_detail_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pTransactionLimitsProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pLimitsVisualNavClearance + _p2pLimitsVisualClearance
            : _p2pLimitsNativeNavClearance + _p2pLimitsNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hạn mức giao dịch P2P',
      semanticIdentifier: 'SC-266',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pTransactionLimitsProvider),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
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
                      physics: const ClampingScrollPhysics(),
                      padding:
                          P2PSpacingTokens.p2pTransactionLimitsScrollPadding(
                            scrollEndPadding,
                          ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _TierHero(tier: snapshot.currentTier),
                          _CurrentUsage(snapshot: snapshot),
                          _LimitDetails(items: snapshot.detailItems),
                          _UpgradeCard(snapshot: snapshot),
                          _LimitInfoNotice(items: snapshot.infoBullets),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại hạn mức giao dịch',
                            message:
                                'Tier hiện tại, mức đã dùng, chi tiết giới hạn, CTA nâng cấp và ghi chú chính sách được xem lại trước khi tăng hạn mức P2P.',
                            contractId: 'SC-266',
                            density: VitDensity.compact,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
