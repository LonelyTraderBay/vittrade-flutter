import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_tax_guide_calculator.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_tax_guide_common.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_tax_guide_header.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_tax_guide_jurisdictions.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_tax_guide_overview.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

class StakingTaxGuidePage extends ConsumerStatefulWidget {
  const StakingTaxGuidePage({super.key, this.shellRenderMode});

  static const disclaimerKey = StakingTaxGuideKeys.disclaimer;
  static const overviewKey = StakingTaxGuideKeys.overview;
  static const summaryKey = StakingTaxGuideKeys.summary;
  static const historyToolKey = StakingTaxGuideKeys.historyTool;
  static const taxReportsToolKey = StakingTaxGuideKeys.taxReportsTool;
  static const calculatorResultKey = StakingTaxGuideKeys.calculatorResult;

  static Key jurisdictionKey(String id) => StakingTaxGuideKeys.jurisdiction(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingTaxGuidePage> createState() =>
      _StakingTaxGuidePageState();
}

class _StakingTaxGuidePageState extends ConsumerState<StakingTaxGuidePage> {
  final _rewardsController = TextEditingController();
  final _rateController = TextEditingController();
  String? _activeTab;
  String _selectedJurisdiction = 'us';

  @override
  void dispose() {
    _rewardsController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingTaxGuideSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hướng dẫn thuế cho thu nhập staking',
      semanticIdentifier: 'SC-356',
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
              onAction: () => ref.invalidate(stakingTaxGuideSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final activeTab = _activeTab ?? snapshot.defaultTab;
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final scrollEndPadding =
                (mode.usesVisualQaFrame
                    ? SharedSpacingTokens.bottomNavVisualClearance
                    : SharedSpacingTokens.bottomNavNativeClearance) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Tham khảo thuế — không phải tư vấn pháp lý',
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsetsDirectional.only(
                        bottom: scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          StakingTaxDisclaimerBanner(snapshot: snapshot),
                          StakingTaxTabs(
                            tabs: snapshot.tabs,
                            active: activeTab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _activeTab = tab);
                            },
                          ),
                          if (activeTab == 'overview')
                            StakingTaxOverviewTab(snapshot: snapshot)
                          else if (activeTab == 'jurisdictions')
                            StakingTaxJurisdictionTab(
                              snapshot: snapshot,
                              selectedId: _selectedJurisdiction,
                              onChanged: (id) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _selectedJurisdiction = id);
                              },
                            )
                          else
                            StakingTaxCalculatorTab(
                              snapshot: snapshot,
                              rewardsController: _rewardsController,
                              rateController: _rateController,
                              onChanged: () => setState(() {}),
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
