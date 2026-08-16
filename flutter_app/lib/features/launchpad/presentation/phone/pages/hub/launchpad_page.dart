import 'dart:async';

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
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../../widgets/phone/launchpad_home_header_widgets.dart';
part '../../../widgets/phone/launchpad_home_helpers.dart';
part '../../../widgets/phone/launchpad_home_shared_widgets.dart';
part '../../../widgets/phone/launchpad_home_project_widgets.dart';
part '../../../widgets/phone/launchpad_home_tool_widgets.dart';

const _launchpadLineHeightDense =
    LaunchpadSpacingTokens.launchpadLineHeightDense;
const _launchpadLineHeightCompact =
    LaunchpadSpacingTokens.launchpadLineHeightCompact;
const _launchpadLineHeightLabel =
    LaunchpadSpacingTokens.launchpadLineHeightLabel;
const _launchpadLineHeightReadable =
    LaunchpadSpacingTokens.launchpadLineHeightReadable;
const _launchpadLineHeightShort =
    LaunchpadSpacingTokens.launchpadLineHeightShort;

class LaunchpadPage extends ConsumerStatefulWidget {
  const LaunchpadPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc295_launchpad_content');
  static const heroKey = Key('sc295_launchpad_hero');
  static const filterActionKey = Key('sc295_launchpad_filter');
  static const performanceActionKey = Key('sc295_launchpad_performance');
  static const portfolioActionKey = Key('sc295_launchpad_portfolio');
  static const tabsKey = Key('sc295_launchpad_tabs');
  static const stakingKey = Key('sc295_launchpad_staking');
  static const advancedToolsKey = Key('sc295_launchpad_advanced_tools');
  static const riskToolsKey = Key('sc295_launchpad_risk_tools');
  static const safetyKey = Key('sc295_launchpad_safety');
  static const emptyKey = Key('sc295_launchpad_empty');
  static const emptyActionKey = Key('sc295_launchpad_empty_action');

  static Key projectKey(String id) => Key('sc295_launchpad_project_$id');
  static Key tabKey(String id) => Key('sc295_launchpad_tab_$id');
  static Key toolKey(String id) => Key('sc295_launchpad_tool_$id');
  static Key joinKey(String id) => Key('sc295_launchpad_join_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadPage> createState() => _LaunchpadPageState();
}

class _LaunchpadPageState extends ConsumerState<LaunchpadPage> {
  var _activeTab = _LaunchpadTab.all;

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(launchpadHomeSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trung tâm dự án Launchpad',
      semanticIdentifier: 'SC-295',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          semanticLabel: 'Trung tâm dự án Launchpad – vùng cuộn nội dung',
          semanticIdentifier: 'SC-295',
          header: VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'Launchpad',
            subtitle: 'Dự án mới · Token Launch',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.home),
            actions: [
              VitHeaderActionItem(
                key: LaunchpadPage.filterActionKey,
                type: VitHeaderActionType.filter,
                tooltip: 'Bộ lọc',
                onPressed: () {
                  unawaited(HapticFeedback.selectionClick());
                  setState(() => _activeTab = _LaunchpadTab.active);
                },
              ),
              VitHeaderActionItem(
                key: LaunchpadPage.performanceActionKey,
                type: VitHeaderActionType.analytics,
                tooltip: 'Hiệu suất',
                onPressed: () => context.go(AppRoutePaths.launchpadPerformance),
              ),
              VitHeaderActionItem(
                key: LaunchpadPage.portfolioActionKey,
                type: VitHeaderActionType.portfolio,
                tooltip: 'Portfolio',
                onPressed: () => context.go(AppRoutePaths.launchpadPortfolio),
              ),
            ],
          ),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              key: LaunchpadPage.contentKey,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(bottom: scrollEndPadding),
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.compact,
                density: VitDensity.compact,
                children: [
                  ...homeAsync.when(
                    loading: () => const [VitSkeletonList()],
                    error: (error, stackTrace) => [
                      VitErrorState(
                        title:
                            'Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c Launchpad',
                        message:
                            'Vui l\u00F2ng ki\u1EC3m tra k\u1EBFt n\u1ED1i v\u00E0 th\u1EED l\u1EA1i.',
                        actionLabel: 'Th\u1EED l\u1EA1i',
                        onAction: () =>
                            ref.invalidate(launchpadHomeSnapshotProvider),
                      ),
                    ],
                    data: (snapshot) {
                      final projects = _projectsFor(
                        snapshot.projects,
                        _activeTab,
                      );
                      final activeCount = snapshot.projects
                          .where(
                            (project) =>
                                project.status == LaunchpadProjectStatus.active,
                          )
                          .length;
                      return [
                        _HeroCard(activeCount: activeCount),
                        _LaunchpadTabs(
                          activeTab: _activeTab,
                          onChanged: (tab) => setState(() => _activeTab = tab),
                        ),
                        if (projects.isEmpty)
                          _ProjectsEmptyState(
                            filtered: _activeTab != _LaunchpadTab.all,
                            onShowAll: () =>
                                setState(() => _activeTab = _LaunchpadTab.all),
                          )
                        else
                          for (final project in projects)
                            _ProjectCard(project: project),
                        _StakingEntry(route: snapshot.stakingRoute),
                        _ToolSection(
                          key: LaunchpadPage.advancedToolsKey,
                          title: 'C\u00F4ng c\u1EE5 n\u00E2ng cao',
                          tools: snapshot.advancedTools,
                        ),
                        _ToolSection(
                          key: LaunchpadPage.riskToolsKey,
                          title: 'Trading & Risk Management',
                          tools: snapshot.riskTools,
                        ),
                        const _SafetyWarning(),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
