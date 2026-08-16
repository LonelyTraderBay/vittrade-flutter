import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../../widgets/tools/launchpad_staking_hero.dart';
part '../../../widgets/tools/launchpad_staking_pool_card.dart';
part '../../../widgets/tools/launchpad_staking_pool_status.dart';
part '../../../widgets/tools/launchpad_staking_positions.dart';
part '../../../widgets/tools/launchpad_staking_calculator.dart';
part '../../../widgets/tools/launchpad_staking_shared.dart';

class LaunchpadStakingPage extends ConsumerStatefulWidget {
  const LaunchpadStakingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc298_launchpad_staking_content');
  static const heroKey = Key('sc298_launchpad_staking_hero');
  static const tabsKey = Key('sc298_launchpad_staking_tabs');
  static const batchClaimKey = Key('sc298_launchpad_staking_batch_claim');
  static const calculatorKey = Key('sc298_launchpad_staking_calculator');
  static const disclaimerKey = Key('sc298_launchpad_staking_disclaimer');

  static Key tabKey(String id) => Key('sc298_launchpad_staking_tab_$id');
  static Key poolKey(String id) => Key('sc298_launchpad_staking_pool_$id');
  static Key positionKey(String id) =>
      Key('sc298_launchpad_staking_position_$id');
  static Key claimKey(String id) => Key('sc298_launchpad_staking_claim_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadStakingPage> createState() =>
      _LaunchpadStakingPageState();
}

enum _StakingTab {
  pools('pools', 'Pools'),
  positions('positions', 'Vị trí của tôi'),
  calculator('calculator', 'Tính APY');

  const _StakingTab(this.id, this.label);

  final String id;
  final String label;
}

class _LaunchpadStakingPageState extends ConsumerState<LaunchpadStakingPage> {
  var _activeTab = _StakingTab.pools;

  @override
  Widget build(BuildContext context) {
    final stakingAsync = ref.watch(launchpadStakingSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Stake token Launchpool và nhận phần thưởng',
      semanticIdentifier: 'SC-298',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          semanticLabel: 'Stake token Launchpool và nhận phần thưởng',
          semanticIdentifier: 'SC-298',
          header: VitHeader(
            title: 'Launchpool Staking',
            subtitle: 'Stake token · Nhận phần thưởng',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.launchpad),
          ),
          child: Column(
            children: [
              _StakingTabs(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: LaunchpadStakingPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: [
                        ...stakingAsync.when(
                          loading: () => const [VitSkeletonList()],
                          error: (error, stackTrace) => [
                            VitErrorState(
                              title: 'Không tải được staking',
                              message: 'Vui lòng kiểm tra kết nối và thử lại.',
                              actionLabel: 'Thử lại',
                              onAction: () => ref.invalidate(
                                launchpadStakingSnapshotProvider,
                              ),
                            ),
                          ],
                          data: (snapshot) => [
                            _StakingHero(snapshot: snapshot),
                            switch (_activeTab) {
                              _StakingTab.pools => _PoolsTab(
                                snapshot: snapshot,
                              ),
                              _StakingTab.positions => _PositionsTab(
                                snapshot: snapshot,
                              ),
                              _StakingTab.calculator => _ApyCalculator(
                                pools: snapshot.pools,
                              ),
                            },
                            const _RiskDisclosure(),
                          ],
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
    );
  }
}

class _StakingTabs extends StatelessWidget {
  const _StakingTabs({required this.activeTab, required this.onChanged});

  final _StakingTab activeTab;
  final ValueChanged<_StakingTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.navBg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: LaunchpadSpacingTokens.launchpadHorizontalContentPadding,
            child: VitSegmentedChoice.withPrimaryAccent<_StakingTab>(
              key: LaunchpadStakingPage.tabsKey,
              selected: activeTab,
              onChanged: onChanged,
              options: [
                for (final tab in _StakingTab.values)
                  VitSegmentedChoiceOption(
                    key: LaunchpadStakingPage.tabKey(tab.id),
                    value: tab,
                    label: tab.label,
                  ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}
