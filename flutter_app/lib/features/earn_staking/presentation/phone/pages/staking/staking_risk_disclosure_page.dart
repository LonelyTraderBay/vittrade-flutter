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
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/staking/staking_risk_disclosure_overview.dart';
part '../../../widgets/staking/staking_risk_disclosure_categories.dart';
part '../../../widgets/staking/staking_risk_disclosure_assessment_common.dart';

const double _stakingRiskWarningMinHeight = 88;
const double _stakingRiskBorderWidth = AppSpacing.hairlineStroke;
const double _stakingRiskWarningIcon = AppSpacing.iconMd;
const double _stakingRiskCountMinHeight = 64;
const double _stakingRiskProductMinHeight = 84;
const double _stakingRiskProductMinHeightTall = 104;
const double _stakingRiskCategoryIconBox = AppSpacing.inputHeight;
const double _stakingRiskCategoryIcon = AppSpacing.iconSm;
const double _stakingRiskAssessmentIconBox = AppSpacing.inputHeight;
const double _stakingRiskAssessmentIcon = AppSpacing.iconMd;
const double _stakingRiskCtaHeight = AppSpacing.buttonCompact + AppSpacing.x1;
const double _stakingRiskDetailBullet =
    AppSpacing.x1 + AppSpacing.hairlineStroke;
const double _stakingRiskBodyLineHeight = 1.35;
const double _stakingRiskSummaryLineHeight = 1.3;
const double _stakingRiskNoticeLineHeight = 1.3;
const double _stakingRiskCompactLineHeight = 1.1;
const EdgeInsetsDirectional _stakingRiskCardPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);
const EdgeInsetsDirectional _stakingRiskDetailsPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _stakingRiskDetailBulletPadding =
    EdgeInsetsDirectional.only(top: AppSpacing.x2);

class StakingRiskDisclosurePage extends ConsumerStatefulWidget {
  const StakingRiskDisclosurePage({super.key, this.shellRenderMode});

  static const warningKey = Key('sc354_risk_warning');
  static const overviewKey = Key('sc354_risk_overview');
  static const assessmentCtaKey = Key('sc354_risk_assessment_cta');

  static Key tabKey(String id) => Key('sc354_risk_tab_$id');
  static Key categoryKey(String id) => Key('sc354_risk_category_$id');
  static Key productKey(String name) => Key('sc354_risk_product_$name');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingRiskDisclosurePage> createState() =>
      _StakingRiskDisclosurePageState();
}

class _StakingRiskDisclosurePageState
    extends ConsumerState<StakingRiskDisclosurePage> {
  String? _activeTab;
  String? _expandedRisk;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingRiskDisclosureSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Công bố rủi ro staking theo từng danh mục',
      semanticIdentifier: 'SC-354',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingRiskDisclosureSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final activeTab = _activeTab ?? snapshot.defaultTab;
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'APY ước tính có thể thay đổi',
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        density: VitDensity.compact,
                        children: [
                          _WarningBanner(snapshot: snapshot),
                          _RiskTabs(
                            tabs: snapshot.tabs,
                            active: activeTab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _activeTab = tab);
                            },
                          ),
                          if (activeTab == 'overview')
                            _OverviewTab(snapshot: snapshot)
                          else if (activeTab == 'categories')
                            _CategoriesTab(
                              snapshot: snapshot,
                              expandedRisk: _expandedRisk,
                              onToggle: (id) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() {
                                  _expandedRisk = _expandedRisk == id
                                      ? null
                                      : id;
                                });
                              },
                            )
                          else
                            _AssessmentTab(
                              snapshot: snapshot,
                              onStart: () =>
                                  context.go(snapshot.assessmentRoute),
                            ),
                        ],
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
}
