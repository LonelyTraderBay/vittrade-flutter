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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/staking/staking_audit_reports_hero_tabs.dart';
part '../../../widgets/staking/staking_audit_reports_reports_findings.dart';
part '../../../widgets/staking/staking_audit_reports_bounty_common.dart';

class StakingAuditReportsPage extends ConsumerStatefulWidget {
  const StakingAuditReportsPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc374_audit_hero');
  static const statsKey = Key('sc374_audit_stats');
  static const tabsKey = Key('sc374_audit_tabs');
  static const reportsListKey = Key('sc374_audit_reports_list');
  static const bugBountyKey = Key('sc374_bug_bounty');
  static const bugBountyCtaKey = Key('sc374_bug_bounty_cta');
  static const footerKey = Key('sc374_footer');

  static Key reportKey(String id) => Key('sc374_report_$id');
  static Key downloadButtonKey(String id) => Key('sc374_download_$id');
  static Key viewButtonKey(String id) => Key('sc374_view_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingAuditReportsPage> createState() =>
      _StakingAuditReportsPageState();
}

class _StakingAuditReportsPageState
    extends ConsumerState<StakingAuditReportsPage> {
  String? _activeTab;
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingAuditReportsSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Báo cáo kiểm toán độc lập — tham khảo',
      semanticIdentifier: 'SC-374',
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
                  ref.invalidate(stakingAuditReportsSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            _activeTab ??= snapshot.defaultTabId;
            final reports = _filteredReports(snapshot.reports, _activeTab!);

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
                subtitle: 'Báo cáo kiểm toán độc lập — tham khảo',
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
                        gap: VitContentGap.defaultGap,
                        children: [
                          _HeroCard(snapshot: snapshot),
                          _StatsSummary(stats: snapshot.stats),
                          SizedBox(
                            key: StakingAuditReportsPage.tabsKey,
                            child: VitTabBar(
                              variant: VitTabBarVariant.underline,
                              tabs: [
                                for (final tab in snapshot.tabs)
                                  VitTabItem(key: tab.id, label: tab.label),
                              ],
                              activeKey: _activeTab!,
                              onChanged: (id) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() {
                                  _activeTab = id;
                                  _feedback = null;
                                });
                              },
                            ),
                          ),
                          if (_feedback != null)
                            _FeedbackNote(text: _feedback!),
                          _ReportList(
                            reports: reports,
                            onDownload: _downloadReport,
                            onView: _viewReport,
                          ),
                          _BugBountySection(
                            bugBounty: snapshot.bugBounty,
                            onOpen: _openBugBounty,
                          ),
                          _FooterNote(text: snapshot.footerNote),
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

  List<StakingAuditReportDraft> _filteredReports(
    List<StakingAuditReportDraft> reports,
    String tab,
  ) {
    if (tab == 'all') return reports;
    return [
      for (final report in reports)
        if (_typeId(report.type) == tab) report,
    ];
  }

  void _downloadReport(StakingAuditReportDraft report) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _feedback = 'Preparing ${report.title} PDF export');
  }

  void _viewReport(StakingAuditReportDraft report) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _feedback = 'Opening ${report.title}');
  }

  void _openBugBounty() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _feedback = 'Opening Immunefi bug bounty program');
  }
}
